#!/usr/bin/env bash

# Variables
#BackupMount="/data/game-backups/$Container/"
User=$(id -u -n)
Group=$(id -g -n)
TimeStamp=$(date +"%m-%d-%Y_%H-%M-%S")

# Load Appropriate Function Scripts based on $ContainerTech
ContainerTech="docker"

function Load_Functions () {
    for fn in $(find functions/$ContainerTech/ -name "*.sh"); do
        . $fn
    done
}

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
            BackupMount="$1/$Container/";
            ;;
        *)  ;;
    esac
    shift
done

if [[ "$NonInteractive" -eq 1 ]]; then
    get-containers
    BackupMount="/data/game-backups/$Container/"
fi

# Retrieve array of Volumes from Container to backup
# - https://dzone.com/articles/demystifying-the-data-volume-storage-in-docker
# - https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
# - https://unix.stackexchange.com/questions/177843/parse-one-field-from-an-json-array-into-bash-array
#Volumes=( $(docker inspect --format '{{json .Mounts}}' $Container | jq -r '.[].Destination') )
# echo ${Volumes[@]}

get-volumes

# Create Backup of Volume
docker run --rm --volumes-from $Container -v $BackupMount:/backup ubuntu tar cvzf "/backup/$Container-$TimeStamp.tar.gz" ${Volumes[@]}

# Change Owner of Archive
sudo chown $User:$Group "$BackupMount/$Container-$TimeStamp.tar.gz"