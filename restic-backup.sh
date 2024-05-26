#!/usr/bin/env bash

# Variables
#User=$(id -u -n)
#Group=$(id -g -n)
#TimeStamp=$(date +"%m-%d-%Y_%H-%M-%S")
ScriptBase=$(dirname $0)

# Load Base Function Scripts
for fn in $(find $ScriptBase/functions/base/ -name "*.sh"); do
    source $fn
done

# Load Appropriate Function Scripts based on $ContainerTech
ContainerTech="docker"
for fn in $(find $ScriptBase/functions/$ContainerTech/ -name "*.sh"); do
    source $fn
done

# Check Parameters
case "$1" in
    -c)
        shift;
        Container=$1;
        VolumeFile=/tmp/volumes-$Container.txt
        rm -f "$VolumeFile"
        ;;
    -e)
        shift;
        if [ -f $1 ]; then
            source $1;
        else
            echo "$1 not a valid environment file!"
            exit 1
        fi
        ;;

    *)  ;;
esac
shift

# Collect all of the Volume binds from the Container
get-binds

# Write Container Volumes to file
printf '%s\n' "${Volumes[@]}" > $VolumeFile

# Create Backup of Volume
docker run --rm \
    --hostname $Container \
    -ti \
    --volumes-from $Container \
    -e GOOGLE_PROJECT_ID=$GOOGLE_PROJECT_ID \
    -e GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS \
    -e RESTIC_PASSWORD=$RESTIC_PASSWORD \
    -e RESTIC_REPOSITORY=$RESTIC_REPOSITORY \
    -v $GOOGLE_APPLICATION_CREDENTIALS:$GOOGLE_APPLICATION_CREDENTIALS \
    -v $VolumeFile:/volumes.txt \
    restic/restic \
    backup \
    --files-from /volumes.txt \
