#!/bin/sh
# Enable text-to-speech and set Control-R shortcut. 
# Intended to run as a login-every script via Outset.
/usr/bin/defaults write com.apple.speech.synthesis.general.prefs SpokenUIUseSpeakingHotKeyCombo -int 4111
/usr/bin/defaults write com.apple.speech.synthesis.general.prefs SpokenUIUseSpeakingHotKeyFlag -bool true
