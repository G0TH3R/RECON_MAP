#!/bin/bash
#
# Title: RECON_MAP
# Author: G0TH3R
# Description:
#     This Bash script is designed for reconnaissance 
#     purposes and can be used by providing a target 
#     VM name and IP address as arguments to create a 
#     directory, display a banner, perform port 
#     scanning with nmap, and generate a "ScratchPad" 
#     file for note-taking during the reconnaissance process.
#
# usage:
#           sudo ./recon_map <Folder Name> <ip address>
#

# Check if arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <VM name> <IP Address>"
    exit 1
fi

# Set color variables
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Extract Arguments
target=$1
ip_vm=$2


# Create Directory and Folder
current_dir=$(pwd)
folder_name="$target"
path="$current_dir/$folder_name"
# Banner 
banner="
   ▄████████    ▄████████  ▄████████  ▄██████▄  ███▄▄▄▄   
  ███    ███   ███    ███ ███    ███ ███    ███ ███▀▀▀██▄ 
  ███    ███   ███    █▀  ███    █▀  ███    ███ ███   ███ 
 ▄███▄▄▄▄██▀  ▄███▄▄▄     ███        ███    ███ ███   ███ 
▀▀███▀▀▀▀▀   ▀▀███▀▀▀     ███        ███    ███ ███   ███ 
▀███████████   ███    █▄  ███    █▄  ███    ███ ███   ███ 
  ███    ███   ███    ███ ███    ███ ███    ███ ███   ███ 
  ███    ███   ██████████ ████████▀   ▀██████▀   ▀█   █▀  
  ███    ███   ${BLUE}Author: @G0TH3R_IO${GREEN}
   ▀█    █▀    ${YELLOW}Usage: ./recon_map <Folder Name> <IP Address>${RESET}                                             
"
echo -e "\n${GREEN}$banner${RESET}"
# Check if the directory already exists
if [ -d "$path" ]; then
    echo -e "\n${RED}Directory already exists: $path${RESET}"
else
    # Create the directory
    mkdir "$path"

    # Check if the directory creation was successful
    if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}Directory created: $path${RESET}"
    else
        echo -e "$\n{RED}Failed to create directory: $path${RESET}"
        exit 1
    fi
fi



# Change the current directory
cd "$path"

# Check if the current directory has changed successfully
if [ "$current_dir" != "$path" ]; then
    echo -e "${GREEN}Current directory changed to: $path${RESET}"
else
    echo -e "${RED}Failed to change current directory to: $path${RESET}"
    exit 1
fi

# Create the ScratchPad
file_path="scratchPad_$target_$ip_vm.txt"

# Check if the file exists
if [ -f "$file_path" ]; then
    echo -e "${RED}File already exists: $file_path${RESET}"
else
    # Create the file
    touch "$file_path"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}File created: $file_path${RESET}"
    else
        echo -e "${RED}Failed to create file: $file_path${RESET}"
        exit 1
    fi
fi

# Update the Target IP Address on the top panel
echo -e "${GREEN}\n\t[+] Updated Target: ${BLUE}$target${RESET} ${GREEN}IP: ${BLUE}$ip_vm ${GREEN}"
python3 /home/crimson/Scripts/ip_update_panel.py "$ip_vm" &

# Find open ports using grep
echo -e "${YELLOW}\n[+] Finding Open Ports \n${RESET}"
nmap -Pn -p- -T4 $ip_vm -oN $target_$ip_vm

port_number=$(grep -oP '^\d+/' $target_$ip_vm | cut -d'/' -f1)
echo -e "\n\t${GREEN}Port number: $port_number${RESET}"


# Executes NMAP with a comprehensive scan
echo -e "${YELLOW}\n[+] Processing NMAP ${RESET}"
nmap -Pn -sV -sC -p "$port_number" "$ip_vm" -oN "${target}_${ip_vm}-NMAP"
echo -e "${GREEN}\n[>]Target: ${RED}$target${RESET} ${GREEN}IP:${RESET} ${RED}$ip_vm ${GREEN}Ports: ${YELLOW}$port_number${RESET}"

