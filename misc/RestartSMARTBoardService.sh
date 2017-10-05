#!/bin/bash
# Kills and restarts a dead SMARTBoardService to fix solid red or flashing green light.

for pid in `/usr/bin/pgrep SMARTBoardService`; do 
	/bin/kill $pid ; 
echo "
Quitting process "$pid".
"
done; 

/usr/bin/open /Applications/SMART\ Technologies/SMART\ Settings.app/Contents/bin/SMARTBoardService.app ;

/bin/echo "New SMARTBoardService is running with PID "`pgrep SMARTBoardService`".
"
