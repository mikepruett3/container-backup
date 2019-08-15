#!/usr/bin/env bash

#VOLUMES=(
docker inspect --format '{{json .Mounts}}' $CONTAINER | python -m json.tool
#)

#echo $VOLUMES
