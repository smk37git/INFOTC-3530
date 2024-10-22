#!/bin/bash

# Sebastian Main

# Function to display CPU information
# Use 'lscpu' to gather CPU details and filter for 'Model name' and 'CPU MHz' using awk
# Display the gathered CPU information in a Zenity text-info dialog box
cpu_info() {
    cpu_detail=$(lscpu | awk '/Model name|CPU MHz/')
    if [ -n "$cpu_detail" ]; then
        zenity --info --title="CPU Details" --text="$cpu_detail"
    else
        zenity --error --text="Error: No CPU details found."
    fi
}

# Function to check disk health using smartctl
# Use Zenity to prompt the user to enter a disk name (e.g., /dev/sda)
# Check if the user entered a valid disk name
# Run smartctl to check the disk's health status and filter for relevant health info
# Display the health status result in a Zenity info box
# Show an error message if no disk name was provided
disk_health() {
    disk_name=$(zenity --file-selection --title="Select disk")
    if [ -z "$disk_name" ]; then
        zenity --error --text="No file selected. Exiting program..."
        exit 1
    fi

    health_status=$(smartctl -H "$disk_name" 2>/dev/null | grep "SMART overall-health")

    if [ $? -eq 0 ]; then
        zenity --info --text="$health_status"
    else
        zenity --error --info="Could not get disk health information in $disk_name."
    fi

}

# Function to display PCI devices information
# Use lspci to list all PCI devices and filter out only VGA and Network-related devices using awk
# Display the filtered PCI device information using a Zenity text-info dialog
pci_devices() {
    pci_devices=$(lspci | awk "/VGA|Network/")

    if [ -n "$pci_info" ]; then
        zenity --info --title="PCI device info" --text="$pci_devices"
    else    
        zenity --error --text="No Network or VGA devices found"
    fi
}

# Function to show the status of network interfaces
# Use ifconfig to list all network interfaces, then filter to show only interface names using grep
# Display the network interface status in a Zenity text-info dialog
network_status() {
    interfaces_status=$(ifconfig | grep '^[a-zA-Z0-9]' -A 1 | grep 'inet' | awk '{print $1 ": " $2}')

    if [ -n "$interfaces_status" ]; then
        zenity --info --title="Network Interface Status" --text="$interfaces_status"
    else
        zenity -error --text="No interfaces found."
    fi

}   

# Function to list input devices connected to the system
# Read from /proc/bus/input/devices to get input device information
# Use grep to filter the output for 'Name' and 'Handlers' fields
# Display the input device details in a Zenity text-info dialog
input_devices() {
    
    input_device=$(grep -E "Name|Handlers" /proc/bus/input/devices)

    if [ -n "$device_info" ]; then
        zenity --info --title-"Input Devices" --text="$device_info"
    else
        zenity --error --text="No Input Devices found"
    fi
}

# Main Menu using Zenity and a switch-case statement to execute selected functions
# Use Zenity to display a list of options in a dialog box, allowing the user to select a function
while true; do
    
    action=$(zenity --list --title="System Analysis Menu" \
        --column="Select an Option" \
        "CPU Info" "Disk Health" "PCI Devices" "Network Status" "Input Devices" "Exit")

    # Use a switch-case statement to determine which function to execute based on user selection
    case $action in
        "CPU Info")
            cpu_info
            ;;
        "Disk Health")
            disk_health
            ;;
        "PCI Devices")
            pci_devices
            ;;
        "Network Status")
            network_status
            ;;
        "Input Devices")
            input_devices
            ;;
        "Exit")
            exit 0
            ;;
        *)
            # Display an error message if an invalid selection is made (this should rarely happen)
            zenity --error --text="Invalid selection."
            ;;
    esac
done