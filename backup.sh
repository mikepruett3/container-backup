#!/usr/bin/env bash

#VOLUMES=(
echo $CONTAINER
docker inspect --format '{{json .Mounts}}' $CONTAINER | python -m json.tool
#)

#echo $VOLUMES
