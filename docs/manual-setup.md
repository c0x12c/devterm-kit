# Manual Setup Guide

If the automated script fails or you prefer to install components individually, follow this guide.

## Step 1: MesloLGS NF Fonts

Download all 4 variants from Powerlevel10k's CDN:

```bash
FONT_DIR="$HOME/Library/Fonts"
BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"

curl -fsSL "$BASE/MesloLGS%20NF%20Regular.ttf"     -o "$FONT_DIR/MesloLGS NF Regular.ttf"
curl -fsSL "$BASE/MesloLGS%20NF%20Bold.ttf"         -o "$FONT_DIR/MesloLGS NF Bold.ttf"
curl -fsSL "$BASE/MesloLGS%20NF%20Italic.ttf"       -o "$FONT_DIR/MesloLGS NF Italic.ttf"
curl -fsSL "$BASE/MesloLGS%20NF%20Bold%20Italic.ttf" -o "$FONT_DIR/MesloLGS NF Bold Italic.ttf"
```

## Step 2: Oh My Zsh

```bash
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Step 3: Powerlevel10k

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

## Step 4: Plugins

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## Step 5: CLI Tools

```bash
brew install fzf eza bat zoxide
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
```

## Step 6: Catppuccin for iTerm2

1. Open the `.itermcolors` file from the `themes/` directory:
   ```bash
   open themes/catppuccin-mocha.itermcolors
   ```
2. Click OK in the iTerm2 import dialog
3. Go to Preferences → Profiles → Colors → Color Presets → `catppuccin-mocha`

## Step 7: Configure .zshrc

Add to `~/.zshrc`:

```zsh
# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)
source $ZSH/oh-my-zsh.sh

# eza
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"

# bat
alias cat="bat --theme=Catppuccin-Mocha"

# zoxide
eval "$(zoxide init zsh)"

# p10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
```

## Step 8: Configure Prompt

```bash
# Restart iTerm2 first, then:
p10k configure
```

## Troubleshooting

**Icons show as □ boxes:**
- Font not set correctly in iTerm2
- Go to: Preferences → Profiles → Text → Font → select "MesloLGS NF"

**`p10k configure` command not found:**
```bash
source ~/.zshrc
p10k configure
```

**Oh My Zsh not loading:**
```bash
source ~/.oh-my-zsh/oh-my-zsh.sh
```

**Slow shell startup:**
- Check if `nvm` is loading (slow): use `--no-use` mode
- Use Powerlevel10k's instant prompt (enabled by default in devterm's .zshrc)
