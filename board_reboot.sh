#!/bin/bash

declare -A B06=( [IP]="10.7.2.6"    [PWR]="10.7.0.93"   [APC]="1"   [PORT]="6" )
declare -A B07=( [IP]="10.7.2.7"    [PWR]="10.7.0.95"   [APC]="2"   [PORT]="12" )
declare -A B017=( [IP]="10.7.2.17"   [PWR]="10.7.0.95"   [APC]="3"   [PORT]="17" )
declare -A B014=( [IP]="10.7.2.14"   [PWR]="10.7.0.95"   [APC]="2"   [PORT]="13" )
declare -A B011=( [IP]="10.7.2.11"   [PWR]="10.7.0.95"   [APC]="2"   [PORT]="11" )
declare -A B013=( [IP]="10.7.2.13"   [PWR]="10.7.0.95"   [APC]="2"   [PORT]="14"  )
declare -A B022=( [IP]="10.7.2.22"   [PWR]="10.7.0.95"   [APC]="2"   [PORT]="7" )
declare -A B030=( [IP]="10.7.2.30"   [PWR]="10.7.0.107"   [APC]="1"   [PORT]="2" )
declare -A B031=( [IP]="10.7.2.31"   [PWR]="10.7.0.91"   [APC]="1"   [PORT]="20" )
declare -A B032=( [IP]="10.7.2.32"    [PWR]="10.7.0.93"   [APC]="1"   [PORT]="2" )
declare -A B033=( [IP]="10.7.2.33"   [PWR]="10.7.0.93"   [APC]="1"   [PORT]="6" )
declare -A B034=( [IP]="10.7.2.34"   [PWR]="10.7.0.93"   [APC]="1"   [PORT]="4" )
declare -A B037=( [IP]="10.7.2.37"   [PWR]="10.7.0.107"   [APC]="1"   [PORT]="3" )
declare -A B043=( [IP]="10.7.2.43"   [PWR]="10.7.0.107"   [APC]="1"   [PORT]="1" )
declare -A A046=( [IP]="10.7.1.185"   [PWR]="10.7.0.95"   [APC]="3"   [PORT]="4" )
declare -A DNI=( [IP]="10.7.3.93"   [PWR]="10.7.0.93"   [APC]="1"   [PORT]="9" )

declare -a BRD_ARR=( B06 B07 B017 B014 B011 B013 B022 B030 B031 B032 B033 B034 B037 B043 A046 DNI )
valid=0

if [ -z "$1" ];
then
    echo "Usage $0 <${BRD_ARR[@]}>"
    exit 1
else
    for b in "${BRD_ARR[@]}"
    do
        [[ "$b" == "$1" ]] && valid=1 && break
    done
fi

if [ 0 -eq $valid ]; then
    echo "Usage $0 <${BRD_ARR[@]}>"
    exit 2
fi


BRD_IP=${1}[IP]
BRD_PWR=${1}[PWR]
BRD_APC=${1}[APC]
BRD_PORT=${1}[PORT]
IPADD=${!BRD_IP}
TARGET=${!BRD_PWR}
APC=${!BRD_APC}
OUTLET=${!BRD_PORT}
echo "rebooting $1 [${IPADD}]: $TARGET $APC $OUTLET"

USR=xpower
PSS=power

expect -c "
#set timeout 50

#spawn telnet ${TARGET}
#expect \"User Name :\"
#send \"${USR}\r\"
#expect \"Password  :\" 
spawn ssh -o \"StrictHostKeyChecking no\" \"${USR}\@${TARGET}\"
expect \"*?assword\" 
send \"${PSS}\r\"
send \"\r\"
sleep 1
expect \"apc>\"
send \"olReboot ${APC}:${OUTLET}\r\"
expect \"Success\"
expect \"apc>\"
send \"\r\"
puts \"\r\n\"
"
