#!/bin/bash

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
# استفاده از regex برای استخراج داده‌ها
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

# ساخت فایل JSON
echo "Saving data to JSON..."
echo "[" > "$OUTPUT_FILE"
first=true
while IFS=, read -r latency ip; do
    if [ "$first" = true ]; then
        first=false
    else
        echo "," >> "$OUTPUT_FILE"
    fi
    echo "    {\"IP\": \"$ip\", \"Latency(ms)\": $latency}" >> "$OUTPUT_FILE"
done <<< "$SORTED_DATA"
echo "]" >> "$OUTPUT_FILE"

# نمایش فایل JSON
echo "Sorted IP data saved to $OUTPUT_FILE"
cat "$OUTPUT_FILE"

# حذف اسکریپت ipscan.sh پس از اتمام
rm "$SCRIPT_FILE"

