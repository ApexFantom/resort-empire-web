$ErrorActionPreference = 'Stop'
$PidPath = 'D:\TempleNet\WorkSpace\RRH\.vibe\host-bridge\runtime\server.pid'
if (-not (Test-Path -LiteralPath $PidPath -PathType Leaf)) {
    Write-Output 'RESORT_HOST_BRIDGE_NOT_RUNNING'
    exit 0
}
$pidValue = [int](Get-Content -LiteralPath $PidPath -Raw)
$proc = Get-Process -Id $pidValue -ErrorAction SilentlyContinue
if ($null -ne $proc) {
    Stop-Process -Id $pidValue -Force
}
Remove-Item -LiteralPath $PidPath -Force -ErrorAction SilentlyContinue
Write-Output "RESORT_HOST_BRIDGE_STOPPED pid=$pidValue"
