#!/usr/bin/env bash
# lib/tips.sh — Post-install cheat sheet: what changed and how to use it

show_tips() {
  local BOLD='\033[1m'
  local DIM='\033[2m'
  local NC='\033[0m'
  local MAUVE='\033[38;2;203;166;247m'
  local BLUE='\033[38;2;137;180;250m'
  local GREEN='\033[38;2;166;227;161m'
  local YELLOW='\033[38;2;249;226;175m'
  local RED='\033[38;2;243;139;168m'
  local TEXT='\033[38;2;205;214;244m'

  echo ""
  echo -e "${MAUVE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${MAUVE}${BOLD}  devterm cheat sheet — what changed and how to use it${NC}"
  echo -e "${MAUVE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

  # ── fzf ──────────────────────────────────────────────────────────────────
  echo ""
  echo -e "  ${YELLOW}${BOLD}fzf${NC} — Fuzzy finder (replaces boring Ctrl+R)"
  echo -e "  ${DIM}─────────────────────────────────────────────${NC}"
  echo -e "  ${RED}Before:${NC}  Ctrl+R searches history one-by-one, easy to miss"
  echo -e "  ${GREEN}After:${NC}   Ctrl+R opens interactive fuzzy search — type any word"
  echo ""
  echo -e "  ${BOLD}Try now:${NC}"
  echo -e "    ${BLUE}Ctrl+R${NC}     Search command history (type any keyword)"
  echo -e "    ${BLUE}Ctrl+T${NC}     Find files in current directory"
  echo -e "    ${BLUE}Alt+C${NC}      Jump to any subdirectory"
  echo -e "    ${BLUE}ssh **⇥${NC}    Tab-complete SSH hosts from ~/.ssh/config"
  echo -e "    ${BLUE}kill ⇥${NC}     Tab-complete running process names"

  # ── eza ──────────────────────────────────────────────────────────────────
  echo ""
  echo -e "  ${YELLOW}${BOLD}eza${NC} — Modern ls (replaces plain ls)"
  echo -e "  ${DIM}─────────────────────────────────────────────${NC}"
  echo -e "  ${RED}Before:${NC}  ${DIM}ls${NC} shows plain filenames, no context"
  echo -e "  ${GREEN}After:${NC}   ${DIM}ls${NC} shows icons, colors, directories first"
  echo ""
  echo -e "  ${BOLD}Try now:${NC}"
  echo -e "    ${BLUE}ls${NC}         List with icons (aliased to eza)"
  echo -e "    ${BLUE}ll${NC}         Long list with git status + permissions"
  echo -e "    ${BLUE}la${NC}         List all including hidden files"
  echo -e "    ${BLUE}lt${NC}         Tree view (2 levels deep)"
  echo -e "    ${BLUE}ltt${NC}        Tree view (3 levels deep)"

  # ── bat ──────────────────────────────────────────────────────────────────
  echo ""
  echo -e "  ${YELLOW}${BOLD}bat${NC} — cat with superpowers"
  echo -e "  ${DIM}─────────────────────────────────────────────${NC}"
  echo -e "  ${RED}Before:${NC}  ${DIM}cat file.py${NC} dumps raw text, no highlighting"
  echo -e "  ${GREEN}After:${NC}   ${DIM}cat file.py${NC} shows syntax highlighting + line numbers"
  echo ""
  echo -e "  ${BOLD}Try now:${NC}"
  echo -e "    ${BLUE}cat README.md${NC}          Highlighted Markdown"
  echo -e "    ${BLUE}cat src/main.kt${NC}        Highlighted Kotlin"
  echo -e "    ${BLUE}bat -A .env${NC}            Show hidden characters (debug)"
  echo -e "    ${BLUE}man git${NC}                Man pages now use bat too"

  # ── zoxide ───────────────────────────────────────────────────────────────
  echo ""
  echo -e "  ${YELLOW}${BOLD}zoxide${NC} — Smart cd that learns your habits"
  echo -e "  ${DIM}─────────────────────────────────────────────${NC}"
  echo -e "  ${RED}Before:${NC}  ${DIM}cd ~/Work/projects/my-app/src${NC} — type full path every time"
  echo -e "  ${GREEN}After:${NC}   ${DIM}z my-app${NC} — jumps there instantly (learns from your cd history)"
  echo ""
  echo -e "  ${BOLD}Try now:${NC}"
  echo -e "    ${BLUE}z <keyword>${NC}     Jump to best-matching directory"
  echo -e "    ${BLUE}z src${NC}           Jump to most-visited 'src' directory"
  echo -e "    ${BLUE}zi${NC}             Interactive directory picker (with fzf)"
  echo -e "    ${BLUE}j <keyword>${NC}     Same as z (alias: j = jump)"
  echo -e "  ${DIM}  Tip: use cd normally for a few days — zoxide learns your patterns${NC}"

  # ── Starship ─────────────────────────────────────────────────────────────
  echo ""
  echo -e "  ${YELLOW}${BOLD}Starship${NC} — Your prompt now shows context"
  echo -e "  ${DIM}─────────────────────────────────────────────${NC}"
  echo -e "  ${RED}Before:${NC}  ${DIM}user@host ~ \$${NC} — no context about your project"
  echo -e "  ${GREEN}After:${NC}   Prompt shows git branch, language version, status"
  echo ""
  echo -e "  ${BOLD}What you see:${NC}"
  echo -e "    ${BLUE}branch ${NC}      Current git branch + dirty/clean status"
  echo -e "    ${BLUE}node v20${NC}      Auto-detected from package.json"
  echo -e "    ${BLUE}kotlin 2.0${NC}    Auto-detected from build.gradle"
  echo -e "    ${BLUE}docker 🐳${NC}     Shows when Dockerfile present"
  echo -e "    ${BLUE}2s${NC}            Command execution time (if > 2s)"

  # ── Zsh plugins ──────────────────────────────────────────────────────────
  echo ""
  echo -e "  ${YELLOW}${BOLD}Zsh plugins${NC} — Autosuggestions + syntax highlighting"
  echo -e "  ${DIM}─────────────────────────────────────────────${NC}"
  echo -e "  ${RED}Before:${NC}  Type everything from memory, errors only after Enter"
  echo -e "  ${GREEN}After:${NC}   Ghost suggestions appear as you type, wrong commands turn red"
  echo ""
  echo -e "  ${BOLD}Try now:${NC}"
  echo -e "    ${BLUE}→ (right arrow)${NC}    Accept entire autosuggestion"
  echo -e "    ${BLUE}Ctrl+→${NC}             Accept one word of suggestion"
  echo -e "    ${DIM}Type 'gti' and notice it turns red (not a real command)${NC}"
  echo -e "    ${DIM}Type 'git' and notice it turns green (valid command)${NC}"

  # ── Git aliases ──────────────────────────────────────────────────────────
  echo ""
  echo -e "  ${YELLOW}${BOLD}Git aliases${NC} — Less typing"
  echo -e "  ${DIM}─────────────────────────────────────────────${NC}"
  echo -e "    ${BLUE}gs${NC}   git status          ${BLUE}gd${NC}    git diff"
  echo -e "    ${BLUE}ga${NC}   git add              ${BLUE}gds${NC}   git diff --staged"
  echo -e "    ${BLUE}gcm${NC}  git commit -m        ${BLUE}gl${NC}    git log --oneline --graph"
  echo -e "    ${BLUE}gp${NC}   git push             ${BLUE}gpl${NC}   git pull"
  echo -e "    ${BLUE}gcb${NC}  git checkout -b       ${BLUE}gst${NC}   git stash"

  # ── Quick reference ──────────────────────────────────────────────────────
  echo ""
  echo -e "${MAUVE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  ${TEXT}${BOLD}Top 5 things to try right now:${NC}"
  echo -e "${MAUVE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
  echo -e "    ${BOLD}1.${NC}  ${BLUE}ll${NC}                    See the new ls with icons + git"
  echo -e "    ${BOLD}2.${NC}  ${BLUE}Ctrl+R${NC}  then type      Fuzzy search your command history"
  echo -e "    ${BOLD}3.${NC}  ${BLUE}cat ~/.zshrc${NC}           See syntax highlighting in action"
  echo -e "    ${BOLD}4.${NC}  ${BLUE}cd ~/some/project${NC}      Then later: ${BLUE}z project${NC} to jump back"
  echo -e "    ${BOLD}5.${NC}  ${DIM}Type a previous command slowly — watch the ghost suggestion${NC}"
  echo ""
  echo -e "  ${DIM}Run anytime:  ${BOLD}devterm tips${NC}"
  echo ""
}
