#!/bin/bash

# get total CPU usage
get_cpu_usage() {
    echo "CPU Usage:"
    top -bn1 | grep "%Cpu(s):" | \
    cut -d ',' -f 4 | \
    awk '{print "Usage: " 100-$1 "%"}' 
}

# get total memory usage
get_memory_usage() {
    echo "Memory Usage:"
    free | grep "Mem:" -w | awk '{printf "Total: %.1fGi\nUsed: %.1fGi (%.2f%%)\nFree: %.1fGi (%.2f%%)\n",$2/1024^2, $3/1024^2, $3/$2 * 100, $4/1024^2, $4/$2 * 100}'
}

# get total disk usage
get_disk_usage() {
    echo "Disk Usage:"
    df -h | grep "/" -w | awk '{printf "Total: %sG\nUsed: %s (%.2f%%)\nFree: %s (%.2f%%)\n",$3 + $4, $3, $3/($3+$4) * 100, $4, $4/($3+$4) * 100}'
}

# get top 5 processes by CPU usage
get_top_cpu_processes() {
    echo "Top 5 Processes by CPU Usage:"
    ps aux --sort -%cpu | head -n 6 | awk '{print $1 "\t" $2 "\t" $3 "\t" $11}'
}

# get top 5 processes by memory usage
get_top_memory_processes() {
    echo "Top 5 Processes by Memory Usage:"
    ps aux --sort -%mem | head -n 6 | awk '{print $1 "\t" $2 "\t" $4 "\t" $11}'
}

# Additional stats
get_additional_stats() {
    echo "OS Version: $(uname -a)"
    echo "Uptime: $(uptime -p)"
    echo "Logged in Users: $(who | wc -l)"
}

main() {
    echo "Server Performance Stats"
    echo "========================"
    
    get_cpu_usage
    echo ""
    
    get_memory_usage
    echo ""
    
    get_disk_usage
    echo ""
    
    get_top_cpu_processes
    echo ""
    
    get_top_memory_processes
    echo ""
    
    get_additional_stats
}

main
