#!/bin/bash

echo "made by vp@23.01.07"
source /home/vp/WoL/Credential.sh
BootPhrasePath="/home/vp/WoL/BootPhrase.txt"
echo -e "[Info] BootPhrasePath: $BootPhrasePath"

Bootupmsg="Booting your machine for you~"
Bootedmsg="Already booted, do nothing..."
WoLmsg="WoL request received!"
StartupStateFileExistmsg="StartupState file Detected!"
StartupStateFileNotExistmsg="StartupState file Created!"

if [ -f "laststartuptime" ]
then
    echo -e "[Info] $StartupStateFileExistmsg\n"
else
    echo "0" > laststartuptime
    echo -e "[Act] $StartupStateFileNotExistmsg\n"
fi

response=$(curl -s -X GET https://api.telegram.org/bot${botid}:${TOKEN}/getUpdates)
echo "[Info] <<< Start of RAW MSGs >>>"
echo $response
echo -e "[Info] <<< End of RAW MSGs >>>\n"

msgcount=$(echo $response | jq -c ".result | length")
echo -e "[Info] msgcount: $msgcount\n"

for ((i=0;i<$msgcount;i++))
do
    msgtxt=$(echo $response | jq -c .result[$i].message.text | sed 's/\"//g')
    msgdate=$(echo $response | jq -c .result[$i].message.date)
    echo "[Info] msgtxt: \"$msgtxt\""
    echo -e "[Info] msgdate: \"$msgdate\"\n"
    if grep -q "$msgtxt" "$BootPhrasePath"
    then
        echo "[Info] $WoLmsg"
        laststartuptime=$(<laststartuptime)
        diff=$(($laststartuptime - $msgdate))
        if [ "$diff" -ge "0" ]
        then
            echo -e "[Info] $Bootedmsg\n"
        else
            etherwake -i eth0 "$MacAddress"
            echo -e "[Act] $Bootupmsg\n"
            echo "$msgdate" > laststartuptime
        fi
    fi
done
