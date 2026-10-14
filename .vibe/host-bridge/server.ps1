$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$BridgeVersion = 'resort-host-bridge/1.1.0'
$RepoRoot = 'D:\TempleNet\WorkSpace\RRH'
$ExpectedHost = 'DESKTOP-QBQU3HP'
$ExpectedEnvironmentId = 'resort-web-desktop-qbqu3hp'
$ExpectedProjectId = 'resort-empire-web'
$ExpectedChatGptProjectId = 'g-p-69251a10d1388191bbf4fa0ebd73adbd'
$Port = 18765
$BridgeRoot = Join-Path $RepoRoot '.vibe\host-bridge'
$TokenPath = Join-Path $BridgeRoot 'token.txt'
$LedgerRoot = Join-Path $BridgeRoot 'ledger'
$RuntimeRoot = Join-Path $BridgeRoot 'runtime'
$EnvironmentPath = Join-Path $RepoRoot '.vibe\environment.json'
$GitExe = 'C:\Program Files\Git\cmd\git.exe'
$MaxBodyBytes = 2MB
$MaxReadBytes = 1MB
$MaxListEntries = 500
$MaxProcessArgs = 64
$MaxProcessArgChars = 8192
$MaxProcessTotalArgChars = 32768
$MaxProcessRunTimeoutMs = 90000
$MaxProcessStdoutChars = 65536
$MaxProcessStderrChars = 32768
$ProcessJobRoot = Join-Path $RuntimeRoot 'process-jobs'
$script:ProcessJobs = @{}
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Get-Sha256Bytes([byte[]]$Bytes) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        return (($sha.ComputeHash($Bytes) | ForEach-Object { $_.ToString('x2') }) -join '')
    } finally {
        $sha.Dispose()
    }
}

function Get-Sha256Text([string]$Text) {
    return Get-Sha256Bytes($Utf8NoBom.GetBytes([string]$Text))
}

function Get-FileSha256([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Write-JsonAtomic([string]$Path, $Value) {
    $dir = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $dir -PathType Container)) {
        [System.IO.Directory]::CreateDirectory($dir) | Out-Null
    }
    $json = $Value | ConvertTo-Json -Depth 40 -Compress
    $tmp = Join-Path $dir ('.tmp-' + [Guid]::NewGuid().ToString('N') + '.json')
    [System.IO.File]::WriteAllText($tmp, $json, $Utf8NoBom)
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        $replaceBackup = Join-Path $dir ('.replace-backup-' + [Guid]::NewGuid().ToString('N') + '.bak')
        try {
            [System.IO.File]::Replace($tmp, $Path, $replaceBackup, $true)
            if (Test-Path -LiteralPath $replaceBackup -PathType Leaf) {
                Remove-Item -LiteralPath $replaceBackup -Force
            }
        } finally {
            if (Test-Path -LiteralPath $replaceBackup -PathType Leaf) {
                Remove-Item -LiteralPath $replaceBackup -Force -ErrorAction SilentlyContinue
            }
        }
    } else {
        [System.IO.File]::Move($tmp, $Path)
    }
}

function Read-EnvironmentAuthority {
    if ($env:COMPUTERNAME -ine $ExpectedHost) {
        throw "ENVIRONMENT_IDENTITY_MISMATCH: host '$($env:COMPUTERNAME)' != '$ExpectedHost'"
    }
    if (-not (Test-Path -LiteralPath $RepoRoot -PathType Container)) {
        throw "ENVIRONMENT_IDENTITY_MISMATCH: repo root missing: $RepoRoot"
    }
    if (-not (Test-Path -LiteralPath $EnvironmentPath -PathType Leaf)) {
        throw "ENVIRONMENT_IDENTITY_MISMATCH: missing $EnvironmentPath"
    }
    $envJson = Get-Content -LiteralPath $EnvironmentPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ([string]$envJson.project_id -ne $ExpectedProjectId) { throw 'ENVIRONMENT_IDENTITY_MISMATCH: project_id' }
    if ([string]$envJson.environment_id -ne $ExpectedEnvironmentId) { throw 'ENVIRONMENT_IDENTITY_MISMATCH: environment_id' }
    if ([string]$envJson.binding_state -ne 'BOUND') { throw 'ENVIRONMENT_IDENTITY_MISMATCH: binding_state' }
    if ([string]$envJson.expected.host_name -ine $ExpectedHost) { throw 'ENVIRONMENT_IDENTITY_MISMATCH: expected.host_name' }
    if ([string]$envJson.expected.repo_root -ine $RepoRoot) { throw 'ENVIRONMENT_IDENTITY_MISMATCH: expected.repo_root' }
    if ([string]$envJson.expected.platform -ine 'windows') { throw 'ENVIRONMENT_IDENTITY_MISMATCH: expected.platform' }
    if ([string]$envJson.expected.shell -ine 'powershell') { throw 'ENVIRONMENT_IDENTITY_MISMATCH: expected.shell' }
    if ([string]$envJson.expected.chatgpt_project_id -ne $ExpectedChatGptProjectId) { throw 'ENVIRONMENT_IDENTITY_MISMATCH: expected.chatgpt_project_id' }
    if ($envJson.installation.written_to_windows_host -ne $true) { throw 'ENVIRONMENT_IDENTITY_MISMATCH: installation.written_to_windows_host' }
    if ($envJson.installation.git_initialized -ne $true) { throw 'ENVIRONMENT_IDENTITY_MISMATCH: installation.git_initialized' }
    return $envJson
}

function Assert-RequestContext($Context) {
    if ($null -eq $Context) { throw 'REQUEST_CONTEXT_REQUIRED' }
    if ([string]$Context.project_id -ne $ExpectedProjectId) { throw 'REQUEST_CONTEXT_MISMATCH: project_id' }
    if ([string]$Context.environment_id -ne $ExpectedEnvironmentId) { throw 'REQUEST_CONTEXT_MISMATCH: environment_id' }
    if ([string]$Context.host_name -ine $ExpectedHost) { throw 'REQUEST_CONTEXT_MISMATCH: host_name' }
    if ([string]$Context.repo_root -ine $RepoRoot) { throw 'REQUEST_CONTEXT_MISMATCH: repo_root' }
    if ([string]$Context.chatgpt_origin -ne 'https://chatgpt.com') { throw 'REQUEST_CONTEXT_MISMATCH: chatgpt_origin' }
    if ([string]$Context.chatgpt_project_id -ne $ExpectedChatGptProjectId) { throw 'REQUEST_CONTEXT_MISMATCH: chatgpt_project_id' }
}

function Test-ReparsePoint([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $item = Get-Item -LiteralPath $Path -Force
    return (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)
}

function Resolve-SafeRepoPath([string]$InputPath, [switch]$AllowRepoRoot) {
    if ([string]::IsNullOrWhiteSpace($InputPath)) { throw 'FS_PATH_REQUIRED' }
    $rootFull = [System.IO.Path]::GetFullPath($RepoRoot).TrimEnd('\')
    if ([System.IO.Path]::IsPathRooted($InputPath)) {
        $candidate = [System.IO.Path]::GetFullPath($InputPath)
    } else {
        $candidate = [System.IO.Path]::GetFullPath((Join-Path $rootFull $InputPath))
    }
    $candidateTrim = $candidate.TrimEnd('\')
    if ($candidateTrim -ieq $rootFull) {
        if (-not $AllowRepoRoot) { throw 'FS_REPO_ROOT_MUTATION_FORBIDDEN' }
        return $rootFull
    }
    $prefix = $rootFull + '\'
    if (-not $candidate.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "FS_PATH_OUTSIDE_REPO: $InputPath"
    }

    $relative = $candidate.Substring($prefix.Length)
    $parts = $relative -split '\\'
    $walk = $rootFull
    foreach ($part in $parts) {
        if ([string]::IsNullOrWhiteSpace($part)) { continue }
        $walk = Join-Path $walk $part
        if (Test-Path -LiteralPath $walk) {
            if (Test-ReparsePoint $walk) {
                throw "FS_REPARSE_POINT_FORBIDDEN: $walk"
            }
        }
    }
    return $candidate
}

function Get-RelativeRepoPath([string]$FullPath) {
    $rootFull = [System.IO.Path]::GetFullPath($RepoRoot).TrimEnd('\')
    $full = [System.IO.Path]::GetFullPath($FullPath)
    if ($full -ieq $rootFull) { return '.' }
    return $full.Substring(($rootFull + '\').Length).Replace('\','/')
}

function Invoke-GitStatus {
    if (-not (Test-Path -LiteralPath $GitExe -PathType Leaf)) { throw "GIT_NOT_FOUND: $GitExe" }
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $GitExe
    $psi.Arguments = '-C "' + $RepoRoot + '" status --porcelain=v2 --branch'
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $psi
    [void]$p.Start()
    if (-not $p.WaitForExit(10000)) {
        try { $p.Kill() } catch {}
        throw 'GIT_STATUS_TIMEOUT'
    }
    $stdout = $p.StandardOutput.ReadToEnd()
    $stderr = $p.StandardError.ReadToEnd()
    return [ordered]@{
        exit_code = $p.ExitCode
        stdout = if ($stdout.Length -gt 20000) { $stdout.Substring(0,20000) } else { $stdout }
        stderr = if ($stderr.Length -gt 10000) { $stderr.Substring(0,10000) } else { $stderr }
    }
}


function ConvertTo-WindowsProcessArgument([string]$Value) {
    if ($null -eq $Value) { return '""' }
    if ($Value.IndexOf([char]0) -ge 0) { throw 'PROCESS_ARGUMENT_NUL_FORBIDDEN' }
    if ($Value.Length -gt $MaxProcessArgChars) { throw "PROCESS_ARGUMENT_TOO_LONG: $($Value.Length)" }
    if ($Value.Length -gt 0 -and $Value -notmatch '[\s"]') { return $Value }

    $sb = New-Object System.Text.StringBuilder
    [void]$sb.Append('"')
    $slashes = 0
    foreach ($ch in $Value.ToCharArray()) {
        if ($ch -eq '\') {
            $slashes++
            continue
        }
        if ($ch -eq '"') {
            if ($slashes -gt 0) { [void]$sb.Append(('\' * ($slashes * 2))) }
            [void]$sb.Append('\')
            [void]$sb.Append('"')
            $slashes = 0
            continue
        }
        if ($slashes -gt 0) {
            [void]$sb.Append(('\' * $slashes))
            $slashes = 0
        }
        [void]$sb.Append($ch)
    }
    if ($slashes -gt 0) { [void]$sb.Append(('\' * ($slashes * 2))) }
    [void]$sb.Append('"')
    return $sb.ToString()
}

function ConvertTo-WindowsProcessArgumentString($Values) {
    $items = @($Values)
    if ($items.Count -gt $MaxProcessArgs) { throw "PROCESS_TOO_MANY_ARGUMENTS: $($items.Count)" }
    $total = 0
    $encoded = @()
    foreach ($item in $items) {
        $value = [string]$item
        $total += $value.Length
        if ($total -gt $MaxProcessTotalArgChars) {
            throw "PROCESS_ARGUMENT_TOTAL_TOO_LARGE: $total"
        }
        $encoded += (ConvertTo-WindowsProcessArgument $value)
    }
    return ($encoded -join ' ')
}

function Resolve-NodeExecutable {
    $known = 'C:\Program Files\nodejs\node.exe'
    if (Test-Path -LiteralPath $known -PathType Leaf) { return $known }
    $cmd = Get-Command node.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -eq $cmd) { return $null }
    $path = [string]$cmd.Source
    if ([string]::IsNullOrWhiteSpace($path) -or -not (Test-Path -LiteralPath $path -PathType Leaf)) { return $null }
    return $path
}

function Resolve-NpmCli([string]$Kind, [string]$NodeExe) {
    if ([string]::IsNullOrWhiteSpace($NodeExe)) { return $null }
    $nodeRoot = Split-Path -Parent $NodeExe
    $leaf = if ($Kind -eq 'npm') { 'npm-cli.js' } else { 'npx-cli.js' }
    $candidate = Join-Path $nodeRoot ("node_modules\npm\bin\" + $leaf)
    if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }

    $shimName = if ($Kind -eq 'npm') { 'npm.cmd' } else { 'npx.cmd' }
    $shim = Get-Command $shimName -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $shim) {
        $shimRoot = Split-Path -Parent ([string]$shim.Source)
        $candidate2 = Join-Path $shimRoot ("node_modules\npm\bin\" + $leaf)
        if (Test-Path -LiteralPath $candidate2 -PathType Leaf) { return $candidate2 }
    }
    return $null
}

function Resolve-ProcessTool([string]$ToolId) {
    $tool = ([string]$ToolId).Trim().ToLowerInvariant()
    switch ($tool) {
        'git' {
            if (-not (Test-Path -LiteralPath $GitExe -PathType Leaf)) { throw "PROCESS_TOOL_UNAVAILABLE: git" }
            return [ordered]@{ id='git'; executable=$GitExe; prefix_args=@(); allow_user_args=$true }
        }
        'node' {
            $node = Resolve-NodeExecutable
            if ($null -eq $node) { throw "PROCESS_TOOL_UNAVAILABLE: node" }
            return [ordered]@{ id='node'; executable=$node; prefix_args=@(); allow_user_args=$true }
        }
        'npm' {
            $node = Resolve-NodeExecutable
            $cli = Resolve-NpmCli 'npm' $node
            if ($null -eq $node -or $null -eq $cli) { throw "PROCESS_TOOL_UNAVAILABLE: npm" }
            return [ordered]@{ id='npm'; executable=$node; prefix_args=@($cli); allow_user_args=$true }
        }
        'npx' {
            $node = Resolve-NodeExecutable
            $cli = Resolve-NpmCli 'npx' $node
            if ($null -eq $node -or $null -eq $cli) { throw "PROCESS_TOOL_UNAVAILABLE: npx" }
            return [ordered]@{ id='npx'; executable=$node; prefix_args=@($cli); allow_user_args=$true }
        }
        'diagnostic.loopback-delay' {
            $ping = Join-Path $env:SystemRoot 'System32\PING.EXE'
            if (-not (Test-Path -LiteralPath $ping -PathType Leaf)) { throw "PROCESS_TOOL_UNAVAILABLE: diagnostic.loopback-delay" }
            return [ordered]@{
                id='diagnostic.loopback-delay'
                executable=$ping
                prefix_args=@('127.0.0.1','-n','10','-w','1000')
                allow_user_args=$false
            }
        }
        default {
            throw "PROCESS_TOOL_NOT_ALLOWLISTED: $ToolId"
        }
    }
}

function Get-ProcessToolInventory {
    $out = @()
    foreach ($id in @('git','node','npm','npx','diagnostic.loopback-delay')) {
        try {
            $spec = Resolve-ProcessTool $id
            $out += [ordered]@{
                id = $id
                available = $true
                executable = [string]$spec.executable
                allow_user_args = [bool]$spec.allow_user_args
            }
        } catch {
            $out += [ordered]@{
                id = $id
                available = $false
                executable = $null
                allow_user_args = $false
                reason = $_.Exception.Message
            }
        }
    }
    return $out
}

function Resolve-ProcessCwd($OpArgs) {
    $cwdInput = [string](Get-BridgeArg $OpArgs 'cwd' '.')
    return Resolve-SafeRepoPath $cwdInput -AllowRepoRoot
}

function Resolve-ProcessArgs($OpArgs, $ToolSpec) {
    $userArgs = @()
    if (Test-BridgeArg $OpArgs 'args') {
        $raw = $OpArgs.args
        if ($null -ne $raw) { $userArgs = @($raw) }
    }
    if (-not [bool]$ToolSpec.allow_user_args -and $userArgs.Count -gt 0) {
        throw "PROCESS_TOOL_ARGUMENTS_FORBIDDEN: $($ToolSpec.id)"
    }
    $effective = @()
    foreach ($a in @($ToolSpec.prefix_args)) { $effective += [string]$a }
    foreach ($a in $userArgs) { $effective += [string]$a }
    [void](ConvertTo-WindowsProcessArgumentString $effective)
    return $effective
}

function New-ProcessStartInfo([string]$Executable, $Arguments, [string]$Cwd) {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $Executable
    $psi.Arguments = ConvertTo-WindowsProcessArgumentString $Arguments
    $psi.WorkingDirectory = $Cwd
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $true
    return $psi
}

function Limit-ProcessText([string]$Text, [int]$Limit) {
    if ($null -eq $Text) { return [ordered]@{ text=''; truncated=$false; original_chars=0 } }
    if ($Text.Length -le $Limit) {
        return [ordered]@{ text=$Text; truncated=$false; original_chars=$Text.Length }
    }
    return [ordered]@{ text=$Text.Substring(0,$Limit); truncated=$true; original_chars=$Text.Length }
}

function Get-ChildProcessIds([int]$ParentPid) {
    try {
        return @(Get-CimInstance -ClassName Win32_Process -Filter ("ParentProcessId = " + $ParentPid) -ErrorAction Stop |
            ForEach-Object { [int]$_.ProcessId })
    } catch {
        return @()
    }
}

function Stop-BridgeProcessTree([int]$RootPid) {
    $children = @(Get-ChildProcessIds $RootPid)
    foreach ($child in $children) {
        if ($child -gt 0 -and $child -ne $RootPid) {
            Stop-BridgeProcessTree $child
        }
    }
    $proc = Get-Process -Id $RootPid -ErrorAction SilentlyContinue
    if ($null -ne $proc) {
        Stop-Process -Id $RootPid -Force -ErrorAction SilentlyContinue
    }
}

function Wait-ProcessGone([int]$PidValue, [int]$TimeoutMs = 5000) {
    $deadline = [DateTime]::UtcNow.AddMilliseconds($TimeoutMs)
    do {
        if ($null -eq (Get-Process -Id $PidValue -ErrorAction SilentlyContinue)) { return $true }
        Start-Sleep -Milliseconds 50
    } while ([DateTime]::UtcNow -lt $deadline)
    return ($null -eq (Get-Process -Id $PidValue -ErrorAction SilentlyContinue))
}

function Invoke-BoundedProcessRun($OpArgs) {
    $toolId = [string](Require-BridgeArg $OpArgs 'tool')
    $spec = Resolve-ProcessTool $toolId
    $cwd = Resolve-ProcessCwd $OpArgs
    $args = Resolve-ProcessArgs $OpArgs $spec

    $timeoutMs = [int](Get-BridgeArg $OpArgs 'timeout_ms' 30000)
    $timeoutMs = [Math]::Max(100, [Math]::Min($MaxProcessRunTimeoutMs, $timeoutMs))

    $psi = New-ProcessStartInfo ([string]$spec.executable) $args $cwd
    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    $started = [DateTime]::UtcNow
    [void]$proc.Start()
    $pidValue = [int]$proc.Id
    $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
    $stderrTask = $proc.StandardError.ReadToEndAsync()

    $timedOut = -not $proc.WaitForExit($timeoutMs)
    $terminated = $false
    $terminationConfirmed = $false

    if ($timedOut) {
        Stop-BridgeProcessTree $pidValue
        $terminationConfirmed = Wait-ProcessGone $pidValue 5000
        $terminated = $terminationConfirmed
        if (-not $terminationConfirmed) {
            throw "PROCESS_TIMEOUT_TERMINATION_UNCONFIRMED: pid=$pidValue"
        }
        try { $proc.WaitForExit() } catch {}
    } else {
        try { $proc.WaitForExit() } catch {}
    }

    try { [void]$stdoutTask.Wait(5000) } catch {}
    try { [void]$stderrTask.Wait(5000) } catch {}

    $stdoutRaw = if ($stdoutTask.IsCompleted) { [string]$stdoutTask.Result } else { '' }
    $stderrRaw = if ($stderrTask.IsCompleted) { [string]$stderrTask.Result } else { '' }
    $stdout = Limit-ProcessText $stdoutRaw $MaxProcessStdoutChars
    $stderr = Limit-ProcessText $stderrRaw $MaxProcessStderrChars

    $exitCode = $null
    try { if ($proc.HasExited) { $exitCode = [int]$proc.ExitCode } } catch {}

    $finished = [DateTime]::UtcNow
    return [ordered]@{
        schema = 'resort-process-run-result/v1'
        tool = [string]$spec.id
        executable = [string]$spec.executable
        args = @($args)
        cwd = Get-RelativeRepoPath $cwd
        pid = $pidValue
        timeout_ms = $timeoutMs
        timed_out = [bool]$timedOut
        terminated = [bool]$terminated
        termination_confirmed = [bool]$terminationConfirmed
        exit_code = $exitCode
        stdout = [string]$stdout.text
        stdout_truncated = [bool]$stdout.truncated
        stdout_original_chars = [int]$stdout.original_chars
        stderr = [string]$stderr.text
        stderr_truncated = [bool]$stderr.truncated
        stderr_original_chars = [int]$stderr.original_chars
        duration_ms = [int][Math]::Max(0, ($finished - $started).TotalMilliseconds)
    }
}

function Assert-ProcessJobId([string]$JobId) {
    if ($JobId -notmatch '^job-[0-9a-f]{24}$') { throw "PROCESS_JOB_ID_INVALID: $JobId" }
}

function Get-ProcessJobPath([string]$JobId) {
    Assert-ProcessJobId $JobId
    return Join-Path $ProcessJobRoot ($JobId + '.json')
}

function Read-ProcessJob([string]$JobId) {
    $path = Get-ProcessJobPath $JobId
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $null }
    return Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Write-ProcessJob([string]$JobId, $Record) {
    $path = Get-ProcessJobPath $JobId
    Write-JsonAtomic $path $Record
}

function Test-ProcessIdentity($Record) {
    $pidValue = [int]$Record.pid
    $proc = Get-Process -Id $pidValue -ErrorAction SilentlyContinue
    if ($null -eq $proc) { return $null }
    try {
        $expected = [DateTime]::Parse([string]$Record.process_start_utc).ToUniversalTime()
        $observed = $proc.StartTime.ToUniversalTime()
        if ([Math]::Abs(($observed - $expected).TotalSeconds) -gt 1.0) {
            throw "PROCESS_PID_IDENTITY_MISMATCH: pid=$pidValue"
        }
    } catch {
        throw
    }
    return $proc
}

function Start-BridgeProcessJob($OpArgs, [string]$RequestId) {
    $toolId = [string](Require-BridgeArg $OpArgs 'tool')
    $spec = Resolve-ProcessTool $toolId
    $cwd = Resolve-ProcessCwd $OpArgs
    $args = Resolve-ProcessArgs $OpArgs $spec
    $jobId = 'job-' + (Get-Sha256Text $RequestId).Substring(0,24)
    $jobPath = Get-ProcessJobPath $jobId
    if (Test-Path -LiteralPath $jobPath -PathType Leaf) {
        throw "PROCESS_JOB_ALREADY_EXISTS: $jobId"
    }

    $psi = New-ProcessStartInfo ([string]$spec.executable) $args $cwd
    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    $started = [DateTime]::UtcNow
    [void]$proc.Start()
    $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
    $stderrTask = $proc.StandardError.ReadToEndAsync()

    $record = [ordered]@{
        schema = 'resort-process-job/v1'
        job_id = $jobId
        request_id = $RequestId
        state = 'RUNNING'
        tool = [string]$spec.id
        executable = [string]$spec.executable
        args = @($args)
        cwd = Get-RelativeRepoPath $cwd
        pid = [int]$proc.Id
        process_start_utc = $proc.StartTime.ToUniversalTime().ToString('o')
        started_at = $started.ToString('o')
    }
    Write-ProcessJob $jobId $record
    $script:ProcessJobs[$jobId] = [ordered]@{
        process = $proc
        stdout_task = $stdoutTask
        stderr_task = $stderrTask
        started = $started
    }

    return [ordered]@{
        schema = 'resort-process-start-result/v1'
        job_id = $jobId
        state = 'RUNNING'
        tool = [string]$spec.id
        executable = [string]$spec.executable
        args = @($args)
        cwd = Get-RelativeRepoPath $cwd
        pid = [int]$proc.Id
        process_start_utc = [string]$record.process_start_utc
    }
}

function Get-BridgeProcessJobStatus([string]$JobId) {
    $record = Read-ProcessJob $JobId
    if ($null -eq $record) { throw "PROCESS_JOB_NOT_FOUND: $JobId" }

    if ([string]$record.state -eq 'STOPPED') {
        return [ordered]@{
            schema='resort-process-status-result/v1'; job_id=$JobId; state='STOPPED';
            pid=[int]$record.pid; exit_code=$record.exit_code;
            stdout=[string]$record.stdout; stderr=[string]$record.stderr;
            capture_state='recorded-by-stop'
        }
    }

    $live = Test-ProcessIdentity $record
    $memory = if ($script:ProcessJobs.ContainsKey($JobId)) { $script:ProcessJobs[$JobId] } else { $null }

    if ($null -ne $live) {
        return [ordered]@{
            schema='resort-process-status-result/v1'; job_id=$JobId; state='RUNNING';
            pid=[int]$record.pid; exit_code=$null; stdout=''; stderr='';
            capture_state=if ($null -ne $memory) { 'pending-in-bridge-memory' } else { 'unavailable-after-bridge-restart' }
        }
    }

    if ($null -ne $memory) {
        $proc = $memory.process
        try { $proc.WaitForExit() } catch {}
        try { [void]$memory.stdout_task.Wait(5000) } catch {}
        try { [void]$memory.stderr_task.Wait(5000) } catch {}
        $stdoutRaw = if ($memory.stdout_task.IsCompleted) { [string]$memory.stdout_task.Result } else { '' }
        $stderrRaw = if ($memory.stderr_task.IsCompleted) { [string]$memory.stderr_task.Result } else { '' }
        $stdout = Limit-ProcessText $stdoutRaw $MaxProcessStdoutChars
        $stderr = Limit-ProcessText $stderrRaw $MaxProcessStderrChars
        $exitCode = $null
        try { if ($proc.HasExited) { $exitCode = [int]$proc.ExitCode } } catch {}
        return [ordered]@{
            schema='resort-process-status-result/v1'; job_id=$JobId; state='EXITED';
            pid=[int]$record.pid; exit_code=$exitCode;
            stdout=[string]$stdout.text; stdout_truncated=[bool]$stdout.truncated;
            stderr=[string]$stderr.text; stderr_truncated=[bool]$stderr.truncated;
            capture_state='completed-in-bridge-memory'
        }
    }

    return [ordered]@{
        schema='resort-process-status-result/v1'; job_id=$JobId; state='NOT_RUNNING';
        pid=[int]$record.pid; exit_code=$null; stdout=''; stderr='';
        capture_state='unavailable-after-bridge-restart'
    }
}

function Stop-BridgeProcessJob([string]$JobId) {
    $record = Read-ProcessJob $JobId
    if ($null -eq $record) { throw "PROCESS_JOB_NOT_FOUND: $JobId" }

    if ([string]$record.state -eq 'STOPPED') {
        return [ordered]@{
            schema='resort-process-stop-result/v1'; job_id=$JobId; state='STOPPED';
            pid=[int]$record.pid; already_stopped=$true; termination_confirmed=$true
        }
    }

    $live = Test-ProcessIdentity $record
    if ($null -ne $live) {
        Stop-BridgeProcessTree ([int]$record.pid)
        if (-not (Wait-ProcessGone ([int]$record.pid) 5000)) {
            throw "PROCESS_STOP_TERMINATION_UNCONFIRMED: $JobId"
        }
    }

    $stdoutText = ''
    $stderrText = ''
    $exitCode = $null
    if ($script:ProcessJobs.ContainsKey($JobId)) {
        $memory = $script:ProcessJobs[$JobId]
        try { $memory.process.WaitForExit() } catch {}
        try { [void]$memory.stdout_task.Wait(5000) } catch {}
        try { [void]$memory.stderr_task.Wait(5000) } catch {}
        if ($memory.stdout_task.IsCompleted) { $stdoutText = [string]$memory.stdout_task.Result }
        if ($memory.stderr_task.IsCompleted) { $stderrText = [string]$memory.stderr_task.Result }
        try { if ($memory.process.HasExited) { $exitCode = [int]$memory.process.ExitCode } } catch {}
    }
    $stdout = Limit-ProcessText $stdoutText $MaxProcessStdoutChars
    $stderr = Limit-ProcessText $stderrText $MaxProcessStderrChars

    $stoppedRecord = [ordered]@{
        schema='resort-process-job/v1'
        job_id=$JobId
        request_id=[string]$record.request_id
        state='STOPPED'
        tool=[string]$record.tool
        executable=[string]$record.executable
        args=@($record.args)
        cwd=[string]$record.cwd
        pid=[int]$record.pid
        process_start_utc=[string]$record.process_start_utc
        started_at=[string]$record.started_at
        stopped_at=[DateTime]::UtcNow.ToString('o')
        exit_code=$exitCode
        stdout=[string]$stdout.text
        stdout_truncated=[bool]$stdout.truncated
        stderr=[string]$stderr.text
        stderr_truncated=[bool]$stderr.truncated
    }
    Write-ProcessJob $JobId $stoppedRecord
    if ($script:ProcessJobs.ContainsKey($JobId)) { $script:ProcessJobs.Remove($JobId) }

    return [ordered]@{
        schema='resort-process-stop-result/v1'
        job_id=$JobId
        state='STOPPED'
        pid=[int]$record.pid
        already_stopped=($null -eq $live)
        termination_confirmed=$true
        exit_code=$exitCode
        stdout=[string]$stdout.text
        stdout_truncated=[bool]$stdout.truncated
        stderr=[string]$stderr.text
        stderr_truncated=[bool]$stderr.truncated
    }
}


function Get-LedgerPath([string]$RequestId) {
    $name = Get-Sha256Text($RequestId)
    return Join-Path $LedgerRoot ($name + '.json')
}

function Read-Ledger([string]$RequestId) {
    $path = Get-LedgerPath $RequestId
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $null }
    return Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Write-Ledger([string]$RequestId, $Value) {
    $path = Get-LedgerPath $RequestId
    Write-JsonAtomic $path $Value
}

function Test-BridgeArg($Object, [string]$Name) {
    return ($null -ne $Object) -and ($Object.PSObject.Properties.Name -contains $Name)
}

function Get-BridgeArg($Object, [string]$Name, $Default = $null) {
    if (Test-BridgeArg $Object $Name) {
        return $Object.$Name
    }
    return $Default
}

function Require-BridgeArg($Object, [string]$Name) {
    if (-not (Test-BridgeArg $Object $Name)) {
        throw "REQUEST_ARG_REQUIRED: $Name"
    }
    return $Object.$Name
}

function Invoke-BridgeOperation([string]$Op, $OpArgs, [string]$RequestId = '') {
    switch ($Op) {
        'capabilities.list' {
            return [ordered]@{
                schema = 'resort-host-capabilities/v1'
                bridge_version = $BridgeVersion
                allowed_ops = @(
                    'capabilities.list','bridge.environment',
                    'fs.stat','fs.list','fs.read','fs.sha256',
                    'fs.mkdir','fs.writeExact',
                    'git.status','request.get',
                    'process.run','process.start','process.status','process.stop'
                )
                mutating_ops = @('fs.mkdir','fs.writeExact','process.run','process.start','process.stop')
                arbitrary_shell = $false
                process_argument_mode = 'array-only'
                process_cwd_policy = 'repo-confined'
                process_run_timeout_max_ms = $MaxProcessRunTimeoutMs
                process_tools = @(Get-ProcessToolInventory)
                repo_root = $RepoRoot
            }
        }
        'bridge.environment' {
            $authority = Read-EnvironmentAuthority
            return [ordered]@{
                project_id = $ExpectedProjectId
                environment_id = $ExpectedEnvironmentId
                host_name = $ExpectedHost
                repo_root = $RepoRoot
                chatgpt_project_id = $ExpectedChatGptProjectId
                binding_state = [string]$authority.binding_state
                git_initialized = [bool]$authority.installation.git_initialized
            }
        }
        'fs.stat' {
            $path = Resolve-SafeRepoPath ([string](Require-BridgeArg $OpArgs 'path')) -AllowRepoRoot
            if (-not (Test-Path -LiteralPath $path)) {
                return [ordered]@{ exists = $false; path = Get-RelativeRepoPath $path }
            }
            $item = Get-Item -LiteralPath $path -Force
            $isFile = -not $item.PSIsContainer
            return [ordered]@{
                exists = $true
                path = Get-RelativeRepoPath $path
                kind = if ($item.PSIsContainer) { 'directory' } else { 'file' }
                length = if ($isFile) { [int64]$item.Length } else { $null }
                sha256 = if ($isFile) { Get-FileSha256 $path } else { $null }
                last_write_utc = $item.LastWriteTimeUtc.ToString('o')
            }
        }
        'fs.list' {
            $path = Resolve-SafeRepoPath ([string](Require-BridgeArg $OpArgs 'path')) -AllowRepoRoot
            if (-not (Test-Path -LiteralPath $path -PathType Container)) { throw "FS_NOT_DIRECTORY: $path" }
            $limit = 200
            $limitValue = Get-BridgeArg $OpArgs 'limit' $null
            if ($null -ne $limitValue) { $limit = [Math]::Max(1,[Math]::Min($MaxListEntries,[int]$limitValue)) }
            $entries = @(Get-ChildItem -LiteralPath $path -Force | Sort-Object @{Expression={$_.PSIsContainer};Descending=$true}, Name | Select-Object -First $limit)
            $out = @()
            foreach ($item in $entries) {
                $out += [ordered]@{
                    name = $item.Name
                    path = Get-RelativeRepoPath $item.FullName
                    kind = if ($item.PSIsContainer) { 'directory' } else { 'file' }
                    length = if ($item.PSIsContainer) { $null } else { [int64]$item.Length }
                    reparse = (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)
                }
            }
            return [ordered]@{ path = Get-RelativeRepoPath $path; entries = $out; truncated = ($entries.Count -ge $limit) }
        }
        'fs.read' {
            $path = Resolve-SafeRepoPath ([string](Require-BridgeArg $OpArgs 'path'))
            if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "FS_NOT_FILE: $path" }
            $info = Get-Item -LiteralPath $path -Force
            if ($info.Length -gt $MaxReadBytes) { throw "FS_READ_TOO_LARGE: $($info.Length) > $MaxReadBytes" }
            $bytes = [System.IO.File]::ReadAllBytes($path)
            return [ordered]@{
                path = Get-RelativeRepoPath $path
                bytes = $bytes.Length
                sha256 = Get-Sha256Bytes $bytes
                content = [System.Text.Encoding]::UTF8.GetString($bytes)
            }
        }
        'fs.sha256' {
            $path = Resolve-SafeRepoPath ([string](Require-BridgeArg $OpArgs 'path'))
            if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "FS_NOT_FILE: $path" }
            return [ordered]@{ path = Get-RelativeRepoPath $path; sha256 = Get-FileSha256 $path }
        }
        'fs.mkdir' {
            [void](Read-EnvironmentAuthority)
            $path = Resolve-SafeRepoPath ([string](Require-BridgeArg $OpArgs 'path'))
            if (Test-Path -LiteralPath $path) {
                if (-not (Test-Path -LiteralPath $path -PathType Container)) { throw "FS_PATH_EXISTS_NOT_DIRECTORY: $path" }
                return [ordered]@{ path = Get-RelativeRepoPath $path; created = $false; existed = $true }
            }
            [System.IO.Directory]::CreateDirectory($path) | Out-Null
            return [ordered]@{ path = Get-RelativeRepoPath $path; created = $true; existed = $false }
        }
        'fs.writeExact' {
            [void](Read-EnvironmentAuthority)
            $path = Resolve-SafeRepoPath ([string](Require-BridgeArg $OpArgs 'path'))
            $content = [string](Require-BridgeArg $OpArgs 'content')
            $exists = Test-Path -LiteralPath $path -PathType Leaf
            if (Test-Path -LiteralPath $path -PathType Container) { throw "FS_TARGET_IS_DIRECTORY: $path" }
            if ($exists) {
                $expected = [string](Get-BridgeArg $OpArgs 'expected_sha256' $null)
                if ([string]::IsNullOrWhiteSpace($expected)) { throw 'FS_CAS_REQUIRED_FOR_EXISTING_FILE' }
                $actual = Get-FileSha256 $path
                if ($actual -ine $expected) { throw "FS_CAS_MISMATCH: expected $expected actual $actual" }
            } else {
                if ((Get-BridgeArg $OpArgs 'expected_absent' $false) -ne $true) { throw 'FS_EXPECTED_ABSENT_REQUIRED_FOR_NEW_FILE' }
            }
            $parent = Split-Path -Parent $path
            if (-not (Test-Path -LiteralPath $parent -PathType Container)) { throw "FS_PARENT_MISSING: $parent" }
            if (Test-ReparsePoint $parent) { throw "FS_REPARSE_POINT_FORBIDDEN: $parent" }
            $bytes = $Utf8NoBom.GetBytes($content)
            $tmp = Join-Path $parent ('.resort-write-' + [Guid]::NewGuid().ToString('N') + '.tmp')
            [System.IO.File]::WriteAllBytes($tmp, $bytes)
            try {
                if ($exists) {
                    $replaceBackup = Join-Path $parent ('.resort-replace-backup-' + [Guid]::NewGuid().ToString('N') + '.bak')
                    try {
                        [System.IO.File]::Replace($tmp, $path, $replaceBackup, $true)
                        if (Test-Path -LiteralPath $replaceBackup -PathType Leaf) {
                            Remove-Item -LiteralPath $replaceBackup -Force
                        }
                    } finally {
                        if (Test-Path -LiteralPath $replaceBackup -PathType Leaf) {
                            Remove-Item -LiteralPath $replaceBackup -Force -ErrorAction SilentlyContinue
                        }
                    }
                } else {
                    [System.IO.File]::Move($tmp, $path)
                }
            } finally {
                if (Test-Path -LiteralPath $tmp -PathType Leaf) { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }
            }
            return [ordered]@{
                path = Get-RelativeRepoPath $path
                bytes = $bytes.Length
                sha256 = Get-FileSha256 $path
                replaced = [bool]$exists
            }
        }
        'process.run' {
            return Invoke-BoundedProcessRun $OpArgs
        }
        'process.start' {
            if ([string]::IsNullOrWhiteSpace($RequestId)) { throw 'PROCESS_REQUEST_ID_REQUIRED' }
            return Start-BridgeProcessJob $OpArgs $RequestId
        }
        'process.status' {
            $jobId = [string](Require-BridgeArg $OpArgs 'job_id')
            Assert-ProcessJobId $jobId
            return Get-BridgeProcessJobStatus $jobId
        }
        'process.stop' {
            $jobId = [string](Require-BridgeArg $OpArgs 'job_id')
            Assert-ProcessJobId $jobId
            return Stop-BridgeProcessJob $jobId
        }
        'git.status' {
            return Invoke-GitStatus
        }
        default {
            throw "OP_UNSUPPORTED: $Op"
        }
    }
}

function Read-HttpRequest([System.Net.Sockets.NetworkStream]$Stream) {
    $memory = New-Object System.IO.MemoryStream
    $buffer = New-Object byte[] 4096
    $headerEnd = -1
    while ($headerEnd -lt 0) {
        $n = $Stream.Read($buffer, 0, $buffer.Length)
        if ($n -le 0) { return $null }
        $memory.Write($buffer, 0, $n)
        if ($memory.Length -gt $MaxBodyBytes) { throw 'HTTP_REQUEST_TOO_LARGE' }
        $all = $memory.ToArray()
        for ($i = 0; $i -le $all.Length - 4; $i++) {
            if ($all[$i] -eq 13 -and $all[$i+1] -eq 10 -and $all[$i+2] -eq 13 -and $all[$i+3] -eq 10) {
                $headerEnd = $i
                break
            }
        }
    }
    $all = $memory.ToArray()
    $headerBytes = New-Object byte[] $headerEnd
    [Array]::Copy($all, 0, $headerBytes, 0, $headerEnd)
    $headerText = [System.Text.Encoding]::ASCII.GetString($headerBytes)
    $lines = $headerText -split "`r`n"
    if ($lines.Count -lt 1) { throw 'HTTP_MALFORMED_REQUEST' }
    $requestLine = $lines[0] -split ' '
    if ($requestLine.Count -lt 2) { throw 'HTTP_MALFORMED_REQUEST_LINE' }
    $headers = @{}
    for ($i = 1; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $colon = $line.IndexOf(':')
        if ($colon -gt 0) {
            $name = $line.Substring(0,$colon).Trim().ToLowerInvariant()
            $value = $line.Substring($colon+1).Trim()
            $headers[$name] = $value
        }
    }
    $contentLength = 0
    if ($headers.ContainsKey('content-length')) { $contentLength = [int]$headers['content-length'] }
    if ($contentLength -gt $MaxBodyBytes) { throw 'HTTP_BODY_TOO_LARGE' }
    $bodyStart = $headerEnd + 4
    $body = New-Object byte[] $contentLength
    $already = [Math]::Min($contentLength, $all.Length - $bodyStart)
    if ($already -gt 0) { [Array]::Copy($all, $bodyStart, $body, 0, $already) }
    $offset = $already
    while ($offset -lt $contentLength) {
        $n = $Stream.Read($body, $offset, $contentLength - $offset)
        if ($n -le 0) { throw 'HTTP_BODY_TRUNCATED' }
        $offset += $n
    }
    return [ordered]@{
        method = [string]$requestLine[0]
        path = [string]$requestLine[1]
        headers = $headers
        body = if ($contentLength -gt 0) { [System.Text.Encoding]::UTF8.GetString($body) } else { '' }
    }
}

function Write-HttpJson([System.Net.Sockets.NetworkStream]$Stream, [int]$StatusCode, $Payload) {
    $statusText = switch ($StatusCode) {
        200 {'OK'} 400 {'Bad Request'} 401 {'Unauthorized'} 404 {'Not Found'} 405 {'Method Not Allowed'} default {'Error'}
    }
    $json = $Payload | ConvertTo-Json -Depth 40 -Compress
    $body = $Utf8NoBom.GetBytes($json)
    $header = "HTTP/1.1 $StatusCode $statusText`r`nContent-Type: application/json; charset=utf-8`r`nContent-Length: $($body.Length)`r`nCache-Control: no-store`r`nConnection: close`r`n`r`n"
    $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
    $Stream.Write($headerBytes, 0, $headerBytes.Length)
    if ($body.Length -gt 0) { $Stream.Write($body, 0, $body.Length) }
    $Stream.Flush()
}

function New-BridgeResponse([string]$RequestId, [string]$Status, $Result, $Error, [string]$FailureDomain, [datetime]$Started) {
    $finished = [DateTime]::UtcNow
    return [ordered]@{
        schema = 'resort-host-response/v1'
        bridge_version = $BridgeVersion
        request_id = $RequestId
        status = $Status
        failure_domain = $FailureDomain
        started_at = $Started.ToString('o')
        finished_at = $finished.ToString('o')
        duration_ms = [int][Math]::Max(0, ($finished - $Started).TotalMilliseconds)
        result = $Result
        error = $Error
    }
}

[void](Read-EnvironmentAuthority)
if (-not (Test-Path -LiteralPath $TokenPath -PathType Leaf)) { throw "BRIDGE_TOKEN_MISSING: $TokenPath" }
$BridgeToken = (Get-Content -LiteralPath $TokenPath -Raw -Encoding ASCII).Trim()
if ($BridgeToken.Length -lt 32) { throw 'BRIDGE_TOKEN_INVALID' }

[System.IO.Directory]::CreateDirectory($LedgerRoot) | Out-Null
[System.IO.Directory]::CreateDirectory($RuntimeRoot) | Out-Null
[System.IO.Directory]::CreateDirectory($ProcessJobRoot) | Out-Null
$statePath = Join-Path $RuntimeRoot 'server-state.json'
Write-JsonAtomic $statePath ([ordered]@{
    schema='resort-host-server-state/v1'; pid=$PID; started_at=[DateTime]::UtcNow.ToString('o');
    bridge_version=$BridgeVersion; host=$ExpectedHost; repo_root=$RepoRoot; port=$Port
})

$listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, $Port)
$listener.Start()

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $client.ReceiveTimeout = 50000
            $client.SendTimeout = 50000
            $stream = $client.GetStream()
            try {
                $req = Read-HttpRequest $stream
                if ($null -eq $req) { continue }
                $token = if ($req.headers.ContainsKey('x-resort-bridge-token')) { [string]$req.headers['x-resort-bridge-token'] } else { '' }
                if ($token -cne $BridgeToken) {
                    Write-HttpJson $stream 401 ([ordered]@{ schema='resort-host-http-error/v1'; error='UNAUTHORIZED' })
                    continue
                }
                $projectHeader = if ($req.headers.ContainsKey('x-resort-chatgpt-project')) { [string]$req.headers['x-resort-chatgpt-project'] } else { '' }
                if ($projectHeader -ne $ExpectedChatGptProjectId) {
                    Write-HttpJson $stream 401 ([ordered]@{ schema='resort-host-http-error/v1'; error='CHATGPT_PROJECT_MISMATCH' })
                    continue
                }

                if ($req.method -eq 'GET' -and $req.path -eq '/v1/health') {
                    [void](Read-EnvironmentAuthority)
                    Write-HttpJson $stream 200 ([ordered]@{
                        schema='resort-host-health/v1'; ok=$true; bridge_version=$BridgeVersion;
                        host=$ExpectedHost; environment_id=$ExpectedEnvironmentId; project_id=$ExpectedProjectId;
                        repo_root=$RepoRoot; port=$Port; pid=$PID
                    })
                    continue
                }

                if ($req.method -ne 'POST' -or $req.path -ne '/v1/request') {
                    Write-HttpJson $stream 404 ([ordered]@{ schema='resort-host-http-error/v1'; error='NOT_FOUND' })
                    continue
                }

                $started = [DateTime]::UtcNow
                $body = $req.body | ConvertFrom-Json
                if ([string]$body.schema -ne 'resort-host-request/v1') { throw 'REQUEST_SCHEMA_MISMATCH' }
                $requestId = [string]$body.request_id
                if ([string]::IsNullOrWhiteSpace($requestId)) { throw 'REQUEST_ID_REQUIRED' }
                if ($requestId.Length -gt 240) { throw 'REQUEST_ID_TOO_LONG' }
                $op = [string]$body.op
                if ([string]::IsNullOrWhiteSpace($op)) { throw 'REQUEST_OP_REQUIRED' }
                Assert-RequestContext $body.context
                [void](Read-EnvironmentAuthority)

                $mutating = @('fs.mkdir','fs.writeExact','process.run','process.start','process.stop') -contains $op
                if ([bool]$body.mutation -ne [bool]$mutating) { throw 'REQUEST_MUTATION_CLASS_MISMATCH' }

                if ($op -eq 'request.get') {
                    $targetId = [string]$body.args.target_request_id
                    if ([string]::IsNullOrWhiteSpace($targetId)) { throw 'TARGET_REQUEST_ID_REQUIRED' }
                    $ledger = Read-Ledger $targetId
                    $result = if ($null -eq $ledger) {
                        [ordered]@{ found=$false; target_request_id=$targetId }
                    } else {
                        [ordered]@{ found=$true; target_request_id=$targetId; ledger=$ledger }
                    }
                    Write-HttpJson $stream 200 (New-BridgeResponse $requestId 'SUCCEEDED' $result $null $null $started)
                    continue
                }

                $requestHash = Get-Sha256Text(($body | ConvertTo-Json -Depth 30 -Compress))
                if ($mutating) {
                    $existing = Read-Ledger $requestId
                    if ($null -ne $existing) {
                        if ([string]$existing.request_hash -ne $requestHash) {
                            $resp = New-BridgeResponse $requestId 'REJECTED' $null ([ordered]@{code='REQUEST_ID_REUSE_MISMATCH';message='request_id already belongs to different payload'}) 'REQUEST_REJECTED' $started
                            Write-HttpJson $stream 200 $resp
                            continue
                        }
                        if ([string]$existing.status -eq 'COMMITTED') {
                            $resp = New-BridgeResponse $requestId 'SUCCEEDED' $existing.result $null $null $started
                            $resp.cached = $true
                            Write-HttpJson $stream 200 $resp
                            continue
                        }
                        $resp = New-BridgeResponse $requestId 'UNKNOWN' $null ([ordered]@{
                            code='MUTATION_OUTCOME_UNKNOWN'; message='Prior mutation request has non-terminal ledger state; blind replay forbidden.'
                        }) 'MUTATION_OUTCOME_UNKNOWN' $started
                        $resp.replay_safe_same_request_id = $false
                        $resp.ledger_status = [string]$existing.status
                        Write-HttpJson $stream 200 $resp
                        continue
                    }

                    Write-Ledger $requestId ([ordered]@{
                        schema='resort-host-request-ledger/v1'; request_id=$requestId; request_hash=$requestHash;
                        op=$op; status='PREPARED'; prepared_at=[DateTime]::UtcNow.ToString('o')
                    })
                }

                try {
                    $result = Invoke-BridgeOperation $op $body.args $requestId
                    if ($mutating) {
                        Write-Ledger $requestId ([ordered]@{
                            schema='resort-host-request-ledger/v1'; request_id=$requestId; request_hash=$requestHash;
                            op=$op; status='COMMITTED'; committed_at=[DateTime]::UtcNow.ToString('o'); result=$result
                        })
                    }
                    Write-HttpJson $stream 200 (New-BridgeResponse $requestId 'SUCCEEDED' $result $null $null $started)
                } catch {
                    if ($mutating) {
                        Write-Ledger $requestId ([ordered]@{
                            schema='resort-host-request-ledger/v1'; request_id=$requestId; request_hash=$requestHash;
                            op=$op; status='UNKNOWN'; unknown_at=[DateTime]::UtcNow.ToString('o');
                            error=[ordered]@{code='MUTATION_EXECUTION_UNKNOWN';message=$_.Exception.Message}
                        })
                        Write-HttpJson $stream 200 (New-BridgeResponse $requestId 'UNKNOWN' $null ([ordered]@{
                            code='MUTATION_EXECUTION_UNKNOWN'; message=$_.Exception.Message
                        }) 'MUTATION_OUTCOME_UNKNOWN' $started)
                    } else {
                        Write-HttpJson $stream 200 (New-BridgeResponse $requestId 'REJECTED' $null ([ordered]@{
                            code='OPERATION_FAILED'; message=$_.Exception.Message
                        }) 'TOOL_EXECUTION_FAILURE' $started)
                    }
                }
            } catch {
                try {
                    Write-HttpJson $stream 400 ([ordered]@{ schema='resort-host-http-error/v1'; error=$_.Exception.Message })
                } catch {}
            } finally {
                try { $stream.Dispose() } catch {}
            }
        } finally {
            try { $client.Close() } catch {}
        }
    }
} finally {
    try { $listener.Stop() } catch {}
    try { Remove-Item -LiteralPath $statePath -Force -ErrorAction SilentlyContinue } catch {}
}
