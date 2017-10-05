#!/bin/sh

# Enables text-to-speech and sets Control-R hotkey.

/usr/bin/defaults write com.apple.speech.synthesis.general.prefs SpokenUIUseSpeakingHotKeyCombo -int 4111

/usr/bin/defaults write com.apple.speech.synthesis.general.prefs SpokenUIUseSpeakingHotKeyFlag -bool true

exit 0