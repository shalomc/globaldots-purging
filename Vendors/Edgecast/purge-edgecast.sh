#!/bin/bash

# Sample usage: 
# purge-edgecast.sh http://wpc.121E0.edgecastcdn.net/00121E0/winafar/testapi.txt
# This file is set up for a specific platform, the Platform variable can also be set to be passed as an input
# Set MyToken and HEX variables from config file

ConfigFile=Edgecast-config.txt

if [ -f "$ConfigFile" ]
then
	source $ConfigFile
else
	echo Configuration file: $ConfigFile does not exist. Aborting purge!
	exit 2
fi


APIendpoint=https://api.edgecast.com
FlashMediaStreaming=2
HTTPLarge=3
HTTPSmall=8
ADN=14

URL=$1
Platform=$HTTPLarge

curl -v  -H "Authorization: tok:$MyToken" -H 'Accept: application/json' -H 'Content-Type: application/json' -X PUT -d "{ \"MediaPath\":\"$URL\", \"MediaType\":$Platform }"  $APIendpoint/v2/mcc/customers/$HEX/edge/purge

# finish
