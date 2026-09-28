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

Write-Host "Initializing git repository..." -ForegroundColor Cyan
git init
git branch -m main

"Ghost protocol initiated." | Out-File -FilePath "GHOST.md" -Encoding utf8
git add GHOST.md
git commit -m "Initialize ghost bot" | Out-Null

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

git add .github/workflows/ghost.yml
git commit -m "Add future ghost automation" | Out-Null

Write-Host "`n[DONE] History udah di-generate dengan pola natural (stealth)." -ForegroundColor Cyan
