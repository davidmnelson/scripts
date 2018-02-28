#!/bin/sh

# Set bottom Dock position for "student" user and prevent future changes with position-immutable.

if [[ $USER == "student" ]]; then

contentsimmutable=`/usr/bin/defaults read com.apple.dock contents-immutable`

if [[ $contentsimmutable != "1" ]]; then
	/usr/bin/defaults write com.apple.dock contents-immutable -bool yes
	/usr/bin/killall Dock
fi

fi