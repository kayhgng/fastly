#!/bin/bash

# دریافت داده‌ها از آدرس URL
response=$(curl -fsSl https://raw.githubusercontent.com/Kolandone/fastlyipscan/refs/head/main/ipscan.sh)

# استخراج آی‌پی‌ها و مقادیر Latency از پاسخ
ips_and_latencies=$(echo "$response" | grep -Eo '(\d+\.\d+\.\d+\.\d+)\s+([0-9]+(?:\.[0-9]+)?)' )

# مرتب کردن آی‌پی‌ها بر اساس Latency (عدد بعد از IP)
sorted_ips=$(echo "$ips_and_latencies" | sort -k2,2n)

# ساختاردهی داده‌ها برای فایل JSON
json_data="["
while IFS= read -r line; do
    ip=$(echo "$line" | awk '{print $1}')
    latency=$(echo "$line" | awk '{print $2}')
    json_data="$json_data{\"IP\": \"$ip\", \"Latency(ms)\": $latency},"
done <<< "$sorted_ips"

# حذف کاما اضافی در انتهای آخرین آیتم
json_data="${json_data%,}]"

# ذخیره کردن داده‌ها در فایل JSON
echo "$json_data" > ip_data.json

# نمایش فایل JSON
cat ip_data.json
