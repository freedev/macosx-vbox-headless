#!/bin/bash

#
# Author: Vincenzo D'Amore v.damore@gmail.com
# 17/11/2014
#

VBOX_MANAGE=/usr/bin/VBoxManage
VBOX_HEADLESS=/usr/bin/VBoxHeadless

function displayhelp()
{
        echo
        echo " Usage:"
        echo
        echo -e $0 vmname\|'\x22'vmname \(long name\)'\x22'
        echo -e   '\t'Starts VM named '\x22'vmname'\x22' \(use quotes to enclose names with spaces\)
        echo
        echo -e $0 -o\|--off vmname\|'\x22'vmname \(long name\)'\x22'
        echo -e '\t'Powers off VM named '\x22'vmname'\x22' \(use quotes to enclose names with spaces\)
        echo
}

function shutdown()
{
  echo `date` " " `whoami` " Received SIGTERM, powering off VBox: $VM"

# savestate as default
# also possible are:  acpipowerbutton and poweroff
# See: http://www.virtualbox.org/manual/ch08.html#vboxmanage-controlvm

  echo $VBOX_MANAGE controlvm $VM acpipowerbutton
  $VBOX_MANAGE controlvm $VM acpipowerbutton
  echo `date` " " `whoami` " Shutting down VBox: $VM"
  TEMPFILE=/tmp/$$.counter.tmp
  echo 0 > $TEMPFILE
  VMUUIDTEMPFILE=/tmp/$$.vmUUID.tmp
  echo $VM > $VMUUIDTEMPFILE
  while (true) ; 
  do sleep 5; 
    VMUUID=$(cat $VMUUIDTEMPFILE)
    COUNTER=$[$(cat $TEMPFILE) + 1]
    echo $COUNTER > $TEMPFILE
    COMMAND=${VBOX_HEADLESS##*/}
    found=$( ps -ef | grep -v grep | grep $COMMAND | grep -c $VMUUID ); 
    if [ "$found" == '0' ]
    then 
        break
    else
        echo `date` " " `whoami` " Waiting for process "$COMMAND" "$VMUUID" ("$COUNTER")..."
    fi
    found1=$( ps -ef | grep -v grep | grep $COMMAND | grep $VMUUID ); 
# TIMEOUT AFTER 120 SECONDS
    if [ $COUNTER -gt 24 ] 
    then
        echo `date` " " `whoami` " Warning: Timeout. Forced VM power off"
        echo `date` " " `whoami` " "$COUNTER"  "$VM
        echo `date` " " `whoami` " PID FOUND: "$found1
        break;
    fi
  done
  rm $TEMPFILE
  rm $VMUUIDTEMPFILE
  echo `date` " " `whoami` " Powered off VBox: $VM"
  echo
  exit 0
}

function startup()
{
        echo `date` " " `whoami` " Starting VBox: $VM"
        $VBOX_HEADLESS -startvm $VM &
        wait $!
        echo `date` " " `whoami` " Daemon exited: "$0 $1 $2
}

if [ "$1" != "" ]
then
#   Expects VM name to be passed as parameter
trap shutdown SIGTERM
trap shutdown SIGKILL

echo
echo `date` " " `whoami` " Daemon launched:  " $0 $1 $2

case $2 in
-o|--off ) 
    VM=$1; shutdown $VM;;
esac

case $1 in
-o|--off ) 
    VM=$2; shutdown $VM;;
-l|--list ) 
    VBOX_MANAGE list vms
    ;;
-h|--help ) 
    displayhelp;;
* )
    if [ "$1" != "" ]
    then
        VM=$1; 
        echo `date` " " `whoami` " VM: "$VM; 
        startup $VM;
    fi
    ;;
esac

else
    displayhelp
fi
