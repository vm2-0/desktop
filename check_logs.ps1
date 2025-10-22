$logDir = "$env:LOCALAPPDATA\ai.clones.agent\logs"
if (Test-Path $logDir) {
    Write-Host "Agent logs directory: $logDir" -ForegroundColor Cyan
    Write-Host ""
    Get-ChildItem -Path $logDir | Sort-Object LastWriteTime -Descending | Select-Object -First 3 | ForEach-Object {
        Write-Host "=== $($_.Name) ($($.LastWriteTime)) ===" -ForegroundColor Yellow
        Get-Content $_.FullName -Tail 50
        Write-Host ""
    }
} else {
    Write-Host "No agent logs found at: $logDir" -ForegroundColor Red
}
