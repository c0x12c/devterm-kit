# devterm demo — generate with: brew install vhs && vhs docs/demo.tape
# Output: docs/demo.gif  (commit this file to the repo)
#
# Prerequisites:
#   - devterm already installed (setup.sh will skip/show idempotent output)
#   - MesloLGS NF font installed (devterm installs this)

Output docs/demo.gif

Set Shell "zsh"
Set FontSize 14
Set FontFamily "MesloLGS NF"
Set Width 1200
Set Height 700
Set Theme "Catppuccin Mocha"
Set Padding 20
Set TypingSpeed 40ms

# Bootstrap: source zshrc + ensure PATH has homebrew (hidden from recording)
Hide
Type "export PATH=/opt/homebrew/bin:/usr/local/bin:$PATH; source ~/.zshrc 2>/dev/null"
Enter
Sleep 2s
Type "clear"
Enter
Sleep 500ms
Show

# Show the one-liner
Type "# One command to a senior dev's terminal"
Sleep 1s
Enter
Sleep 300ms

Type "./setup.sh --theme mocha"
Sleep 500ms
Enter
Sleep 12s

# Show the result — modern prompt + aliases
Sleep 500ms

# Show eza alias (ls → eza with icons)
Type "ls"
Enter
Sleep 1s

# Show git status in prompt
Type "git status --short"
Enter
Sleep 800ms

# Show doctor
Type "./setup.sh --doctor"
Enter
Sleep 3s

# Show tips cheat sheet
Type "./setup.sh --tips"
Enter
Sleep 3s
