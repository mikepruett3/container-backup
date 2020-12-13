#!/usr/bin/env bash

# Variables
User=$(id -u -n)
Group=$(id -g -n)
TimeStamp=$(date +"%m-%d-%Y_%H-%M-%S")
ScriptBase=$(dirname $0)

# Load Base Function Scripts
for fn in $(find $ScriptBase/functions/base/ -name "*.sh"); do
    . $fn
done

# Load Appropriate Function Scripts based on $ContainerTech
ContainerTech="docker"
for fn in $(find $ScriptBase/functions/$ContainerTech/ -name "*.sh"); do
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

get-binds

# List the latest backups avaliable in the directory
Backups=($(ls -1t $BackupMount | head -n 3))
echo "Listing Avaliable Backups:"
echo ""
printf '%s\n' "${Backups[@]}"
echo ""
read -p "Which Backup file to Restore? > " Backup
if [[ $(printf "%s\n" "${Backups[@]}" | grep "^$Backup$") == $NULL ]]; then
    echo "$Backup not a valid Backup file!"
    exit 1
fi

# Restore Volumes from Backup
#docker run --rm --volumes-from $Container -v $BackupMount:/backup ubuntu bash -c "cd / && tar xvf /backup/$Backup"
echo docker run --rm --volumes-from $Container -v $BackupMount:/backup ubuntu bash -c "cd / && tar xvf /backup/$Backup"
