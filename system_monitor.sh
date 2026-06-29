#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"
VERSION="2.0" 

print_header() {
    echo "================================="
    echo "      Linux System Monitor"
    echo "================================="
}

get_system_info() {
    USER_NAME=$(whoami)
    HOST_NAME=$(hostname)
    CURRENT_DATE=$(date)
    DISK_USAGE=$(df -h | grep "/$" | awk '{print $5}')
    DISK_TOTAL=$(df -h | grep "/$" | awk '{print $2}')
    MEM_TOTAL=$(free -h |grep Mem | awk '{print $2}')
    MEM_USED=$(free -h | grep Mem | awk '{print $3}')
    KERNEL=$(uname -r)
    UPTIME=$(uptime -p)
    UPTIME=${UPTIME#up}
    LOAD_AVERAGE=$(uptime | awk -F'load average: ' '{print $2}')
    CPU_USAGE=$(mpstat 1 1 | tail -1 | awk '{printf "%.2f%%", 100-$NF}')
}

print_system_info(){
    printf "%-15s : %s\n" "User" "$USER_NAME"
    printf "%-15s : %s\n" "Hostname" "$HOST_NAME"
    printf "%-15s : %s\n" "Date" "$CURRENT_DATE"
    printf "%-15s : %s\n" "Kernel" "$KERNEL"
    printf "%-15s : %s\n" "Uptime" "$UPTIME"
}

check_disk() {
    DISK_PERCENT=${DISK_USAGE%\%}

    if [ "$DISK_PERCENT" -gt 80 ]; then
        printf "%-15s : %b\n" "Disk Status" "${YELLOW}WARNING${RESET}"
    else
        printf "%-15s : %b\n" "Disk Status" "${GREEN}OK${RESET}"
    fi
}


print_disk_info(){
    printf "%-15s : %s\n" "Disk Usage" "$DISK_USAGE"
    printf "%-15s : %s\n" "Disk Total" "$DISK_TOTAL"
    check_disk
}

print_memory_info(){
    printf "%-15s : %s\n" "Memory Total" "$MEM_TOTAL"
    printf "%-15s : %s\n" "Memory Used" "$MEM_USED"
}

print_cpu_info() {
    printf "%-15s : %s\n" "CPU Usage" "$CPU_USAGE"
    printf "%-15s : %s\n" "Load Average" "$LOAD_AVERAGE"
}

print_help() {
    echo "Linux System Monitor"
    echo
    echo "Usage:"
    echo "  ./system_monitor.sh [OPTION]"
    echo
    echo "Options:"
    echo "  --help     Display this help message"
    echo "  --version  Display program version"
    echo "  --system   Display system informations"
    echo "  --disk     Display disk informations"
    echo "  --memory   Display memory informations"
    echo "  --cpu      Display cpu informations"
    echo "  --all      Display all informations"
}

print_version() {
    echo "Linux System Monitor version $VERSION"
}

case "$1" in 

    --help)
        print_help
        ;;

    --version)
        print_version
        ;;

    --system)
        get_system_info
        print_header
        print_system_info
        ;;
 
    --disk)
        get_system_info
        print_header
        print_disk_info
        ;;

    --memory)
        get_system_info
        print_header
        print_memory_info
        ;;

    --cpu)
        get_system_info
        print_header
        print_cpu_info
        ;;

    --all|"")
        get_system_info
        print_header
        print_system_info
        print_memory_info
        print_cpu_info
        print_disk_info
        ;;

    *)
       echo "Unkown option"
       ;;
esac
