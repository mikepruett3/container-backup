#!/usr/bin/env bash

# Variables
ScriptBase=$(dirname $0)
extenstions=( "*.zip" "*.tar.gz" "*.tar" )

# Check Parameters
while [ "$#" -gt 0 ]; do
    case "$1" in
        -days)
            shift;
            Days=$1;
            ;;
        -b)
            shift;
            if [ -d $1 ]; then
                BackupMount="$1/";
            else
                echo "$1 not a valid location!"
                exit 1
            fi
            ;;
        *)  ;;
    esac
    shift
done

for i in "${extensions[@]}"
do
    #:
    echo "$i"
    # Delete Archive files older than $Days
    find "$BackupMount" -type f -name "$i" -mtime "+$Days" -print -delete
done
