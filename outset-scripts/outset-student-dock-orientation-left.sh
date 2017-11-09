#!/bin/sh

# Set left Dock position for "student" user and prevent future changes with position-immutable.

if [[ $USER == "student" ]]; then

dockorientation=`/usr/bin/defaults read com.apple.dock orientation`

if [[ $dockorientation != "left" ]]; then
	/usr/bin/defaults write com.apple.dock position-immutable -bool yes
	/usr/bin/defaults write com.apple.dock orientation -string left
	/usr/bin/killall Dock
fi

fi
