$logPath = "$env:LOCALAPPDATA\ai.clones.agent\logs\logs.log"
if (Test-Path $logPath) {
    Write-Host "Latest 100 lines from agent logs:" -ForegroundColor Cyan
    Get-Content $logPath -Tail 100
} else {
    Write-Host "No logs found at: $logPath" -ForegroundColor Red
}
