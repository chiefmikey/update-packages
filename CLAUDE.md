# Project CLAUDE.md - Update Packages

## Project Overview

GitHub Action for automatically updating npm package dependencies — runs on a cron schedule, checks for updates, and creates PRs.

## Tech Stack

- **Language:** Bash (shell script)
- **Platform:** GitHub Actions
- **Module type:** ESM (`"type": "module"`)
- **Linting:** mikey-pro (ESLint + Prettier + Stylelint)

## Architecture

```
src/
  update-package.sh     # Main update script (runs in GitHub Actions)
action.yml              # GitHub Action definition (inputs: cron-schedule, package-lock, pr-title, pr-per, pr-labels)
eslint.config.js        # ESLint flat config
```

## Commands

No npm scripts defined. This is a GitHub Action — used via `uses:` in workflow files.

## Action Inputs

- `cron-schedule` — Cron schedule for updates (default: `0 0 * * *`)
- `package-lock` — Whether to update package-lock.json (default: `true`)
- `pr-title` — PR title (default: `chore(dependencies): bump`)
- `pr-per` — Create a PR per update (default: `true`)
- `pr-labels` — Labels to apply to PRs

## Conventions

- Prettier via `mikey-pro/prettier`
- Stylelint via `mikey-pro/stylelint`
- Conventional commits

## Testing

No tests. GitHub Action tested via workflow runs.
