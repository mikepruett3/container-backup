#!/usr/bin/env bash

## Borrowing code from another project - https://github.com/mikepruett3/terraria-scripts ##

# Function to prompt for Container
containers() {
    Containers=( $(docker container list --format '{{.Names}}') )
    echo "Listing Containers:"
    echo ""
    printf '%s\n' "${Containers[@]}"
    echo ""
    read -p "Which Container? > " Container
    if [[ $(printf "%s\n" "${Containers[@]}" | grep "^$Container$") == $NULL ]]; then
        echo "$Container not a valid Container!"
        exit 1
    fi
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
        #-u)
        #    shift;
        #    User=$1;
        #    ;;
        #-g)
        #    shift;
        #    Group=$1;
        #    ;;
        *)  ;;
    esac
    shift
done

if [[ "$NonInteractive" -eq 1 ]]; then
    #User=$(id -u -n)
    #Group=$(id -g -n)
    containers
fi

## https://dzone.com/articles/demystifying-the-data-volume-storage-in-docker ##
# Retrieve array of Volumes from Container to backup
#VOLUMES=$(docker inspect --format '{{json .Mounts}}' $Container | python -m json.tool)
VOLUMES=( $(docker inspect --format '{{json .Mounts}}' $Container | jq -r '.[].Destination') )

# https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
echo ${VOLUMES[@]}
