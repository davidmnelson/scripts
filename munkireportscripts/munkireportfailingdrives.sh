#!/bin/bash

# The user who runs this should have a .my.cnf file that lets 
# them select from the database without supplying a password.

# Where will we send the report? 
reportaddress="your@address.here"

# What's the database called? 
dbname="munkireport"

# Show reports received in the last X number of days. 
numberofdays="3"

# Specify the paths of some programs we need. Defaults are for CentOS 7.
# You may have to change some of them to use on other distros or macOS.
mysql="/bin/mysql"
echo="/bin/echo"
sendmail="/usr/sbin/sendmail"

# Grab a list of machines that have reported a failing hard drive in the last three days.
theresult=$($mysql --html $dbname -e "select machine.computer_name as \"Computer Name\",reportdata.serial_number as \"Serial Number\",FROM_UNIXTIME(reportdata.timestamp) as \"Date and Time Seen\", diskreport.SMARTStatus as \"SMART Status\" from machine,reportdata,diskreport where diskreport.SMARTStatus LIKE \"Failing\" AND machine.serial_number=diskreport.serial_number AND reportdata.serial_number=diskreport.serial_number AND FROM_UNIXTIME(reportdata.timestamp) >= curdate() - INTERVAL $numberofdays DAY ;");

# Proceed only if the query actually returned something.
if [[ $theresult != "" ]]; then

# Build the email.
emailmessage="Subject: Failing drive(s) found in MunkiReport
To: $reportaddress
Content-Type: text/html
MIME-Version: 1.0
<p>The following Macs recently reported a failing SMART Status. If the drive has already been replaced, please ensure Munki is installed and working on the new drive to make these alerts stop.</p>
$theresult
"

# Send it
$echo "$emailmessage" | $sendmail -oi -t

fi
