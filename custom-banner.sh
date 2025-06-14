#!/bin/sh

. /opt/etc/profile

# Цветовые коды
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'
NC='\e[0m' # No Color

print_banner() {
    printf "\e[1;1H\e[2J" # Очистка экрана
    printf "${RED}"
    cat << 'EOF'
                        _______   _________       _____    ____  ______
                       / ____/ | / /_  __/ |     / /   |  / __ \/ ____/
                      / __/ /  |/ / / /  | | /| / / /| | / /_/ / __/
                     / /___/ /|  / / /   | |/ |/ / ___ |/ _, _/ /___
                    /_____/_/ |_/ /_/    |__/|__/_/  |_/_/ |_/_____/
EOF
}

get_cpu_temp() {
    local temp_file="/sys/class/thermal/thermal_zone0/temp"
    [ ! -f "$temp_file" ] && printf "${YELLOW}N/A${NC}" && return
    
    local temp=$(cat "$temp_file")
    local temp_c=$(echo "scale=1; $temp/1000" | bc)
    
    if [ $(echo "$temp_c >= 65" | bc) -eq 1 ]; then
       printf "${RED}%.1f°C${NC}" "$temp_c"
    else
       printf "${GREEN}%.1f°C${NC}" "$temp_c"
    fi
}

print_system_info() {
    # Получаем все данные
    local busybox=$(busybox 2>&1 | awk 'NR==1{print " ", $2}')
    local current_date=$(date +'%Y-%m-%d %H:%M:%S')
    local uptime=$(uptime -p 2>/dev/null | sed 's/^up //' || echo 'N/A')
    local router_model=$(ndmc -c "show version" 2>/dev/null | awk -F": " '/model/ {print $2}' || echo 'Unknown')
    local ext_ip=$(curl -s --connect-timeout 3 https://ipinfo.io/ip || echo 'N/A')
    local cpu_type=$(cat /proc/cpuinfo 2>/dev/null | awk -F: '/model name|system type/{print $2}' | head -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [ -z "$cpu_type" ] && cpu_type="Unknown"
    local cpu_temp=$(get_cpu_temp)
    local cores=$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo 2>/dev/null || echo "?")
    local architecture=$(uname -m)
    local kernel=$(uname -r)
    local os=$(uname -s)
    local processes=$(ps | wc -l)
    local disk_info=$(df -h /opt 2>/dev/null | awk 'NR==2{print $3"/"$2" used ("$5")"}')
    local mem_info=$(free -h 2>/dev/null | awk '/Mem/{print $3"/"$2" used"}')
    local swap_info=$(free -h 2>/dev/null | awk '/Swap/{print $3"/"$2" used"}')
    local load_avg=$(awk '{print $1", "$2", "$3}' /proc/loadavg 2>/dev/null)
    local packages=$(opkg list-installed 2>/dev/null | wc -l)
    local upgrades=$(opkg list-upgradable 2>/dev/null | wc -l)
    local ssh_sessions=$(netstat -tn 2>/dev/null | grep -c ':222.*ESTABLISHED')

    # Вывод информации с идеальным выравниванием
    printf "\n"
    printf "   ${WHITE}%-15s${YELLOW}%-35s${NC}\n" "BusyBox:" "$busybox"
    printf "   ${WHITE}%-15s${YELLOW}%-35s${NC}\n" "Date:" "📆 $current_date"
    printf "   ${WHITE}%-15s${YELLOW}%-35s${NC}\n" "Uptime:" "🕐 $uptime"
    printf "   ${WHITE}%-15s${RED}%-35s${NC}\n" "Router:" "$router_model"
    printf "   ${WHITE}%-15s${RED}%-35s${NC}\n" "External IP:" "$ext_ip"
    printf "   ${WHITE}%-15s${GREEN}%-35s${NC}\n" "OS:" "$os 🐧"
    printf "   ${WHITE}%-15s${GREEN}%-35s${NC}\n" "CPU:" "$cpu_type"
    printf "   ${WHITE}%-15s${GREEN}%-35s${NC}\n" "Kernel:" "$kernel"
    printf "   ${WHITE}%-15s${GREEN}%-35s${NC}\n" "Architecture:" "$architecture"
    printf "   ${WHITE}%-15s🌡 %-35s${NC}\n" "CPU Temp:" "$cpu_temp"
    printf "   ${WHITE}%-15s${RED}%-35s${NC}\n" "Cores:" "$cores"
    printf "   ${WHITE}%-15s${RED}%-35s${NC}\n" "Processes:" "$processes"
    printf "   ${WHITE}%-15s${PURPLE}%-35s${NC}\n" "Disk Usage:" "💾 $disk_info"
    printf "   ${WHITE}%-15s${PURPLE}%-35s${NC}\n" "Memory:" "🧠 $mem_info"
    printf "   ${WHITE}%-15s${PURPLE}%-35s${NC}\n" "Swap:" "🔀 $swap_info"
    printf "   ${WHITE}%-15s${PURPLE}%-35s${NC}\n" "Load Avg:" "📈 $load_avg"
    printf "   ${WHITE}%-15s${CYAN}%-35s${NC}\n" "Packages:" "📦 $packages"
    printf "   ${WHITE}%-15s${CYAN}%-35s${NC}\n" "Upgrades:" "🔄 $upgrades"
    printf "   ${WHITE}%-15s${RED}%-35s${NC}\n" "SSH Sessions:" "🔌 $ssh_sessions"
    printf "\n${NC}"
}

# Главный запуск
print_banner
print_system_info
