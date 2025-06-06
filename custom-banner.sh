#!/bin/sh

. /opt/etc/profile

# PROMPT
# colors

blk="\033[1;30m"   # Black
red="\033[1;31m"   # Red
grn="\033[1;32m"   # Green
ylw="\033[1;33m"   # Yellow
blu="\033[1;34m"   # Blue
pur="\033[1;35m"   # Purple
cyn="\033[1;36m"   # Cyan
wht="\033[1;37m"   # White
clr="\033[0m"      # Reset

# Set the prompt.
sh_prompt() {
    PS1=${cyn}' \w '${grn}' \$ '${clr}
}
sh_prompt

# Обновление opkg
opkg update > /dev/null 2>&1

# Зависимости: coreutils-df procps-ng-free procps-ng-uptime

# Определение типа процессора
_CPU_TYPE="$(cat /proc/cpuinfo | awk -F: '/(model|system)/{print $2}' | head -1 | sed 's, ,,')"

if [ "$(uname -m)" = "aarch64" ]; then
    CPU_TYPE="$_CPU_TYPE"
else
    CPU_TYPE="$_CPU_TYPE$(cat /proc/cpuinfo | awk -F: '/cpu model/{print $2}' | head -1)"
fi

# Получение внешнего IP
EXT_IP="$(curl -s https://ipinfo.io/ip 2>/dev/null || echo 'N/A')"

# Вывод информации
printf "\n"
printf "   ${wht} %-10s ${ylw} %-30s ${wht} %-10s ${ylw}    %-30s ${clr}\n" \
    "Date:" "📆$(date)" \
    "Uptime:" "🕐 $(uptime -p)"
printf "   ${wht} %-10s ${blu} %-30s ${wht} %-10s ${blu}  %-30s ${clr}\n" \
    "Router:" "$(ndmc -c "show version" 2>/dev/null | awk -F": " '/model/ {print $2}')" \
    "Accessed IP:" "$EXT_IP"
printf "   ${wht} %-10s ${grn} %-30s ${wht}   %-10s ${grn}    %-30s ${clr}\n" \
    "OS:" "$(uname -s) 🐧" \
    "CPU:" "$CPU_TYPE"
printf "   ${wht} %-10s ${grn} %-30s ${wht} %-10s ${grn} %-30s ${clr}\n" \
    "Kernel:" "$(uname -r)" \
    "Architecture:" "$(uname -m)"
printf "   ${wht} %-10s ${red} %-30s ${wht}\n" \
    "CPU Temp:" "$(($(cat /sys/class/thermal/thermal_zone0/temp)/1000))°C"
printf "   ${wht} %-10s ${pur} %-30s ${clr}\n" \
    "Disk:" "$(df -h | grep '/opt' | awk '{print $2" (size) / "$3" (used) / "$4" (free) / "$5" (used %) : 💾 "$6}')"
printf "   ${wht} %-10s ${pur} %-30s ${clr}\n" \
    "Memory:" "$(free -h --mega | awk '/Mem/{print $2" (total) / "$3" (used) / "$4" (free)"}')"
printf "   ${wht} %-10s ${pur} %-30s ${clr}\n" \
    "Swap:" "$(free -h --mega | awk '/Swap/{print $2" (total) / "$3" (used) / "$4" (free)"}')"
printf "   ${wht} %-10s ${pur} %-30s ${clr}\n" \
    "LA:" "$(cat /proc/loadavg | awk '{print $1" (1m) / "$2" (5m) / "$3" (15m)"}')"
printf "   ${wht} %-10s ${red} %-30s ${wht}\n" \
    "User:" "🤵 $(echo $USER)"

# Версия Entware
if [ -f "/opt/etc/entware_release" ]; then
    printf "   ${wht} %-10s ${grn} %-30s ${clr}\n" \
        "Dist:" "$(awk -F= '/^PRETTY_NAME/ {gsub(/"/, "", $2); print $2}' /opt/etc/entware_release)"
else
    printf "   ${wht} %-10s ${grn} %-30s ${clr}\n" \
        "Dist:" "Entware"
fi

# Установленные и доступные обновления
printf "   ${wht} %-10s ${cyn} %-30s ${wht}     %-10s ${cyn} %-30s ${clr}\n" \
    "Installed:" "📦📦 $(opkg list-installed | wc -l)" \
    "Upgrade:" "📦 $(opkg list-upgradable | wc -l)"
printf "\n"
