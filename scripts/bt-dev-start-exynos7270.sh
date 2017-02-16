#!/bin/sh

#
# Script for registering Marvell 8977 and BCM43012 SDIO BT device
#

# COMMON NODE
# Currently we can't use rfkill list due to lack of marvel
SETBD=/usr/bin/setbd
RFKILL=/usr/sbin/rfkill
GREP=/usr/bin/pgrep
MATCH_BCM="bcm43012"
HCI_CONFIG=/usr/bin/hciconfig
CP="/bin/cp"
SYSLOG_PATH=/var/log/messages
BT_MAC_FILE=/csa/bluetooth/.bd_addr
MAC_PRE="00:05:b5:"
PARAM_BDADDR="management_socket"
WLAN=/usr/bin/wlan.sh

# BCM43012 dependent bt start code
echo "BCM43012 SOLIS BT START"
echo "create bd address and write bd address via management socket"
#${SETBD} ${MAC_PRE} ${BT_MAC_FILE} ${PARAM_BDADDR}
${SETBD} ${MAC_PRE} ${BT_MAC_FILE}
if [ $? -ne 0 ]
then
	exit 1
fi

${WLAN} start
${RFKILL} unblock bluetooth

TIMEOUT=20
BT_FW_NAME=`basename $(readlink /lib/firmware/43012B0.hex)`
for (( i=1; i<=$TIMEOUT; i++))
do
	/bin/sleep 0.1

        if [ $i -eq $TIMEOUT ]
        then
                echo "time expired happen $i"
                ${RFKILL} block bluetooth
                ${CP} $SYSLOG_PATH /var/lib/bluetooth/
                exit 1
        fi

	if (${HCI_CONFIG} | ${GREP} hci); then
		echo "Bluetooth device is made with "${BT_FW_NAME}
		break
	fi
	echo "Continue...$i"
done
exit 0




