#!/bin/sh

BT_UART_DEVICE=/dev/ttymxc6
BT_CHIP_TYPE=bcm43xx
BT_DEFAULT_HCI_NAME="TIZEN-SDTA7D"
HCI_CONFIG=/usr/bin/hciconfig
HCI_ATTACH=/usr/bin/hciattach
HCI_DEV=hci0

$HCI_CONFIG | /usr/bin/grep $HCI_DEV &> /dev/null
if [ $? -eq 0 ]; then
	$HCI_CONFIG $HCI_DEV up;
else
	/usr/bin/lsmod | /usr/bin/grep "hci_uart" &> /dev/null
	if [ $? -ne 0 ]; then
		/usr/sbin/modprobe hci_uart
	fi	

	if ($HCI_ATTACH $BT_UART_DEVICE $BT_CHIP_TYPE); then
		$HCI_CONFIG $HCI_DEV up
		$HCI_CONFIG $HCI_DEV name $BT_DEFAULT_HCI_NAME
		$HCI_CONFIG $HCI_DEV sspmode 1

		echo "HCIATTACH success"
	else
		echo "HCIATTACH failed"
	fi
fi
