# devterm — Growth & Community Strategy

> How to make devterm vibe and attract developers to use and contribute.

---

## The Core Insight

Terminal tools that go viral share one formula:

**Visual proof** (a GIF showing before → after) + **Frictionless install** (one command) + **Opinionated aesthetic** (Catppuccin + Starship in 2025) + **Targeted community** (r/unixporn, Starship users)

devterm v2.0 already has the right stack. The gap is packaging and distribution.

---

## What devterm Has That Competitors Don't

Before distributing, know your moat:

| Feature | devterm | typical dotfiles scripts | ohmyzsh installers |
|---|---|---|---|
| Starship (not dead p10k) | ✅ | mixed | rarely |
| Catppuccin (all 4 flavors) | ✅ | sometimes | no |
| macOS + Linux | ✅ | usually macOS only | macOS |
| `--doctor` health check | ✅ | ❌ | ❌ |
| BATS tests on bash code | ✅ | ❌ | ❌ |
| Idempotent (safe to re-run) | ✅ | sometimes | no |
| CI (ShellCheck + structure) | ✅ | ❌ | rarely |

**Tagline**: _"One command. Starship + Catppuccin. macOS + Linux."_

---

## Phase 1 — Foundation (Do Before Posting Anywhere)

These are table stakes. Without them, the launch will underperform.

### 1.1 The Demo GIF (Highest ROI Action)

A GIF of the install running is worth more than any article. People on Reddit and Twitter decide in 3 seconds.

**Tool to use: [VHS by Charm](https://github.com/charmbracelet/vhs)**

```bash
brew install vhs
```

Create `docs/demo.tape`:

```
Output docs/demo.gif

Set Shell "bash"
Set FontSize 14
Set Width 1200
Set Height 600
Set Theme "Catppuccin Mocha"

Type "# devterm — one command to a senior dev's terminal"
Sleep 1s
Enter
Sleep 500ms

Type "./setup.sh --theme mocha"
Sleep 500ms
Enter

# Let the install run (you need a real run or simulate it)
Sleep 8s
```

**What to show in the GIF:**
1. Blank terminal (the "before")
2. Run `./setup.sh` — show the colored output (✓ steps flying by)
3. New prompt appearing (Starship + Catppuccin colors)
4. Run `ls` → see eza icons + colors
5. Run `gs` → see git status in the styled prompt
6. Show `./setup.sh --doctor` → all green checks

**Specs:** Keep it under 15 seconds, looped. 1200×600px. Save as `docs/demo.gif`.

### 1.2 GitHub Repository Setup

Before the first post, configure the repo properly:

**Topics to add** (GitHub sidebar → gear icon):
```
terminal zsh dotfiles catppuccin starship oh-my-zsh developer-tools
macos linux shell-script automation homebrew nerd-fonts
```

**Social preview image** (Settings → Social preview):
- Create a 1280×640 image: dark background, Catppuccin Mocha colors
- Show the prompt with some example git output
- "devterm" text in MesloLGS NF font style
- Tool: Figma, Canva, or just a screenshot of the finished terminal

**Repository description:**
```
One command to a senior dev's terminal — Starship + Catppuccin + Oh My Zsh on macOS & Linux
```

**Website field:** Link to your GitHub Pages site (see 1.3).

### 1.3 GitHub Pages (5-minute setup)

Go to Settings → Pages → Source: main branch → `/docs` folder.

Create `docs/index.html` — a single page with:
- The one-liner install command (big, copy-button)
- The demo GIF
- What gets installed (the table)
- Link to GitHub

This becomes the shareable URL: `https://c0x12c.github.io/devterm-kit`

### 1.4 README Rewrite (already in progress)

The README is the product page. It needs:
- The demo GIF at the top (before anything else)
- Updated stack (Starship, not p10k — v1.0 references are still in the current README)
- Linux support documented
- `--doctor` flag in Options
- The one-liner install command must be the most prominent element

---

## Phase 2 — Launch Sequence

**Post in this order.** Each post builds social proof for the next.

### Day 0: Prepare

- [ ] Merge all v2.0 changes to `main`
- [ ] Create and test the demo GIF
- [ ] Update README (Starship stack, Linux support, demo GIF)
- [ ] Set GitHub topics and description
- [ ] Ask 5–10 friends/colleagues to star the repo (creates initial momentum)

### Day 1: r/unixporn

**Why first:** r/unixporn is the most important terminal aesthetics community. A post that lands here seeds everywhere else.

**URL:** https://www.reddit.com/r/unixporn/

**Title format:**
```
[macOS/Linux] One command to Starship + Catppuccin — devterm sets up your whole terminal in 30 seconds
```

**Post body:**
```markdown
I built devterm because I was tired of spending hours setting up a new machine's terminal.

**What it does:** One command installs and configures:
- Starship prompt (Rust-based, fast)
- Catppuccin color scheme (all 4 flavors — pick yours)
- Oh My Zsh with autosuggestions + syntax highlighting
- eza, bat, fzf, zoxide
- MesloLGS NF font
- Generated .zshrc with useful aliases

**Works on macOS and Linux.**

[demo GIF here]

```bash
curl -fsSL https://raw.githubusercontent.com/c0x12c/devterm-kit/master/install.sh | bash
```

GitHub: https://github.com/c0x12c/devterm-kit

Happy to answer questions or take PRs!
```

**Rules to follow:**
- You must share the GitHub link (they require dotfiles/configs to be shared)
- Post between 9–11 AM UTC on Tuesday or Wednesday (peak engagement)
- Stay in the comments for 2–3 hours after posting to reply

### Day 2: r/commandline and r/linux

Same content, slightly reworded. r/commandline is more technical — emphasize the BATS tests, idempotency, and `--doctor` command. r/linux emphasizes the cross-platform Linux support.

### Day 3: Hacker News — Show HN

**URL:** https://news.ycombinator.com/submit

**Title:**
```
Show HN: devterm – one command to Starship + Catppuccin terminal on macOS/Linux
```

**Best time:** Tuesday–Thursday, 9 AM ET (when it first hits the front page, US engineers are arriving at work)

**Comment to post immediately after submission (self-reply):**
```
I built this because setting up a new machine's terminal from scratch takes 2–3 hours of searching, installing, configuring, and debugging. devterm does it in one command.

Technical choices I'd love feedback on:
- Starship instead of Powerlevel10k (p10k is effectively unmaintained now)
- BATS tests on the bash scripts (unusual for shell scripts)
- A `--doctor` command to diagnose setup issues
- Idempotent design — safe to re-run

Source: https://github.com/c0x12c/devterm-kit
```

HN is skeptical of curl | bash. Be upfront about it in the comments and explain the alternative (git clone).

### Day 4–7: dev.to Article

**Title:** "How I set up a new Mac's terminal in 30 seconds (and why I built a tool for it)"

**Structure:**
1. The problem — 3 hours to configure a terminal the right way
2. The stack I landed on (Starship, Catppuccin, OMZ, eza, bat, fzf, zoxide) and why
3. What devterm does (one-liner, demo GIF)
4. The interesting engineering decisions (BATS tests on bash, `--doctor`, idempotency)
5. Linux support story
6. Call to action: try it, star it, open a PR

**Tags:** `#terminal #devtools #zsh #opensource`

Cross-post to Hashnode for double coverage.

### Week 2: Twitter/X Thread

```
I spent 3 hours setting up my terminal on my new MacBook.

Then I built devterm — so I never have to again.

One command. 30 seconds. Here's what you get: 🧵
```

Tweet 2: show the GIF
Tweet 3: list the stack (Starship, Catppuccin, OMZ)
Tweet 4: show `--doctor` output
Tweet 5: link + call to action

Tag: @catppuccin, @starship_rs, @ohmyzsh

---

## Phase 3 — Sustained Growth

### Catppuccin Community (Big leverage)

Catppuccin has become a full ecosystem. They list community ports at https://github.com/catppuccin/catppuccin.

**Action:** Open an issue/PR on catppuccin/catppuccin asking to be listed as a "devterm integration." Their community is 50K+ stars and very active. If you get listed there, devterm gets free discovery from all Catppuccin users.

### Starship Ecosystem

Star the Starship repo and open a Discussion or engage in their community. Starship's GitHub has ~45K stars. Being mentioned in their "Awesome Starship" or community discussions drives discovery.

**Reach out:** Post in Starship's GitHub Discussions showing your config files.

### "Awesome" Lists

Submit devterm to relevant curated lists:
- https://github.com/unixorn/awesome-zsh-plugins
- https://github.com/agarrharr/awesome-cli-apps
- https://github.com/alebcay/awesome-shell

These lists appear in Google searches. Low effort, long-tail traffic.

### YouTube Shorts / Reels

A 60-second screen recording of the install running — uploaded to YouTube Shorts and Instagram Reels — gets algorithmic distribution without needing followers. Title: "Set up your terminal in 30 seconds".

### Discord Servers

Post in relevant developer Discord servers:
- Catppuccin official Discord
- Developer communities (TheOdinProject, CS Discord, etc.)
- Any Zsh/shell Discord

### Hacktoberfest (October)

Tag issues with `hacktoberfest` in October. Developers looking for contributions will find devterm. Good issues to create:
- "Add Ghostty terminal support"
- "Add WezTerm config generation"
- "Add Fish shell support"
- "Create a devterm update command"

---

## Contribution Funnel

Getting stars is one thing. Getting contributors is another. Make it easy:

### Good First Issues to Pre-Create

Before launching, create these issues so contributors have somewhere to land:

```
[good first issue] Add support for Ghostty terminal (new Apple dev favorite)
[good first issue] Add WezTerm color theme support
[good first issue] Add --update flag to pull latest devterm changes
[enhancement] Fish shell support
[enhancement] Windows WSL2 support
[enhancement] devterm update command
[enhancement] VSCode integrated terminal theme sync
```

### CONTRIBUTING.md Polish

The current CONTRIBUTING.md should include:
- How to run the BATS tests locally (`brew install bats-core && bats tests/`)
- The lib module structure (one function = one file)
- How to add a new tool (copy existing pattern)
- Code style (shellcheck clean, `set -euo pipefail`, idempotent)

### Issue Templates

Already have bug_report.md and feature_request.md — good. Make sure they ask for:
- OS + version
- `./setup.sh --doctor` output
- Shell version

---

## Success Metrics (6-week targets)

| Metric | Target |
|---|---|
| GitHub stars | 200+ |
| Reddit upvotes (r/unixporn) | 500+ |
| HN points | 50+ |
| Forks | 15+ |
| Issues opened | 10+ |
| PRs from community | 3+ |
| dev.to article views | 2,000+ |

---

## The Single Most Important Thing

If you do nothing else from this plan: **make the demo GIF and put it at the top of the README**.

Every terminal tool that went viral had a compelling visual. Oh My Zsh has one. Starship has one. Catppuccin's whole brand is visual. devterm needs one.

The GIF is the product demo. Everything else is distribution.

---

## Quick Win Checklist (This Week)

- [x] Fix `yourusername` placeholder → c0x12c (done)
- [ ] Update README stack (Starship, not p10k — still showing old stack)
- [ ] Create demo GIF with VHS
- [ ] Add GitHub topics (12 topics above)
- [ ] Update repo description
- [ ] Pre-create 5 "good first issue" tickets
- [ ] Ask 5 colleagues to star the repo
- [ ] Post to r/unixporn on Tuesday 9 AM UTC
