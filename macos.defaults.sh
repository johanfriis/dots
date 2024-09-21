# fast key repeat
# Test here: https://mac-os-key-repeat.vercel.app
# Once set, enable by calling `killall Finder`
defaults write -g InitialKeyRepeat -int 13
  defaults write -g KeyRepeat -int 2

# disable press-and-hold
defaults write -g ApplePressAndHoldEnabled -bool false
