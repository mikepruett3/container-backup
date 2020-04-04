# Retrieve array of Volumes from Container to backup
# - https://www.adelton.com/docs/docker/docker-inspect-volumes-mounts

function get-volumes {
    Volumes=( $(docker inspect --format '{{ range .Mounts }} {{ if eq .Type "volume" }} {{ .Name }} {{ end }} {{ end }}' $Container) )
    echo ${Volumes[@]}
}
