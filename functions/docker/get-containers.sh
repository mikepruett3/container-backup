# Function to prompt for Container
get-containers() {
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
