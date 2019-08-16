function get-backupmount {
    echo ""
    read -p "Backup MountPoint? > " BackupMountPoint
    if [ ! [ -d $BackupMountPoint ] ]; then
        echo "$BackupMountPoint not a valid location!"
        exit 1
    fi
}
