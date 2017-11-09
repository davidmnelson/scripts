#!/bin/sh

# Set right Dock position for "student" user and prevent future changes with position-immutable.

if [[ $USER == "student" ]]; then

dockorientation=`/usr/bin/defaults read com.apple.dock orientation`

if [[ $dockorientation != "right" ]]; then
	/usr/bin/defaults write com.apple.dock position-immutable -bool yes
	/usr/bin/defaults write com.apple.dock orientation -string right
	/usr/bin/killall Dock
fi

fi