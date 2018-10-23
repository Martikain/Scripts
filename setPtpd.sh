#!/bin/bash

# Downloads PTPD for software clock synchronization.
# Sets it to automatically run on startup.

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ $(dpkg-query -W -f='${Status}' ptpd 2>/dev/null | grep -c "ok installed") -eq 0 ]
  then
  echo 'Installing ptpd...'
  apt install ptpd
  echo 'ptpd installed!'
else
  echo 'ptpd already installed. Skipping installation'
fi

if [ -z "$1" ]
  then
  echo "Please provide the name of the Ethernet interface as argument."
  exit 1
else
  if grep -Fxq 'ptpd' /etc/rc.local
  then 
    echo 'ptpd input already found at /etc/rc.local'
    echo 'Please remove any ptpd inputs before running this script'
    exit 1
  fi

  echo 'Creting automatic startup by appending to /etc/rc.local'
  sed -i "s/^exit 0/ptpd -i $1 -m/" /etc/rc.local
  echo 'exit 0' >> /etc/rc.local

  echo '*******************************************************************'
  echo "ptpd set up for interface $1"
  echo 'To check if it is working, run following command on next startup:'
  echo 'ps ax | grep ptpd'
  echo 'This should print two lines. If only one line is printed, check the'
  echo 'network interface in /etc/rc.local file'
  echo '*******************************************************************'
fi

