import subprocess
import re
import json
import os
import requests

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

# مرحله 2: اجرای اسکریپت bash از فایل و گرفتن خروجی
def execute_bash_script(filename):
    try:
        # اجرای اسکریپت bash و گرفتن خروجی آن
        result = subprocess.check_output(['bash', filename], stderr=subprocess.STDOUT)
        return result.decode('utf-8')  # تبدیل خروجی به رشته
    except subprocess.CalledProcessError as e:
        print(f"Error executing script: {e}")
        return None

# مرحله 3: پردازش داده‌ها برای استخراج IP و Latency
def extract_ips_and_latencies(output):
    # استفاده از regex برای استخراج IP و Latency از خروجی
    data = re.findall(r'(\d+\.\d+\.\d+\.\d+)\s+(\d+(\.\d+)?)', output)
    return [{"IP": ip, "Latency(ms)": float(latency)} for ip, latency, _ in data]

# مرحله 4: ذخیره داده‌ها به فرمت JSON
def save_to_json(data, filename="ip_data.json"):
    with open(filename, 'w') as json_file:
        json.dump(data, json_file, indent=4)

# مرحله 5: اجرای اسکریپت و پردازش خروجی آن
def run_script_with_management():
    # دانلود اسکریپت
    if download_bash_script(url, script_filename):
        # اجرای اسکریپت و دریافت خروجی
        output = execute_bash_script(script_filename)
        if output:
            # استخراج IP و Latency
            ip_data = extract_ips_and_latencies(output)
            
            # مرتب‌سازی داده‌ها بر اساس Latency
            sorted_ip_data = sorted(ip_data, key=lambda x: x["Latency(ms)"])
            
            # ذخیره‌سازی داده‌ها به فایل JSON
            save_to_json(sorted_ip_data)
            
            # چاپ خروجی به کنسول
            print("Sorted IP data (by Latency):")
            print(json.dumps(sorted_ip_data, indent=4))
            
            # حذف فایل اسکریپت پس از اتمام
            os.remove(script_filename)
        else:
            print("Failed to get output from the bash script.")
    else:
        print("Failed to download bash script.")

if __name__ == "__main__":
    run_script_with_management()
