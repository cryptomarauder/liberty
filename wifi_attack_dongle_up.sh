#!/bin/sh

# wifi device. you'll need to decide on that out before running this.
userdev="wlp8888881u1"

# router
usergateway="192.168.1.1"

# your wifi networks name
userssid=""

# binaries we don't need to expand constantly
ipbin="$(which ip )"
iwbin="$(which iw )"

#userdriver="wext" 
#userdriver="atkl1"

printf "\n\nThese are the available interfaces. \n"
printf     "You have 3 seconds to Ctl-c if you want to exit.\n\n"
$iwbin dev |grep -i interface
sleep 3

ifconfig $userdev down
macchanger -a $userdev # optional
iw reg set BO
iwconfig $userdev txpower 30
ifconfig $userdev up

printf "NOTICE: Bringing up ${ipbin}\n\n"
$ipbin link set $userdev up
sleep 1

printf "\n\nHow's the results look? \n\n"
$ipbin ip a s |grep -i -A 10 $userdev 
sleep 1

printf "\n\n$ipbin link show $userdev \n\n"
$ipbin link show $userdev
sleep 1

printf "\n\n$iwbin $userdev link \n\n"
$iwbin $userdev link
sleep 1

printf "\n\nHere is a scan for ya and hopefully $userssid is on there: \n\n"
$iwbin $userdev scan
sleep 1

printf "\n\nPassing the password to /etc/wpa_supplicant.conf\n\n"
/usr/sbin/wpa_password voidnet >> /etc/wpa_supplicant.conf
sleep 1

printf "\n\nHere is what I got: \n\n"
cat /etc/wpa_supplicant.conf
sleep 1

printf "\n\nNOTICE: You should have edited this file to have the proper driver in \$userdriver \n\n"
sudo wpa_supplicant -B -i $userdev -c /etc/wpa_supplicant.conf
#sudo wpa_supplicant -D $userdriver -B -i $userdev -c /etc/wpa_supplicant.conf
sleep 1

printf "\n\ndhclient  $userdev\n\n"
dhclient $userdev
sleep 1

printf "\n\n \$ipbin addr show $userdev"
$ipbin addr show $userdev
sleep 1

$ipbin route show $userdev
printf "\n\n \$ipbin route show $userdev \n\n"
sleep 1

printf "\n\n \$ipbin route add default via $usergateway dev $userdev\n\n"
$ipbin route add default via $usergateway dev $userdev
sleep 1

printf "\n\n \$ipbin route show $userdev\n\n"
$ipbin route show $userdev
sleep 1

printf "\n\nTesting local_unbound:\n\n"
/sbin/ping -c 5 google.com @127.0.0.1

printf "\n\nRunning normal ping: \n\n"
/sbin/ping -c 5 google.com 

printf "\n\n now go rtfm and hack! ->tor->vpn+proxychains \n\n"
printf "\n\n now go rtfm and hustle! ->vpn->tor+proxychains \n\n"

# EOF
