#!/bin/bash
# Script by David Nelson. Other credits via inline comments as needed.
# More info and latest version at https://github.com/davidmnelson/safarihomepageprofilecreator


# Did an argument sent?
if [[ $1 == "" && $1 != NULL ]] ; then
echo "Please supply the URL of a web page when running this script."
exit 0;


else

cleanname=`echo $1 | sed 's/[^A-Za-z0-9]/-/g'`

echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PayloadContent</key>
	<array>
		<dict>
			<key>PayloadContent</key>
			<dict>
				<key>com.apple.Safari</key>
				<dict>
					<key>Forced</key>
					<array>
						<dict>
							<key>mcx_preference_settings</key>
							<dict>
								<key>HomePage</key>
								<string>'$1'</string>
								<key>NewWindowBehavior</key>
								<string>0</string>
							</dict>
						</dict>
					</array>
				</dict>
			</dict>
			<key>PayloadEnabled</key>
			<true/>
			<key>PayloadIdentifier</key>
			<string>'`uuidgen`'</string>
			<key>PayloadType</key>
			<string>com.apple.ManagedClient.preferences</string>
			<key>PayloadUUID</key>
			<string>'`uuidgen`'</string>
			<key>PayloadVersion</key>
			<integer>1</integer>
		</dict>
	</array>
	<key>PayloadDescription</key>
	<string>Sets Safari homepage to '$1'</string>
	<key>PayloadDisplayName</key>
	<string>Safari Home: '$1'</string>
	<key>PayloadIdentifier</key>
	<string>my.homepage.'$1'</string>
	<key>PayloadRemovalDisallowed</key>
	<true/>
	<key>PayloadScope</key>
	<string>User</string>
	<key>PayloadType</key>
	<string>Configuration</string>
	<key>PayloadUUID</key>
	<string>'`uuidgen`'</string>
	<key>PayloadVersion</key>
	<integer>1</integer>
</dict>
</plist>' > ~/Desktop/Safari-Home-$cleanname.mobileconfig
echo "The profile \"Safari-Home-$cleanname.mobileconfig\" has been created on your Desktop."

exit 0

fi
