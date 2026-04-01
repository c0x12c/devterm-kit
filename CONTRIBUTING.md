# Contributing to devterm

Thank you for your interest in contributing! devterm is a community project — every improvement helps developers worldwide set up their terminal faster.

## Ways to Contribute

- **Bug reports** — something broken? [Open an issue](.github/ISSUE_TEMPLATE/bug_report.md)
- **Feature requests** — missing something? [Request a feature](.github/ISSUE_TEMPLATE/feature_request.md)
- **Code** — fix bugs, add features, improve docs
- **Testing** — test on different macOS versions and report results

## Development Setup

```bash
git clone https://github.com/c0x12c/devterm-kit.git
cd devterm

# Test your changes (dry run — no real installs)
bash -n setup.sh          # syntax check
bash -n lib/*.sh          # syntax check all libs

# Full shellcheck (if installed)
brew install shellcheck
shellcheck setup.sh install.sh lib/*.sh
```

## Project Structure

```
devterm/
├── install.sh          # One-liner entry point (keep minimal)
├── setup.sh            # Main orchestrator
├── lib/
│   ├── utils.sh        # Logging, colors, helpers — no side effects
│   ├── detect.sh       # System detection
│   ├── fonts.sh        # Font installation
│   ├── shell.sh        # Zsh + Oh My Zsh
│   ├── p10k.sh         # Powerlevel10k
│   ├── plugins.sh      # Zsh plugins
│   ├── tools.sh        # CLI tools
│   ├── iterm2.sh       # Color scheme installation
│   └── zshrc.sh        # .zshrc generation
├── themes/             # Catppuccin .itermcolors files
└── config/             # Default p10k config
```

## Coding Guidelines

**Shell style:**
- Use `#!/usr/bin/env bash` (not `#!/bin/bash`)
- `set -euo pipefail` in main scripts
- Quote all variables: `"$variable"` not `$variable`
- Use `[[ ]]` not `[ ]` for conditionals
- Functions named `snake_case`
- Private helpers prefixed with `_`: `_install_plugin`

**Idempotency:**
Every installation step MUST check if already installed and skip gracefully. Users run devterm multiple times.

```bash
# Good
if [[ -d "$TARGET" ]]; then
  log_skip "Already installed"
  return 0
fi
# ... install ...

# Bad — installs blindly every time
git clone "$URL" "$TARGET"
```

**Error handling:**
- Use `log_error` + `return 1` for non-fatal failures
- Use `log_error` + `exit 1` only for unrecoverable errors (wrong OS, no internet)
- Never silently fail

**No hardcoded paths:**
- Use `$HOME` not `/Users/yourname`
- Use `command -v` to find binaries
- Use `brew --prefix` for Homebrew paths (Intel vs Apple Silicon differ)

## Adding a New CLI Tool

1. Add an `_install_brew_tool` call in `lib/tools.sh`
2. Add the corresponding alias/config in `lib/zshrc.sh`
3. Update the README table
4. Test that it skips correctly when already installed

## Adding a New Theme

devterm currently supports only Catppuccin variants. To add a completely new theme:

1. Create `themes/mytheme.itermcolors`
2. Add it to the `THEME_NAMES` map in `lib/iterm2.sh`
3. Add the theme picker option in `pick_theme()`
4. Update README

## Pull Request Process

1. Fork the repo
2. Create a branch: `git checkout -b feature/my-feature`
3. Make changes following the guidelines above
4. Run shellcheck: `shellcheck setup.sh install.sh lib/*.sh`
5. Test on macOS (both Intel and Apple Silicon if possible)
6. Open a PR with a clear description of what and why

## Commit Message Format

```
type(scope): short description

- detail 1
- detail 2
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`

Examples:
```
feat(tools): add delta for prettier git diffs
fix(fonts): handle spaces in macOS username
docs(readme): add screenshot of Latte theme
```

## Questions?

Open a [GitHub Discussion](https://github.com/c0x12c/devterm-kit/discussions) — happy to help!
