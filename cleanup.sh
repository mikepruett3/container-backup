#!/usr/bin/env bash

# Variables
ScriptBase=$(dirname $0)

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

# Delete Archive files older than $Days
find "$BackupMount" -name "*.tar.gz" -mtime "+$Days" -print -delete
