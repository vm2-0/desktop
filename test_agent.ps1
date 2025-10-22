$agentPath = "C:\SSe\app\Clones-workspace\clones-desktop\releases\prod\windows\clones-desktop-0.2.33-windows-x64\agent\clones-desktop.exe"
$env:CLONES_DEV_MODE = "true"
$env:PRIMARY_LOGGER = "true"
$env:RUST_LOG = "debug"

Write-Host "Agent launching..." -ForegroundColor Cyan
& $agentPath
