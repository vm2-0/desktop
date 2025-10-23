# Clones Desktop - Navigation Map

## Architecture Overview

The application uses **Flutter with Go Router** for navigation and follows **Clean Architecture** with layer separation:
- `lib/ui/views/` : Presentation layer with screens
- `lib/application/` : Business logic and providers  
- `lib/infrastructure/` : External data access
- `lib/domain/` : Entities and models

## Navigation Structure

### Entry Point: main.dart:27
- **Initial route**: `HomeView.routeName` (/)
- **Main layout**: MainLayout wraps LayoutBackground
- **Navigation**: Go Router with ShellRoute structure

### Global Layout
```
┌─────────────────────────────────────────┐
│ MainLayout                              │
│   LayoutBackground                      │
│     ┌─────────────────────────────────┐ │
│     │ Sidebar + Content Area          │ │
│     │                                 │ │
│     │ (Modals overlay when triggered) │ │
│     └─────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

## Main Screens and Navigation

### 1. HOME VIEW (`/`) - Starting Point
**File**: `lib/ui/views/home/layouts/home_view.dart`

**Information displayed**:
- Logo and title "Clone your know-how"
- 2 main options as cards:
  - **Create a Factory** → Navigate to ForgeView (`/forge`)
  - **Farm Data** → Navigate to FactoryView (`/factory`)

**Outbound navigation**:
- `ForgeView.routeName` → `/forge`  
- `FactoryView.routeName` → `/factory`

---

### 2. FORGE VIEW (`/forge`) - Factory Creation and Management
**File**: `lib/ui/views/forge/layouts/forge_view.dart`

**Information displayed**:
- **Grid of existing factories** (ForgeExistingFactoryCard)
- **"New Factory" card** to create a new factory
- **Generation modal** (GenerateFactoryModal) if enabled

**Data processed**:
- List of pools/factories from `listPoolsProvider`
- Wallet connection state required

**Outbound navigation**:
- `/forge/{poolId}/general` → ForgeFactoryDetailShell with General tab
- GenerateFactory modal (overlay)

**Factory Detail Sub-navigation**:
- `/forge/:id/general` → ForgeFactoryGeneralTab
- `/forge/:id/tasks` → ForgeFactoryTasksTab  
- `/forge/:id/demonstrations` → ForgeFactoryUploadsTab

#### 2.1 FORGE FACTORY DETAIL SHELL
**File**: `lib/ui/views/forge_detail/layouts/forge_factory_detail_shell.dart`

**Structure**: Shell route that wraps the 3 factory detail tabs
- **Header**: Factory information (name, stats, etc.)
- **Sidebar**: Navigation between tabs
- **Content**: Active tab content

**Available tabs**:
- **General**: General configuration (name, price, deposit address)
- **Tasks**: Factory task management  
- **Uploads**: Upload history and submissions

---

### 3. FACTORY VIEW (`/factory`) - Data Farm
**File**: `lib/ui/views/factory/layouts/factory_view.dart`

**Information displayed**:
- **Available tasks list** (AvailableTasks component)
- **Search filters** and task sorting
- **Task cards** with details (price, description, etc.)

**Data processed**:
- Available tasks from API
- Filtering by category, price
- Connected wallet state required

**Outbound navigation**:
- `/training_session` → TrainingSessionView (to start a demo)

---

### 4. TRAINING SESSION VIEW (`/training_session`) - Demo Recording
**File**: `lib/ui/views/training_session/layouts/training_session_view.dart`

**Information displayed**:
- **Chat interface** with AI assistant
- **Demonstration objectives** to accomplish
- **Recording panel** with controls
- **Progress messages** and feedback

**Data processed**:
- Chat messages (assistant + user)
- Recording state (active/stopped)
- Target application parameters
- Pool/factory ID
- Prompt/instructions

**Outbound navigation**:
- `/record-overlay` → RecordOverlayView (recording overlay)
- `/factory` → Return after abandon/completion

**Key features**:
- Recorded demonstration upload
- Recording deletion
- Objectives and scoring management

---

### 5. RECORD OVERLAY VIEW (`/record-overlay`) - Recording Overlay
**File**: `lib/ui/views/record_overlay/layouts/record_overlay_view.dart`

**Information displayed**:
- **Header** with recording controls
- **Objectives** in progress to accomplish
- Minimal overlay interface on screen

**Data processed**:
- Real-time recording state
- List of objectives to check off
- Recording time

---

### 6. FACTORY HISTORY VIEW (`/history-factory`) - Recording History
**File**: `lib/ui/views/factory_history/layouts/factory_history_view.dart`

**Information displayed**:
- **Search bar** by factory name
- **Sort dropdown** (newest/oldest)
- **Recording list** with RecordingCard
- **Action buttons**: Open folder, Export

**Data processed**:
- Local recording history
- Demo metadata (date, factory, status)
- Result filtering and sorting

**Outbound navigation**:
- `/demo-detail` → DemoDetailView (with recordingId)

---

### 7. DEMO DETAIL VIEW (`/demo-detail`) - Demo Details
**File**: `lib/ui/views/demo_detail/layouts/demo_detail_view.dart`

**Information displayed**:
- **General info** of the demo (DemoDetailInfos)
- **Video preview** (DemoDetailVideoPreview)
- **Demo steps** (DemoDetailSteps)
- **Submission results** (DemoDetailSubmissionResult)
- **Rewards earned** (DemoDetailRewards)
- **Editor/Events** (Editor/Events tabs)

**Data processed**:
- Complete recording details
- Processing and upload status
- SFT messages (Steps, Feedback, Tools)
- Scoring results

**Available actions**:
- Open in file explorer
- Process recording  
- Export as ZIP
- Upload to platform

---

### 8. LEADERBOARDS VIEW (`/leaderboards`) - Rankings
**File**: `lib/ui/views/leaderboards/layouts/leaderboards_view.dart`

**Information displayed**:
- **Top Forges** with expand capability
- **Top Workers** with expand capability
- **Global statistics**:
  - Total demonstrations
  - Total tasks
  - Total paid out
  - Active forges

**Data processed**:
- Top forge rankings (by payout)
- Top worker rankings (by average score)
- Platform aggregated statistics

**Features**:
- Fullscreen mode for each ranking
- Automatic data refresh

---

### 9. REFERRAL VIEW (`/referral`) - Referral System
**File**: `lib/ui/views/referral/layouts/referral_view.dart`

**Information displayed**:
- **Explanatory header** of referral system
- **Personal referral code** (generatable)
- **Usage instructions**
- **Statistics**:
  - Total referrals
  - Total rewards
- **Referrer code** if applicable

**Data processed**:
- User referral information
- Referral earnings statistics
- Referral history

**States**:
- Initial: Button to generate code
- Loading: Loading information
- Loaded: Complete display with stats

---

## Sidebar Navigation

**File**: `lib/ui/components/sidebar.dart`

**Main menu** (always visible):
1. **Home** (`/`) → HomeView
2. **Forge** (`/forge`) → ForgeView  
3. **Factory** (`/factory`) → FactoryView
4. **Factory History** (`/history-factory`) → FactoryHistoryView
5. **Leaderboards** (`/leaderboards`) → LeaderboardsView
6. **Referral** (`/referral`) → ReferralView

**Visual indicator** for active route with animation

**Special controls**:
- Stop Recording button (if recording active)
- Loading indicator (if recording in progress)

---

## Global Modals and Overlays

### Wallet Modal
- **Trigger**: `WalletModalProvider`
- **Function**: Wallet connection/management
- **Position**: Overlay on any screen

### Upload Progress Modal  
- **Trigger**: `UploadModalProvider`
- **Function**: Demo upload tracking
- **Position**: Overlay on any screen

### Generate Factory Modal
- **Trigger**: From ForgeView
- **Steps**: 3 steps of factory creation
- **Position**: Centered modal

---

## Typical Navigation Flows

### 1. Create a Factory
```
Home → Forge → Generate Factory Modal (3 steps) → Factory Detail
```

### 2. Record a Demo
```
Home → Factory → Training Session → Record Overlay → Training Session (upload)
```

### 3. Manage Demos
```
Factory History → Demo Detail → Actions (process/export/upload)
```

### 4. View Stats
```  
Leaderboards → Fullscreen view → Back to normal view
```

---

### 8. MANAGE TASK MODAL (Overlay) - Task Management
**File**: `lib/ui/views/manage_task/layouts/manage_task_modal.dart`

**Information displayed**:
- **Task configuration form** 
- **Price per demo** settings (ManageTaskModalPricePerDemo)
- **Upload limit** settings (ManageTaskModalUploadLimit)
- **Prompt** configuration (ManageTaskModalPrompt)

**Data processed**:
- Task creation/editing parameters
- Factory task management state

**Trigger**: From ForgeFactoryTasksTab via task management actions

---

## Extension Points for New Features

### Adding a new main screen:
1. Create file in `lib/ui/views/{feature}/layouts/`
2. Add route in `main.dart` router
3. Add entry in `sidebar.dart` buttons
4. Create provider in `lib/application/`

### Adding a sub-screen:
1. Use ShellRoute for tabs (like ForgeDetail)
2. Or direct navigation with `context.go()`

### Adding a modal:
1. Create state provider in `lib/application/`
2. Add modal in `layout_background.dart`
3. Use provider for show/hide

This architecture allows easy extensibility while maintaining clear separation of responsibilities.