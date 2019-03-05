#!/bin/sh

HCI_CONFIG=/usr/bin/hciconfig
HCI_DEV=hci0

$HCI_CONFIG | /usr/bin/grep $HCI_DEV &> /dev/null
if [ $? -eq 0 ]; then
	$HCI_CONFIG $HCI_DEV down
fi
