$ErrorActionPreference = 'Stop'
$RepoRoot = 'D:\TempleNet\WorkSpace\RRH'
$BridgeRoot = Join-Path $RepoRoot '.vibe\host-bridge'
$ServerPath = Join-Path $BridgeRoot 'server.ps1'
$TokenPath = Join-Path $BridgeRoot 'token.txt'
$RuntimeRoot = Join-Path $BridgeRoot 'runtime'
$PidPath = Join-Path $RuntimeRoot 'server.pid'
$ExpectedProject = 'g-p-69251a10d1388191bbf4fa0ebd73adbd'
$EnvironmentPath = Join-Path $RepoRoot '.vibe\environment.json'
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.Directory]::CreateDirectory($RuntimeRoot) | Out-Null

if (Test-Path -LiteralPath $PidPath -PathType Leaf) {
    $oldPid = [int](Get-Content -LiteralPath $PidPath -Raw)
    $old = Get-Process -Id $oldPid -ErrorAction SilentlyContinue
    if ($null -ne $old) {
        Write-Output "RESORT_HOST_BRIDGE_ALREADY_RUNNING pid=$oldPid"
        exit 0
    }
    Remove-Item -LiteralPath $PidPath -Force -ErrorAction SilentlyContinue
}

$proc = Start-Process -FilePath 'powershell.exe' -ArgumentList @(
    '-NoProfile','-ExecutionPolicy','Bypass','-File',"`"$ServerPath`""
) -WindowStyle Hidden -PassThru
Set-Content -LiteralPath $PidPath -Value ([string]$proc.Id) -Encoding ASCII
Start-Sleep -Milliseconds 800

$token = (Get-Content -LiteralPath $TokenPath -Raw -Encoding ASCII).Trim()
$headers = @{
    'X-Resort-Bridge-Token' = $token
    'X-Resort-ChatGPT-Project' = $ExpectedProject
}
try {
    $health = Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:18765/v1/health' -Headers $headers -TimeoutSec 5
    if ($health.ok -ne $true) { throw 'health.ok != true' }

    # Persist factual bridge-install state only after successful authenticated health.
    $envAuthority = Get-Content -LiteralPath $EnvironmentPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $envAuthority.policy.local_mutation_bridge_enabled = $true
    if (-not ($envAuthority.installation.PSObject.Properties.Name -contains 'host_bridge_installed')) {
        $envAuthority.installation | Add-Member -NotePropertyName host_bridge_installed -NotePropertyValue $true
    } else {
        $envAuthority.installation.host_bridge_installed = $true
    }
    if (-not ($envAuthority.installation.PSObject.Properties.Name -contains 'host_bridge_version')) {
        $envAuthority.installation | Add-Member -NotePropertyName host_bridge_version -NotePropertyValue ([string]$health.bridge_version)
    } else {
        $envAuthority.installation.host_bridge_version = [string]$health.bridge_version
    }
    if (-not ($envAuthority.installation.PSObject.Properties.Name -contains 'host_bridge_port')) {
        $envAuthority.installation | Add-Member -NotePropertyName host_bridge_port -NotePropertyValue 18765
    } else {
        $envAuthority.installation.host_bridge_port = 18765
    }
    $authorityJson = $envAuthority | ConvertTo-Json -Depth 40
    [System.IO.File]::WriteAllText($EnvironmentPath, ($authorityJson.TrimEnd() + "`r`n"), $Utf8NoBom)

    Write-Output ("RESORT_HOST_BRIDGE_STARTED pid={0} version={1}" -f $proc.Id,$health.bridge_version)
} catch {
    try { Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue } catch {}
    Remove-Item -LiteralPath $PidPath -Force -ErrorAction SilentlyContinue
    throw
}
