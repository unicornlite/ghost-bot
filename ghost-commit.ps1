$ErrorActionPreference = "Stop"

$StartDate = [datetime]"2026-01-01"
$EndDate = (Get-Date)

$Messages = @(
    "Update README.md", "Fix typo in config", "Refactor legacy code", "Update dependencies",
    "Tweak styles", "Cleanup unused imports", "Resolve merge conflicts", "Patch security vulnerability",
    "Add unit tests", "WIP", "Fix minor bug", "Update .gitignore", "Refactor helper functions",
    "Bump version", "Fix lint errors", "Improve performance", "Update documentation",
    "Remove dead code", "Add logging", "Fix typo in comments", "Update docker-compose",
    "Format code", "Add CI/CD workflow", "Update API endpoints"
)

# FIX: Jangan init ulang kalau repo sudah ada. Init buta bikin history divergen dari origin.
$isNewRepo = $false
if (-not (Test-Path ".git")) {
    Write-Host "Initializing git repository..." -ForegroundColor Cyan
    git init
    git branch -m main
    $isNewRepo = $true
} else {
    Write-Host "Repo git sudah ada, skip git init." -ForegroundColor Yellow
    # Pastikan di branch main
    $currentBranch = (git branch --show-current).Trim()
    if ($currentBranch -ne "main") {
        git branch -m main
    }
}

# FIX: Pastikan git identity ada (perlu untuk commit)
if (-not (git config user.name)) {
    git config user.name "ghost-bot"
}
if (-not (git config user.email)) {
    git config user.email "ghost-bot@localhost"
}

# Hanya bikin init commit kalau repo benar-benar baru / belum ada commit
$hasCommits = $true
try { git rev-parse HEAD 2>$null | Out-Null; $hasCommits = ($LASTEXITCODE -eq 0) } catch { $hasCommits = $false }
if ($isNewRepo -or -not $hasCommits) {
    "Ghost protocol initiated." | Out-File -FilePath "GHOST.md" -Encoding utf8
    git add GHOST.md
    git commit -m "Initialize ghost bot" | Out-Null
}

$CurrentDate = $StartDate
while ($CurrentDate -le $EndDate) {
    # Mode stealth: 70% chance commit (sekitar 5 hari aktif dalam seminggu)
    $chance = Get-Random -Minimum 1 -Maximum 101

    if ($chance -le 70) {
        $commitCount = Get-Random -Minimum 1 -Maximum 4
        for ($i = 0; $i -lt $commitCount; $i++) {
            # Jam kerja normal: 08:00 - 18:00
            $hour = Get-Random -Minimum 8 -Maximum 19
            $min = Get-Random -Minimum 0 -Maximum 60
            $sec = Get-Random -Minimum 0 -Maximum 60
            $dateStr = $CurrentDate.AddHours($hour).AddMinutes($min).AddSeconds($sec).ToString("yyyy-MM-ddTHH:mm:ss")

            $env:GIT_AUTHOR_DATE = $dateStr
            $env:GIT_COMMITTER_DATE = $dateStr

            $randomMsg = $Messages | Get-Random

            # Tulis ke file biar commit-nya ada isinya (bukan empty)
            "$dateStr - $randomMsg" | Out-File -FilePath "GHOST.md" -Encoding utf8
            git add GHOST.md
            git commit -m $randomMsg | Out-Null
        }
        Write-Host "Committed $commitCount times for $($CurrentDate.ToString('yyyy-MM-dd'))" -ForegroundColor Green
    } else {
        Write-Host "Skipped $($CurrentDate.ToString('yyyy-MM-dd'))" -ForegroundColor DarkGray
    }

    $CurrentDate = $CurrentDate.AddDays(1)
}

if (Test-Path Env:\GIT_AUTHOR_DATE) { Remove-Item Env:\GIT_AUTHOR_DATE }
if (Test-Path Env:\GIT_COMMITTER_DATE) { Remove-Item Env:\GIT_COMMITTER_DATE }

# Commit workflow file kalau ada perubahan (jangan asal commit)
if (Test-Path ".github/workflows/ghost.yml") {
    git add .github/workflows/ghost.yml
    $staged = (git diff --cached --name-only).Trim()
    if ($staged) {
        git commit -m "Add future ghost automation" | Out-Null
    }
}

# FIX: Script asli tidak pernah push, jadi commit nyangkut di lokal.
# Karena history di-forge ulang, butuh force push pertama kali.
Write-Host "`nPushing to origin/main..." -ForegroundColor Cyan
$hasRemote = (git remote).Trim()
if (-not $hasRemote) {
    Write-Host "[WARN] Belum ada remote 'origin'. Tambahkan dulu:" -ForegroundColor Yellow
    Write-Host "  git remote add origin https://github.com/unicornlite/ghost-bot.git" -ForegroundColor Yellow
} else {
    git push -u origin main --force
    Write-Host "[DONE] Push selesai." -ForegroundColor Cyan
}

Write-Host "`n[DONE] History udah di-generate dengan pola natural (stealth)." -ForegroundColor Cyan
