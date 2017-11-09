#!/bin/sh

# Set bottom Dock position for "student" user and prevent future changes with position-immutable.

if [[ $USER == "student" ]]; then

dockorientation=`/usr/bin/defaults read com.apple.dock orientation`

if [[ $dockorientation != "bottom" ]]; then
	/usr/bin/defaults write com.apple.dock position-immutable -bool yes
	/usr/bin/defaults write com.apple.dock orientation -string bottom
	/usr/bin/killall Dock
fi

fi