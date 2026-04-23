# Portfolio rebuild helper: validates README and copies an Agent prompt to the clipboard.
# Run via: Terminal → Run Build Task (Build), or: npm run build / npm run rebuild

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$readme = Join-Path $root 'README.md'
$index = Join-Path $root 'index.html'

if (-not (Test-Path -LiteralPath $readme)) {
  Write-Error "README.md not found: $readme"
  exit 1
}

$prompt = @'
Полностью пересобери файл index.html из текущего README.md по правилам в .cursor/rules (Bootstrap, одна страница, README — источник правды). Не добавляй navbar и полосу быстрых ссылок на якоря. Подзаголовок и аналогичный поясняющий текст — мелким серым шрифтом по всей странице. Сохрани все секции и контент из README без сокращений; пути к изображениям как в README.
'@.Trim()

try {
  Set-Clipboard -Value $prompt
} catch {
  Write-Host "Could not copy to clipboard: $_" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "--- Paste into Cursor Agent ---" -ForegroundColor Cyan
  Write-Host $prompt
  Write-Host "--------------------------------"
  exit 0
}

Write-Host ""
Write-Host "Build (rebuild prompt ready)" -ForegroundColor Cyan
Write-Host "  Source: $readme"
Write-Host "  Target: $index"
Write-Host ""
Write-Host "Instructions for Cursor Agent were copied to the clipboard." -ForegroundColor Green
Write-Host "Paste into chat (Ctrl+V) and run; or use Cursor Generations for this repo if you prefer."
Write-Host ""
