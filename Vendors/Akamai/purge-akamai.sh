#!/bin/bash

# Sample usage: 
# Purge single URL
# purge-akamai.sh http://<your-url-here>/

# Written by Shalom Carmel

ConfigFile=Akamai-config.txt

if [ -f "$ConfigFile" ]
then
	source $ConfigFile
else
	echo Configuration file: $ConfigFile does not exist. Aborting purge!
	exit 2
fi


URL=$1

QUEUE=default
APIpoint=api.ccu.akamai.com
curl -v -X POST https://$APIpoint/ccu/v2/queues/$QUEUE -H "Content-Type:application/json" -d "{ \"objects\":[\"$URL\"]}" -u "$User:$Password"

# finish
