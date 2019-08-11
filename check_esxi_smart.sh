#!/bin/bash

while getopts ":u:a:" opt; do
        case $opt in
        u) usr="${OPTARG}" ;;
        a) addr="${OPTARG}" ;;
        *) printf "\nUnrecognized option %s\n\n" "$1" ; exit 1 ;;
        esac
done

#Script's body. Only health statuses check

disk=$(ssh $usr@$addr /usr/lib/vmware/vm-support/bin/smartinfo* | awk '{if ($4 == "Disk") disk = $6; else if ($1 == "Health" && $3 == "OK") print disk " | Status:" $3}' | awk '{ gsub("__*"," "); print }' | awk '{$1=""; print}')

if [ -z "$disk" ]
then
  echo «All disks are OK»
  exit 0
else
  echo -e "Critical! Broken disks:\n""$disk"
  exit 2
fi


