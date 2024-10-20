#!/bin/bash
LogFile="./rclone_sync.log"
DryRun=false
Notify=false    
ConfigFile="./config.txt"

if [[ -f "$ConfigFile" ]]; then
    #readarray -t config < "$ConfigFile"
    #RemoteName="${config[0]}"
    #Destination="${config[1]}"
    RemoteName="Google Drive:"
    Destination="/run/media/hiayzei/HD/Coding"
else
    read -p "Enter Remote Name (e.g., 'Google Drive:'): " RemoteName
    read -p "Enter Destination Path (e.g., '/run/media/hiayzei/HD/Coding'): " Destination
    echo "$RemoteName" > "$ConfigFile"
    echo "$Destination" >> "$ConfigFile"
fi

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LogFile"
}

send_notification() {
    if [ "$Notify" = true ]; then
        notify-send "$1"
    fi
}

speak() {
    if command -v espeak >/dev/null 2>&1; then
        espeak "$1"
    fi
}

start() {
    sync_output=$(rclone bisync --resync --verbose --force "$Destination" "$RemoteName" 2>&1)

    if [ $? -eq 0 ]; then
        log_message "Sync completed successfully."
        speak "Synchronization completed successfully"

        echo "Sync completed successfully."
    else
        log_message "Error during sync."
        speak "Error during synchronization"

        echo "Error during synchronization"
    fi

    echo "Bidirectional sync finished." >> "$LogFile"
}

echo "Initiating synchronization between '$RemoteName' and '$Destination'..."
while true; do
    start
    sleep 5
done
