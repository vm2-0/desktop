//
//  screen_recorder.m
//  Native ScreenCaptureKit → AVAssetWriter → MP4 H.264 recorder
//
//  This is a standalone Objective-C utility that implements the proper
//  Apple recording pipeline for macOS 12.3+
//

#import <Foundation/Foundation.h>
#import <ScreenCaptureKit/ScreenCaptureKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ScreenRecorder : NSObject <SCStreamDelegate, SCStreamOutput>

@property (nonatomic, strong) SCStream *stream;
@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *pixelBufferAdaptor;
@property (nonatomic, strong) NSURL *outputURL;
@property (nonatomic, assign) CGSize recordingSize;
@property (nonatomic, assign) NSInteger frameRate;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) CMTime startTime;
@property (nonatomic, assign) BOOL startTimeSet;

- (instancetype)initWithOutputPath:(NSString *)outputPath 
                             width:(CGFloat)width 
                            height:(CGFloat)height 
                         frameRate:(NSInteger)frameRate;
- (BOOL)startRecording:(NSError **)error;
- (BOOL)stopRecording:(NSError **)error;

@end

@implementation ScreenRecorder

- (instancetype)initWithOutputPath:(NSString *)outputPath 
                             width:(CGFloat)width 
                            height:(CGFloat)height 
                         frameRate:(NSInteger)frameRate {
    self = [super init];
    if (self) {
        _outputURL = [NSURL fileURLWithPath:outputPath];
        _recordingSize = CGSizeMake(width, height);
        _frameRate = frameRate;
        _isRecording = NO;
        _startTimeSet = NO;
    }
    return self;
}

- (BOOL)startRecording:(NSError **)error {
    NSLog(@"[ScreenRecorder] Starting ScreenCaptureKit → AVAssetWriter recording");
    
    // 1. Set up AVAssetWriter first
    if (![self setupAssetWriter:error]) {
        return NO;
    }
    
    // 2. Get shareable content and set up stream
    [SCShareableContent getShareableContentWithCompletionHandler:^(SCShareableContent *content, NSError *error) {
        if (error) {
            NSLog(@"[ScreenRecorder] Error getting shareable content: %@", error.localizedDescription);
            return;
        }
        
        // Get the main display
        SCDisplay *mainDisplay = content.displays.firstObject;
        if (!mainDisplay) {
            NSLog(@"[ScreenRecorder] No displays found");
            return;
        }
        
        // Create stream configuration
        SCStreamConfiguration *config = [[SCStreamConfiguration alloc] init];
        config.width = (int)self.recordingSize.width;
        config.height = (int)self.recordingSize.height;
        config.minimumFrameInterval = CMTimeMake(1, (int32_t)self.frameRate);
        config.pixelFormat = kCVPixelFormatType_32BGRA;
        config.showsCursor = YES;
        
        // Disable screenshot sound and system notifications
        if (@available(macOS 14.0, *)) {
            config.includeChildWindows = NO;
        }
        config.capturesShadowsOnly = NO;
        
        // Create content filter for the main display  
        // Note: This may still trigger system notification sounds on first use
        // The system sound cannot be completely disabled programmatically for security reasons
        SCContentFilter *filter = [[SCContentFilter alloc] initWithDisplay:mainDisplay excludingApplications:@[] exceptingWindows:@[]];
        
        // Create stream
        self.stream = [[SCStream alloc] initWithFilter:filter configuration:config delegate:self];
        
        // Add stream output
        dispatch_queue_t videoQueue = dispatch_queue_create("VideoQueue", DISPATCH_QUEUE_SERIAL);
        NSError *outputError;
        [self.stream addStreamOutput:self type:SCStreamOutputTypeScreen sampleHandlerQueue:videoQueue error:&outputError];
        if (outputError) {
            NSLog(@"[ScreenRecorder] Error adding stream output: %@", outputError.localizedDescription);
        }
        
        // Start streaming
        [self.stream startCaptureWithCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"[ScreenRecorder] Error starting capture: %@", error.localizedDescription);
            } else {
                NSLog(@"[ScreenRecorder] ScreenCaptureKit streaming started");
                self.isRecording = YES;
                
                // Start the asset writer
                [self.assetWriter startWriting];
                [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
            }
        }];
    }];
    
    return YES;
}

- (BOOL)stopRecording:(NSError **)error {
    NSLog(@"[ScreenRecorder] Stopping recording");
    
    self.isRecording = NO;
    
    // Stop the stream synchronously with semaphore
    dispatch_semaphore_t streamSemaphore = dispatch_semaphore_create(0);
    __block NSError *streamError = nil;
    
    [self.stream stopCaptureWithCompletionHandler:^(NSError *error) {
        streamError = error;
        if (error) {
            NSLog(@"[ScreenRecorder] Error stopping capture: %@", error.localizedDescription);
        } else {
            NSLog(@"[ScreenRecorder] ScreenCaptureKit streaming stopped");
        }
        dispatch_semaphore_signal(streamSemaphore);
    }];
    
    // Wait for stream to stop (with timeout)
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC);
    if (dispatch_semaphore_wait(streamSemaphore, timeout) != 0) {
        NSLog(@"[ScreenRecorder] Warning: Stream stop timeout");
    }
    
    // Finalize the asset writer synchronously
    dispatch_semaphore_t writerSemaphore = dispatch_semaphore_create(0);
    __block BOOL writerFinished = NO;
    
    NSLog(@"[ScreenRecorder] Finalizing AVAssetWriter...");
    [self.assetWriter finishWritingWithCompletionHandler:^{
        writerFinished = YES;
        NSLog(@"[ScreenRecorder] AVAssetWriter finished writing");
        dispatch_semaphore_signal(writerSemaphore);
    }];
    
    // Wait for asset writer to finish (with longer timeout for large files)
    timeout = dispatch_time(DISPATCH_TIME_NOW, 10.0 * NSEC_PER_SEC);
    if (dispatch_semaphore_wait(writerSemaphore, timeout) != 0) {
        NSLog(@"[ScreenRecorder] ERROR: Asset writer finalization timeout!");
        if (error) {
            *error = [NSError errorWithDomain:@"ScreenRecorder" 
                                         code:-1 
                                     userInfo:@{NSLocalizedDescriptionKey: @"Asset writer finalization timeout"}];
        }
        return NO;
    }
    
    if (!writerFinished) {
        NSLog(@"[ScreenRecorder] ERROR: Asset writer did not finish properly!");
        if (error) {
            *error = [NSError errorWithDomain:@"ScreenRecorder" 
                                         code:-2 
                                     userInfo:@{NSLocalizedDescriptionKey: @"Asset writer did not finish"}];
        }
        return NO;
    }
    
    // Final verification
    NSLog(@"[ScreenRecorder] Verifying MP4 file...");
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:self.outputURL.path]) {
        NSDictionary *attrs = [fm attributesOfItemAtPath:self.outputURL.path error:nil];
        NSNumber *fileSize = attrs[NSFileSize];
        NSLog(@"[ScreenRecorder] MP4 file created successfully: %@ bytes at: %@", fileSize, self.outputURL.path);
        return YES;
    } else {
        NSLog(@"[ScreenRecorder] ERROR: MP4 file was not created!");
        if (error) {
            *error = [NSError errorWithDomain:@"ScreenRecorder" 
                                         code:-3 
                                     userInfo:@{NSLocalizedDescriptionKey: @"MP4 file was not created"}];
        }
        return NO;
    }
}

- (BOOL)setupAssetWriter:(NSError **)error {
    NSLog(@"[ScreenRecorder] Setting up AVAssetWriter for MP4/H.264");
    
    // Remove existing file
    [[NSFileManager defaultManager] removeItemAtURL:self.outputURL error:nil];
    
    // Create asset writer
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:self.outputURL 
                                                 fileType:AVFileTypeMPEG4 
                                                    error:error];
    if (!self.assetWriter) {
        NSLog(@"[ScreenRecorder] Failed to create AVAssetWriter: %@", (*error).localizedDescription);
        return NO;
    }
    
    // Configure H.264 video settings
    // Target bitrate heuristic: bpppf (bits-per-pixel-per-frame) * width * height * fps
    CGFloat bpppf = 0.07; // UI content: 0.06–0.10 works well @30fps
    NSInteger targetBitrate = (NSInteger)(self.recordingSize.width * self.recordingSize.height * self.frameRate * bpppf);
    if (targetBitrate < 2 * 1000 * 1000) targetBitrate = 2 * 1000 * 1000;      // >= 2 Mbps
    if (targetBitrate > 20 * 1000 * 1000) targetBitrate = 20 * 1000 * 1000;    // <= 20 Mbps
    NSLog(@"[ScreenRecorder] Using target bitrate: %ld bps (%.2f Mbps) for %.0fx%.0f @ %ld",
          (long)targetBitrate, (double)targetBitrate / 1000000.0,
          self.recordingSize.width, self.recordingSize.height, (long)self.frameRate);

    NSDictionary *compressionProps = @{
        AVVideoAverageBitRateKey: @(targetBitrate),
        AVVideoMaxKeyFrameIntervalKey: @(self.frameRate * 2), // keyframe every 2s
        AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
    };

    NSDictionary *videoSettings = @{
        AVVideoCodecKey: AVVideoCodecTypeH264,
        AVVideoWidthKey: @((int)self.recordingSize.width),
        AVVideoHeightKey: @((int)self.recordingSize.height),
        AVVideoCompressionPropertiesKey: compressionProps
    };
    
    // Create video input
    self.videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo 
                                                         outputSettings:videoSettings];
    self.videoInput.expectsMediaDataInRealTime = YES;
    
    // Create pixel buffer adaptor
    NSDictionary *pixelBufferAttributes = @{
        (NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA),
        (NSString *)kCVPixelBufferWidthKey: @((int)self.recordingSize.width),
        (NSString *)kCVPixelBufferHeightKey: @((int)self.recordingSize.height)
    };
    
    self.pixelBufferAdaptor = [AVAssetWriterInputPixelBufferAdaptor 
                               assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.videoInput
                               sourcePixelBufferAttributes:pixelBufferAttributes];
    
    // Add input to writer
    if ([self.assetWriter canAddInput:self.videoInput]) {
        [self.assetWriter addInput:self.videoInput];
    } else {
        if (error) {
            *error = [NSError errorWithDomain:@"ScreenRecorder" 
                                         code:-1 
                                     userInfo:@{NSLocalizedDescriptionKey: @"Cannot add video input to asset writer"}];
        }
        return NO;
    }
    
    NSLog(@"[ScreenRecorder] AVAssetWriter setup complete");
    return YES;
}

#pragma mark - SCStreamOutput

- (void)stream:(SCStream *)stream didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(SCStreamOutputType)type {
    if (!self.isRecording || type != SCStreamOutputTypeScreen) {
        return;
    }
    
    // Set start time on first frame
    if (!self.startTimeSet) {
        self.startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        self.startTimeSet = YES;
    }
    
    // Get the pixel buffer
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (!pixelBuffer) {
        return;
    }
    
    // Calculate presentation time relative to start
    CMTime presentationTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    CMTime relativeTime = CMTimeSubtract(presentationTime, self.startTime);
    
    // Append to asset writer
    if (self.videoInput.isReadyForMoreMediaData) {
        BOOL success = [self.pixelBufferAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:relativeTime];
        if (!success) {
            NSLog(@"[ScreenRecorder] Failed to append pixel buffer");
        }
    }
}

#pragma mark - SCStreamDelegate

- (void)stream:(SCStream *)stream didStopWithError:(NSError *)error {
    NSLog(@"[ScreenRecorder] Stream stopped with error: %@", error.localizedDescription);
    self.isRecording = NO;
}

@end

#pragma mark - Main Function

// Global recorder for signal handling
ScreenRecorder *globalRecorder = nil;
BOOL shouldStop = NO;

void signalHandler(int signal) {
    NSLog(@"[ScreenRecorder] Received signal %d, stopping recording gracefully...", signal);
    shouldStop = YES;
    
    if (globalRecorder && globalRecorder.isRecording) {
        NSError *error;
        BOOL success = [globalRecorder stopRecording:&error];
        if (!success || error) {
            NSLog(@"[ScreenRecorder] Error during signal cleanup: %@", error ? error.localizedDescription : @"Unknown error");
        } else {
            NSLog(@"[ScreenRecorder] Recording stopped successfully via signal handler");
        }
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc != 6) {
            NSLog(@"Usage: %s <output_path> <width> <height> <fps> <duration_seconds>", argv[0]);
            return 1;
        }
        
        NSString *outputPath = [NSString stringWithUTF8String:argv[1]];
        CGFloat width = atof(argv[2]);
        CGFloat height = atof(argv[3]);
        NSInteger fps = atoi(argv[4]);
        NSInteger duration = atoi(argv[5]);
        
        NSLog(@"[ScreenRecorder] Starting recording: %@ (%.0fx%.0f @ %ld fps for %ld seconds)", 
              outputPath, width, height, fps, duration);
        
        // Set up signal handlers for graceful shutdown
        signal(SIGTERM, signalHandler);
        signal(SIGINT, signalHandler);
        
        ScreenRecorder *recorder = [[ScreenRecorder alloc] initWithOutputPath:outputPath 
                                                                        width:width 
                                                                       height:height 
                                                                    frameRate:fps];
        globalRecorder = recorder;
        
        NSError *error;
        if (![recorder startRecording:&error]) {
            NSLog(@"[ScreenRecorder] Failed to start recording: %@", error.localizedDescription);
            return 1;
        }
        
        // Wait for the specified duration or until signal received
        NSLog(@"[ScreenRecorder] Recording for %ld seconds...", duration);
        NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:duration];
        
        while ([NSDate date].timeIntervalSince1970 < endTime.timeIntervalSince1970 && !shouldStop) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        }
        
        if (!shouldStop) {
            NSLog(@"[ScreenRecorder] Duration completed, stopping recording...");
            if (![recorder stopRecording:&error]) {
                NSLog(@"[ScreenRecorder] Failed to stop recording: %@", error.localizedDescription);
                return 1;
            }
        } else {
            NSLog(@"[ScreenRecorder] Recording stopped by signal");
        }
        
        // Brief wait for any final cleanup
        NSLog(@"[ScreenRecorder] Final cleanup...");
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        
        NSLog(@"[ScreenRecorder] Recording completed successfully");
        globalRecorder = nil;
    }
    
    return 0;
}