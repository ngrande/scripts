#!/bin/bash
USER=$(cat ~/.openvpn_script | grep username | awk -F "=" '{print $2}')
SECRET=$(cat ~/.openvpn_script | grep secret | awk -F "=" '{print $2}')
FIX_PW=$(cat ~/.openvpn_script | grep password | awk -F "=" '{print $2}')
VPN_CON_NAME=$(cat ~/.openvpn_script | grep connection | awk -F "=" '{print $2}')
CONN_ARG=$1

if [ "$BLOCK_BUTTON" == "1" ];
then
	CONN_ARG="connect"
elif [ "$BLOCK_BUTTON" == "3" ];
then
	CONN_ARG="disconnect"
fi

openvpn() {
	if [ "$CONN_ARG" == "connect" ]; then
		AUTH_CODE=`oathtool --totp=sha1 -b $SECRET`
		PW=$FIX_PW$AUTH_CODE
#		echo "connecting..."
		/usr/bin/nmcli c modify id $VPN_CON_NAME vpn.user-name $USER
		echo $PW | /usr/bin/nmcli c up $VPN_CON_NAME --ask > /dev/zero
		# this route breaks my internet connection but is added with the .ovpn
		sudo ip route del default via 172.25.29.129 dev tun0 proto static metric 50 > /dev/zero
	elif [ "$CONN_ARG" == "disconnect" ]; then
#		echo "disconnecting..."
		/usr/bin/nmcli c down $VPN_CON_NAME > /dev/zero
	fi
}

openvpn

if [ "$(/usr/bin/nmcli c show --active | grep $VPN_CON_NAME)" ]; then
	echo "active"
	sudo ln -sf /etc/resolv.conf.vwd /etc/resolv.conf
else
	echo "inactive"
	sudo ln -sf /etc/resolv.conf.private /etc/resolv.conf
fi
