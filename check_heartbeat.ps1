$tempPath = [System.IO.Path]::GetTempPath()
Write-Host "Temp directory: $tempPath" -ForegroundColor Cyan
Get-ChildItem -Path $tempPath -Filter "clones-flutter-*.heartbeat" -ErrorAction SilentlyContinue | 
    Sort-Object LastWriteTime -Descending | 
    Select-Object -First 10 | 
    Format-Table Name, LastWriteTime, Length -AutoSize
