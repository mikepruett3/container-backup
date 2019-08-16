# Retrieve array of Volumes from Container to backup
# - https://dzone.com/articles/demystifying-the-data-volume-storage-in-docker
# - https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
# - https://unix.stackexchange.com/questions/177843/parse-one-field-from-an-json-array-into-bash-array

function get-volumes {
    Volumes=( $(docker inspect --format '{{json .Mounts}}' $Container | jq -r '.[].Destination') )
    # echo ${Volumes[@]}
}
