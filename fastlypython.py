import subprocess
import re
import json
import os
import requests
import time

# آدرس URL که اسکریپت bash از آن بارگیری می‌شود
url = "https://raw.githubusercontent.com/Kolandone/fastlyipscan/refs/heads/main/ipscan.sh"
script_filename = "ipscan.sh"

# مرحله 1: دانلود اسکریپت bash به فایل
def download_bash_script(url, filename):
    response = requests.get(url)
    if response.status_code == 200:
        with open(filename, 'w') as f:
            f.write(response.text)
        print(f"Script downloaded successfully as {filename}")
    else:
        print(f"Failed to download script. Status code: {response.status_code}")
        return False
    return True

# مرحله 2: اجرای اسکریپت bash از فایل (در Termux با استفاده از bash)
def execute_bash_script(filename):
    try:
        # اجرای اسکریپت Bash
        print(f"Executing bash script: {filename}")
        subprocess.check_call(['bash', filename])
        print(f"Script executed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error executing script: {e}")
        return False
    return True

# مرحله 3: پردازش داده‌ها برای استخراج IP و Latency
def extract_ips_and_latencies(output):
    # استفاده از regex برای استخراج IP و Latency از خروجی
    data = re.findall(r'(\d+\.\d+\.\d+\.\d+)\s+(\d+(\.\d+)?)', output)
    return [{"IP": ip, "Latency(ms)": float(latency)} for ip, latency, _ in data]

# مرحله 4: ذخیره داده‌ها به فرمت JSON
def save_to_json(data, filename="ip_data.json"):
    with open(filename, 'w') as json_file:
        json.dump(data, json_file, indent=4)

# مرحله 5: استخراج داده‌ها از فایل خروجی
def get_script_output(filename):
    with open(filename, 'r') as file:
        return file.read()

# مرحله 6: اجرای اسکریپت به صورت مرحله به مرحله و مدیریت منابع
def run_script_with_management():
    # دانلود اسکریپت
    if download_bash_script(url, script_filename):
        # اجرای اسکریپت با تاخیر بین مراحل برای جلوگیری از استفاده زیاد از منابع
        if execute_bash_script(script_filename):
            # خواندن خروجی اسکریپت از فایل (در صورتی که اسکریپت چیزی در فایل ذخیره کرده باشد)
            try:
                bash_output = get_script_output(script_filename)
                
                # استخراج داده‌ها از خروجی
                ip_data = extract_ips_and_latencies(bash_output)
                
                # مرتب‌سازی داده‌ها
                sorted_ip_data = sorted(ip_data, key=lambda x: x["Latency(ms)"])
                
                # ذخیره‌سازی داده‌ها به فایل JSON
                save_to_json(sorted_ip_data)
                
                # نمایش داده‌های مرتب‌شده
                print("Sorted IP data (by Latency):")
                print(json.dumps(sorted_ip_data, indent=4))
                
                # حذف فایل اسکریپت پس از اتمام
                os.remove(script_filename)
            except Exception as e:
                print(f"Error processing script output: {e}")
        else:
            print("Failed to execute bash script.")
    else:
        print("Failed to download bash script.")

if __name__ == "__main__":
    run_script_with_management()
