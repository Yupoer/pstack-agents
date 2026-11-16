param(
    [Parameter(Mandatory)][string]$RepoRoot,
    [string]$Log = (Join-Path $HOME '.codex\pstack\auto-sync.log')
)

# Pull this fork's main when GitHub has new commits, reinstall pstack for Codex, then update the Claude Code plugin.
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Path (Split-Path $Log -Parent) -Force | Out-Null
function Write-Log($message) { Add-Content -LiteralPath $Log -Value "$(Get-Date -Format s) $message" }

try {
    $RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path
    git -C $RepoRoot fetch origin main --quiet
    $branch = (git -C $RepoRoot branch --show-current).Trim()
    $dirty = git -C $RepoRoot status --porcelain
    $behind = [int](git -C $RepoRoot rev-list --count HEAD..origin/main)
    if ($branch -ne 'main') { Write-Log "skip: checkout is on '$branch', not main"; return }
    if ($dirty) { Write-Log 'skip: working tree has uncommitted changes'; return }
    if ($behind -gt 0) {
        git -C $RepoRoot merge --ff-only origin/main --quiet
        Write-Log "pulled $behind commit(s) to $(git -C $RepoRoot rev-parse --short HEAD)"
        & (Join-Path $RepoRoot 'codex\sync-pstack.ps1') -SourceRoot $RepoRoot | ForEach-Object { Write-Log $_ }
    } else {
        Write-Log 'repo already current'
    }
    if (Get-Command claude -ErrorAction SilentlyContinue) {
        claude plugin marketplace update cursor-plugins 2>&1 | ForEach-Object { Write-Log "claude: $_" }
        claude plugin update pstack@cursor-plugins 2>&1 | ForEach-Object { Write-Log "claude: $_" }
    }
} catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    throw
}
