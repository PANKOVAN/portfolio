# postToolUse: after Agent Write — if README.md changed, remind to regenerate index.html / Generations.
$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }

try {
    $j = $raw | ConvertFrom-Json
} catch {
    exit 0
}

if ($j.tool_name -ne 'Write') { exit 0 }

$ti = $j.tool_input
if (-not $ti) { exit 0 }

$p = $null
$names = @($ti.PSObject.Properties | ForEach-Object { $_.Name })
if ($names -contains 'path') { $p = [string]$ti.path }
elseif ($names -contains 'file_path') { $p = [string]$ti.file_path }

if ([string]::IsNullOrWhiteSpace($p)) { exit 0 }

$norm = $p -replace '\\', '/'
if ($norm -notmatch '(?i)(^|/)README\.md$') { exit 0 }

$msg = @'
[Project policy] README.md was updated; it is the only source of truth for the one-page Bootstrap site.

Required: in this same session, fully rebuild index.html strictly from the current README.md (do not evolve the site via one-off index edits that bypass README).

If rebuild cannot finish here, the user must start a new Cursor Generations run for this repo so index.html is regenerated from README.md.
'@

@{ additional_context = $msg } | ConvertTo-Json -Compress | Write-Output
exit 0
