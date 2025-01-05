#!/bin/bash

# تابع تبدیل IP به عدد (برای مرتب‌سازی بهتر)
ip_to_decimal() {
    local ip="$1"
    local a b c d
    IFS=. read -r a b c d <<< "$ip"
    echo "$((a * 256**3 + b * 256**2 + c * 256 + d))"
}

# تابع تبدیل عدد به IP
decimal_to_ip() {
    local dec="$1"
    local a=$((dec / 256**3 % 256))
    local b=$((dec / 256**2 % 256))
    local c=$((dec / 256 % 256))
    local d=$((dec % 256))
    echo "$a.$b.$c.$d"
}

# تابع اندازه‌گیری تاخیر (Latency)
measure_latency() {
    local ip=$1
    local latency=$(ping -c 1 -W 1 "$ip" | grep 'time=' | awk -F'time=' '{ print $2 }' | cut -d' ' -f1)
    if [ -z "$latency" ]; then
        latency="N/A"
    fi
    printf "%s %s\n" "$ip" "$latency"
}

# تابع نمایش پیشرفت
show_progress() {
    local current=$1
    local total=$2
    local percent=$(( 100 * current / total ))
    local progress=$(( current * 50 / total ))
    local green=$(( progress ))
    local red=$(( 50 - progress ))

    printf "\r["
    printf "\e[42m%${green}s\e[0m" | tr ' ' '='
    printf "\e[41m%${red}s\e[0m" | tr ' ' '='
    printf "] %d%%" "$percent"
}

# تابع ذخیره‌سازی داده‌ها به فرمت JSON
save_to_json() {
    local data="$1"
    local output_file="$2"
    echo "[" > "$output_file"
    first=true
    while IFS=, read -r latency ip; do
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$output_file"
        fi
        echo "    {\"IP\": \"$ip\", \"Latency(ms)\": $latency}" >> "$output_file"
    done <<< "$data"
    echo "]" >> "$output_file"
}

# آدرس URL اسکریپت ipscan.sh
URL="https://raw.githubusercontent.com/Kolandone/fastlyipscan/refs/heads/main/ipscan.sh"
SCRIPT_FILE="ipscan.sh"
OUTPUT_FILE="ip_data.json"

# دانلود اسکریپت ipscan.sh
echo "Downloading ipscan.sh script..."
curl -fsSl "$URL" -o "$SCRIPT_FILE"

# بررسی موفقیت دانلود
if [ ! -f "$SCRIPT_FILE" ]; then
    echo "Failed to download the script!"
    exit 1
fi

# اجرای اسکریپت ipscan.sh و دریافت خروجی آن
echo "Running ipscan.sh script..."
OUTPUT=$(bash "$SCRIPT_FILE")

# بررسی موفقیت اجرای اسکریپت
if [ $? -ne 0 ]; then
    echo "Error executing the script!"
    exit 1
fi

# استخراج IP و Latency از خروجی
echo "Extracting IP and Latency from the output..."
IP_DATA=()
while IFS= read -r line; do
    if [[ "$line" =~ ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)\ +([0-9]+(\.[0-9]+)?) ]]; then
        IP="${BASH_REMATCH[1]}"
        LATENCY="${BASH_REMATCH[2]}"
        IP_DATA+=("$LATENCY,$IP")
    fi
done <<< "$OUTPUT"

# بررسی وجود داده‌ها
if [ ${#IP_DATA[@]} -eq 0 ]; then
    echo "No valid IP and Latency data found!"
    exit 1
fi

# مرتب‌سازی داده‌ها بر اساس Latency (کمترین به بیشترین)
echo "Sorting IP data by Latency..."
SORTED_DATA=$(for entry in "${IP_DATA[@]}"; do echo "$entry"; done | sort -t, -k1,1n)

# ذخیره داده‌ها به فایل JSON
echo "Saving sorted data to $OUTPUT_FILE..."
save_to_json "$SORTED_DATA" "$OUTPUT_FILE"

# نمایش داده‌ها به فرمت JSON
echo "Sorted IP data saved to $OUTPUT_FILE"
cat "$OUTPUT_FILE"

# حذف اسکریپت ipscan.sh پس از اتمام
rm "$SCRIPT_FILE"
