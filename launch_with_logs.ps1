# Launch clones.exe with Flutter debug logs

$env:FLUTTER_ENGINE_SWITCHES = "--verbose-logging"

Write-Host "Launching Clones Desktop with debug logs..." -ForegroundColor Cyan
Write-Host "Watch for agent-related messages" -ForegroundColor Yellow
Write-Host ""

& "C:\SSe\app\Clones-workspace\clones-desktop\releases\prod\windows\clones-desktop-0.2.33-windows-x64\clones.exe"
