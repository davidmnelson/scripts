#!/bin/bash
# Script by David Nelson. Other credits via inline comments as needed.
# More info and latest version at https://github.com/davidmnelson/airprintprofilecreator

if [[ $EUID -ne 0 ]]; then
   echo "Please run as root or sudo." 1>&2
   exit 1
fi

# Get primary IP address
autoip=`ifconfig | grep -v "ppp0" | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`

ipcorrect="Y"
read -p "Is this CUPS server's IP address \"$autoip\"? [Y/n] " REPLY
ipcorrect=${REPLY:-$ipcorrect}

if [ $ipcorrect == "Y" ] || [ $ipcorrect == "y" ] ; then
	ip=$autoip
fi

if [ $ipcorrect == "N" ] || [ $ipcorrect == "n" ] ; then

ip=""

validateip() {
	# Based on validation example found at 
	# http://stackoverflow.com/questions/20791832/while-loop-if-else-loop-to-read-and-validate-ip-address
    iptovalidate="$1"
    # Check if the format looks right_
    echo "$iptovalidate" | egrep -qE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' || return 1
    #check that each octect is less than or equal to 255:
    echo $iptovalidate | awk -F'.' '$1 <=255 && $2 <= 255 && $3 <=255 && $4 <= 255 {print "Y" } ' | grep -q Y || return 1
    return 0
}

read -p "Please enter the correct IP address of this server: " REPLY

while ! validateip "$REPLY"
do
    read -p "Not a valid IP address. Please try again: " REPLY
done
ip=$REPLY

fi

includealldecision="Y";
read -p "Include *all* printers currently available on this CUPS server? [Y/n] " REPLY
includedecision=${REPLY:-$includealldecision}

profiletitle="Printers on "$ip
mobileconfigfilename=`pwd`"/"$profiletitle".mobileconfig"

commonid=$ip'.'`uuidgen`

fullprinterlist=( $(cat /etc/cups/printers.conf | grep "<Printer " | sed "s/<Printer //;s/>//" ) )

numprinters=${#fullprinterlist[@]}

numberofprinterstoadd="0"

mobileconfig='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>PayloadContent</key>
	<array>
		<dict>
			<key>AirPrint</key>
			<array>'

for (( i=0; i<${numprinters} ; i++ ))
	{

	prettyprintername=`lpstat -l -p ${fullprinterlist[$i]} | grep Description | sed s/"Description:"\ //g | tr -d "\t"`

	if [ $includedecision == "Y" ] || [ $includedecision == "y" ] ; then
		includethisone="Y"
	fi

	if [ $includedecision == "N" ] || [ $includedecision == "n" ] ; then

		includethisone="Y"
		read -p "Include \"$prettyprintername\"? [Y/n] " REPLY
		includethisone=${REPLY:-$includethisone}

		if [ $includethisone == "N" ] || [ $includethisone == "n" ] ; then
		includethisone="N"
		echo "Skipping \"$prettyprintername\"..."
		fi

		if [ $includethisone == "Y" ] || [ $includethisone == "y" ] ; then
		includethisone="Y"
		fi

	fi

	if [ $includethisone == "Y" ] ; then
		mobileconfig+='
					<dict>
						<key>IPAddress</key>
						<string>'$ip'</string>
						<key>ResourcePath</key>
						<string>/printers/'${fullprinterlist[$i]}'</string>
					</dict>'
		lpadmin -p ${fullprinterlist[$i]} -o printer-is-shared=true
		echo "Enabling sharing for \"$prettyprintername\"..."
		echo "Adding \"$prettyprintername\" to profile..."
		numberofprinterstoadd="$(($numberofprinterstoadd+1))"
	fi


	}

mobileconfig+='
			</array>
			<key>PayloadDescription</key>
			<string>Configures settings for AirPrint</string>
			<key>PayloadDisplayName</key>
			<string>AirPrint</string>
			<key>PayloadIdentifier</key>
			<string>'$commonid'.com.apple.airprint.'`uuidgen`'</string>
			<key>PayloadType</key>
			<string>com.apple.airprint</string>
			<key>PayloadUUID</key>
			<string>'`uuidgen`'</string>
			<key>PayloadVersion</key>
			<real>1</real>
		</dict>
	</array>
	<key>PayloadDisplayName</key>
	<string>'$profiletitle'</string>
	<key>PayloadIdentifier</key>
	<string>'$commonid'</string>
	<key>PayloadRemovalDisallowed</key>
	<false/>
	<key>PayloadType</key>
	<string>Configuration</string>
	<key>PayloadUUID</key>
	<string>'`uuidgen`'</string>
	<key>PayloadVersion</key>
	<integer>1</integer>
</dict>
</plist>'

if [ $numberofprinterstoadd == "0" ] ; then
echo "Oops, you didn't choose to enable any printers for sharing. If this was a mistake please try again."
exit 1
fi

cupsstatus=`cupsctl | grep _share_printers | sed s/_share_printers=//`
if [ $cupsstatus == "0" ] ; then
	echo "Enabling CUPS printer sharing service..."
	cupsctl --share-printers
fi
if [ $cupsstatus == "1" ] ; then
	echo "Verifying that CUPS printer sharing is enabled..."
fi

echo "$mobileconfig" > "$mobileconfigfilename"

echo "Your profile has been created here:"
echo "\"$mobileconfigfilename\""

exit
