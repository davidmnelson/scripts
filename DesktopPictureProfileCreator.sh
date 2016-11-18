#!/bin/bash
# Script by David Nelson. Other credits via inline comments as needed.
# Pass the path of an image when running. For example 'sh DesktopPictureProfileCreator.sh /Library/Desktop\ Pictures/Aqua\ Blue.jpg'
# More info and latest version at https://github.com/davidmnelson/mobileconfigscripts


# Did an argument sent?
if [[ $1 == "" && $1 != NULL ]] ; then
echo "Please provide the path to a desktop picture."
exit 0;


elif [[ ! -f $1 ]]; then
echo "The file \"$1\" was not found. Please try again."
exit 0;


elif [[ -f $1 ]]; then

# basename with a little cleanup (used as profile display name)
cleanshortname=`basename "$1" | sed 's/[^A-Za-z0-9 .-]/-/g'`

# basename without spaces or dots (used in filename and payload identifier)
cleanershortname=`echo $cleanshortname | sed 's/[^A-Za-z0-9]/-/g'`

echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>PayloadContent</key>
    <array>
        <dict>
            <key>PayloadDisplayName</key>
            <string>Desktop</string>
            <key>PayloadEnabled</key>
            <true/>
            <key>PayloadIdentifier</key>
            <string>my.desktoppicture.'$cleanershortname'.payload</string>
            <key>PayloadType</key>
            <string>com.apple.desktop</string>
            <key>PayloadUUID</key>
            <string>'`uuidgen`'</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
            <key>locked</key>
            <true/>
            <key>override-picture-path</key>
            <string>'$1'</string>
        </dict>
    </array>
    <key>PayloadDisplayName</key>
    <string>Desktop: '$cleanshortname'</string>
    <key>PayloadIdentifier</key>
    <string>my.desktoppicture.'$cleanershortname'.payload</string>
    <key>PayloadOrganization</key>
    <string></string>
    <key>PayloadRemovalDisallowed</key>
    <false/>
    <key>PayloadScope</key>
    <string>System</string>
    <key>PayloadType</key>
    <string>Configuration</string>
    <key>PayloadUUID</key>
    <string>'`uuidgen`'</string>
    <key>PayloadVersion</key>
    <integer>1</integer>
</dict>
</plist>' > ~/Desktop/Desktop-$cleanershortname.mobileconfig
echo "The profile \"$cleanershortname.mobileconfig\" has been created on your Desktop."

exit 0

else
echo "Something went wrong. Sorry!"
exit 1
fi
