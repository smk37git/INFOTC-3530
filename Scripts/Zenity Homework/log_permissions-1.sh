#!/bin/bash

# Sebastian Main
# INFOTC 3530


# ==============================================================================
# Firewall Log Analysis Script with Zenity Integration
# ==============================================================================
# This script analyzes a firewall log file to identify potential security threats
# based on predefined criteria such as denied access attempts, frequent access 
# attempts, and known malicious signatures. It uses Zenity to create a GUI for
# selecting the log file and inputting malicious IP addresses, as well as to
# display a summary report.
#
# Tasks:
# 1. Select log file using Zenity.
# 2. Input known malicious IP addresses via Zenity.
# 3. Identify and count denied access attempts.
# 4. Flag frequent access attempts based on a threshold.
# 5. Detect entries matching known malicious IPs.
# 6. Display a summary report using Zenity.
# ==============================================================================

# Task 1: Zenity File Selection
# Use Zenity to allow the user to select the firewall log file. Zenity will open a
# file selection dialog, and the selected file path will be stored in the log_file variable.
log_file=$(zenity --file-selection --title="Select Log File" --file-filter="*.log")

# Check if the user selected a file
# If no file was selected (i.e., log_file is empty), display an error message and exit.
if [ -z "$log_file" ]; then
    zenity --error --text="No file selected. Exiting program..."
    exit 1
fi

# Ensure the log file exists
# If the file does not exist at the specified path, display an error message and exit.
if [ ! -f "$log_file" ]; then
    zenity --error --text="Log file doesn't exist. Exiting program..."
    exit 2
fi

# Task 2: Zenity Input for Malicious IP Addresses
# Use Zenity to allow the user to enter a list of known malicious IP addresses.
# The user will enter the IPs as a comma-separated list (e.g., 192.168.1.1,10.10.10.10).
malicious_ips=$(zenity --entry --title="Input Malicious IPs" --text="Enter malicious IP addresses:")

# Check if the user provided any IP addresses
# If no IPs were entered (i.e., malicious_ips is empty), display an error message and exit.
if [ -z "$malicious_ips" ]; then
    zenity --error --text="No malicious IP addresses entered. Exiting program..."
    exit 3
fi

# Convert the malicious IPs input into a regex pattern
# This will be used in a grep command later to match log entries with malicious IPs.
# The sed command replaces commas with '|' to create an OR regex pattern.
malicious_pattern=$(echo "$malicious_ips" | sed 's/,/|/g')

# Task 3: Identify Denied Access Attempts
# Use grep to find all lines with the word 'DENY' and awk to extract the source IP address.
# Then sort the IPs and count how many times each one appears (i.e., how many times it was denied).
# Finally, sort the counts in descending order and store the result in denied_attempts.
denied_attempts=$(grep 'DENY' "$log_file" | awk '{print $NF}' | sort | uniq -c | sort -nr)

# Task 4: Flag Frequent Access Attempts
# We will identify source IPs that have been denied more than 5 times.
# This could indicate potential brute-force attacks or scanning attempts.
# The awk command checks if the count of denied attempts is greater than 5.
frequent_attempts=$(echo "$denied_attempts" | awk '$1 > 5 {print $2}')

# Task 5: Detect Known Malicious Signatures
# Use grep with the malicious_pattern to search for log entries that match any of the known
# malicious IP addresses entered by the user.
malicious_entries=$(grep -E "$malicious_pattern" "$log_file")

# Task 6: Summary Report
# Use wc to count the total number of log entries (i.e., total access attempts).
# Use awk, sort, uniq, and wc to count the number of unique source IPs that were denied.
total_attempts=$(wc -l < "$log_file")
unique_denied_ips=$(grep 'DENY' "$log_file" | awk '{print $NF}' | sort | uniq | wc -l)

# Prepare the summary report that will be displayed using Zenity
# The report will include:
# - Total number of access attempts
# - Number of unique denied IPs
# - Details on denied access attempts
# - Frequent access attempts (more than 5)
# - Detected malicious signatures
summary="Total Number of Access Attempts: $total_attempts\n"
summary+="Number of Unique Denied IPs: $unique_denied_ips\n"
summary+="\nDenied Access Attempts:\n$denied_attempts\n"
summary+="\nFrequent Access Attempts (more than 5 attempts):\n$frequent_attempts\n"
summary+="\nDetected Known Malicious Signatures:\n$malicious_entries\n"

# Display the summary report in a Zenity information dialog box
zenity --info --title="Firewall Log Analysis Summary Report" --text="$summary" --width=600 --height=400

# ==============================================================================
# End of Script
# ============================================================================