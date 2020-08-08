#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
workspace_config () {
    echo "Enter your git username"
    read git_username
    echo "Enter the url of the git repository you want to use"
    echo "Only provide the repo name e.g. clonezilla-builder.git"
    read git_url
    export workspace_dir=/tmp/pchelp
    export workspace_script_dir=/tmp/pchelp/linux-scripts

    if [[ -d ${workspace_dir} ]]
        then
            rm -rf ${workspace_dir}
            mkdir ${workspace_dir} -p
        else
            mkdir ${workspace_dir} -p
    fi

    cd ${workspace_dir}
    apt install git -y
    git clone https://github.com/${git_username}/${git_url}
}
select_scripts () {
    list_scripts () {
        # List all Avaialble drives for discovery
        cd ${workspace_script_dir}
        scripts_list=$(ls)
        # Turn list into array
        script_array=($scripts_list)
    }
    script_dialog () {
        title="Device Management"

        # Prompt for drives to be added
        list_scripts

        # Message box selector formatting
        entry_options=()
        entries_count=${#script_array[@]}
        message_a=$'Choose a script to run. To select a script, use the space bar and arrow keys.\n\n'
        message_b=$'Press Enter when you have selected the script you wish to run\n\n'
        message_c=$'Available Scripts:\n\n'
        message=${message_a}${message_b}${message_c}

        # Seed the message box
        for i in "${!script_array[@]}"; do
            entry_options+=("$i")
            entry_options+=("${script_array[$i]}")
            entry_options+=("OFF")
        done

        # Display the message box
        export v_script=$(whiptail \
                        --radiolist \
                        --title "Device choice" \
                        --nocancel \
                        "$message" 20 78 \
                        $entries_count -- \
                        "${entry_options[@]}" \
                        3>&1 1>&2 2>&3)
    }
    script_dialog
    export selected_script=$(echo "${script_array[${v_script}]}" | awk '{ print $1 }')
    clear
}
configure_proxy
configure_repository
workspace_config
while :
    do
        # loop infinitely
        select_scripts
        ./${selected_script}
done