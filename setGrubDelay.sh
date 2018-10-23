#!/bin/bash

# Sets the Grub startup delay.
# Delay can be set with first parameter.
# Default delay is 15 seconds.

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -z "$1" ]
  then
    echo "No argument provided. Setting default delay of 15 seconds."
    delay=15
else
  integers='^[0-9]+$'
  if ! [[ $1 =~ $integers ]] ; then
    echo "ERROR: Given delay is not an integer." >&2; exit 1
  else
    delay=$1
  fi
fi

echo "Delay is set to $delay seconds."

# Add the delay to /etc/default/grub
sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$delay/" /etc/default/grub
update-grub

exit 0

