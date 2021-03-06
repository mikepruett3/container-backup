# Retrieve array of Binds from Container to backup
# - https://dzone.com/articles/demystifying-the-data-volume-storage-in-docker
# - https://stackoverflow.com/questions/1955505/parsing-json-with-unix-tools
# - https://unix.stackexchange.com/questions/177843/parse-one-field-from-an-json-array-into-bash-array

function get-binds {
    Volumes=( $(docker inspect --format '{{json .Mounts}}' $Container | jq -r '.[] | select(.Type=="volume").Destination') )
    # - https://stackoverflow.com/questions/16860877/remove-an-element-from-a-bash-array
    Exceptions=(    "/downloads" \
                    "/Downloads" \
                    "/incomplete-downloads" \
                    "/movies" \
                    "/3dmovies" \
                    "/anime-movies" \
                    "/music-videos" \
                    "/tv" \
                    "/anime" \
                    "/hentai" \
                    "/music" \
                    "/comics" \
                    "/pre-roll" \
                    "/transcode" \
                    "/timemachine" \
                    "/var/lib/motioneye" \
                    "/etc/localtime" \
                    "/dev/rtc" )
    for Exception in ${Exceptions[@]}
    do
        Volumes=("${Volumes[@]/$Exception}")
    done
    #echo ${Volumes[@]}
}
