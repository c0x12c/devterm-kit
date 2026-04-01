# devterm demo — generate with: brew install vhs && vhs docs/demo.tape
# Output: docs/demo.gif  (commit this file to the repo)

Output docs/demo.gif

Set Shell "bash"
Set FontSize 14
Set Width 1200
Set Height 600
Set Theme "Catppuccin Mocha"
Set Padding 20
Set TypingSpeed 40ms

# Clear screen
Type "clear"
Enter
Sleep 300ms

# Show the one-liner
Type "# One command to a senior dev's terminal"
Sleep 1s
Enter
Sleep 300ms

Type "./setup.sh --theme mocha"
Sleep 500ms
Enter
Sleep 10s

# Show the result — new prompt is live
Sleep 1s

# Show eza alias
Type "ls"
Enter
Sleep 1s

# Show git status in prompt
Type "gs"
Enter
Sleep 800ms

# Show doctor
Type "./setup.sh --doctor"
Enter
Sleep 3s
