#!/usr/bin/env bash

# Variables
User=$(id -u -n)
Group=$(id -g -n)
TimeStamp=$(date +"%m-%d-%Y_%H-%M-%S")

echo "$0"

# Load Base Function Scripts
for fn in $(find functions/base/ -name "*.sh"); do
    . $fn
done

# Load Appropriate Function Scripts based on $ContainerTech
ContainerTech="docker"
for fn in $(find functions/$ContainerTech/ -name "*.sh"); do
    . $fn
done

if [ "$#" -eq 0 ]; then
    NonInteractive=1
fi

# Check Parameters
while [ "$#" -gt 0 ]; do
    case "$1" in
        -c)
            shift;
            Container=$1;
            ;;
        -b)
            shift;
            if [ -d $1 ]; then
                BackupMount="$1/$Container/";
            else
                echo "$1 not a valid location!"
                exit 1
            fi
            ;;
        *)  ;;
    esac
    shift
done

if [[ "$NonInteractive" -eq 1 ]]; then
    get-containers
    get-backupmount
    BackupMount="$BackupMountPoint/$Container/"
fi

get-volumes

# Create Backup of Volume
#docker run --rm --volumes-from $Container -v $BackupMount:/backup ubuntu tar cvzf "/backup/$Container-$TimeStamp.tar.gz" ${Volumes[@]}

# Change Owner of Archive
#sudo chown $User:$Group "$BackupMount/$Container-$TimeStamp.tar.gz"