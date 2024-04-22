#!/usr/bin/bash

set -euo pipefail

TEMPLATE="%-10s%-20s%-6s%-6s%-10s%-10s%-10s\n"

main() {
    clear
    stty -echo # Disable echoing of input characters
    stty -icanon # Disable line buffering (raw mode)
    tput civis # makes cursor invisible
    tput rev # white background 
    printf "$TEMPLATE" "PID" "COMMAND" "STATE" "CPU%" "VIRT" "UTIME" "STIME"
    tput sgr0 # removes background color

    while true; do
        tput cup 1 0
        get_process_info
        sleep 1 
    done
}
get_process_info() {
    for pid_path in /proc/*; do
        pid=$(basename "$pid_path")
        if [[ ! "$pid" =~ ^[0-9]+$ ]]; then
            continue
        fi
        if [[ ! -e "$pid_path/stat" ]]; then
            continue
        fi
        stat=( $(cat "$pid_path/stat") )
        if (( "${stat[22]}" < 10000000 )); then
            continue
        fi
        comm=$(cat "$pid_path/comm")
        state="${stat[2]}"
        utime="${stat[13]}"
        stime="${stat[14]}"
        cpu_usage=$(get_cpu_usage ${stat[13]} ${stat[14]} ${stat[21]})
        vm_size=$( convert_bytes_to_mbytes "${stat[22]}" )

        printf "$TEMPLATE" "$pid" "$comm" "$state" "$cpu_usage" "$vm_size" "$utime" "$stime"
    done
}

convert_bytes_to_mbytes() {
    local bytes=$1
    local mbytes=$(( bytes / 1024 / 1024 ))
    echo "${mbytes}MB"
}

get_cpu_usage() {
    process_utime=$1
    process_stime=$2
    process_starttime=$3
    system_uptime_sec=$(tr . ' ' </proc/uptime | awk '{print $1}')
    clk_tck=$(getconf CLK_TCK)

    if [[ -z "$process_utime" || -z "$process_stime" || -z "$process_starttime" ]]; then
        echo "0"
        return 1
    fi
    let process_utime_sec="$process_utime / $clk_tck"
    let process_stime_sec="$process_stime / $clk_tck"
    let process_starttime_sec="$process_starttime / $clk_tck"
    let process_elapsed_sec="$system_uptime_sec - $process_starttime_sec"
    let process_usage_sec="$process_utime_sec + $process_stime_sec"
    let process_usage="$process_usage_sec * 100 / $process_elapsed_sec"

    echo "${process_usage}"
}
finish() {
    clear
    tput cnorm # shows cursor  
    stty icanon 
    stty echo 
}
trap 'finish' 0
main