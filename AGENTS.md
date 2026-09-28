# Ghost Bot (Contribution Generator)

This repository automates GitHub contribution graph activity using empty commits with forged timestamps.

- **Architecture**: 
  - `ghost-commit.ps1`: Local PowerShell script to backfill historical commits.
  - `.github/workflows/ghost.yml`: GitHub Action to automate daily ongoing commits.
- **Quirks & Conventions**:
  - **No Real Code**: Commits are explicitly empty (`git commit --allow-empty`). Do not add application code, tests, or build toolchains.
  - **Environment Overrides**: Scripts intentionally override `GIT_AUTHOR_DATE` and `GIT_COMMITTER_DATE` to forge history.
  - **Dual Implementations**: The logic exists in both PowerShell (for initial local backfill) and Bash (for GitHub Actions). If changing behavior or commit message templates, update **both** files.
- **Testing**: Verify local script changes by running `.\ghost-commit.ps1` and inspecting `git log`. Note that the script automatically runs `git init` and generates a local `GHOST.md` file.