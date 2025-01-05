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

# مرحله 2: اجرای اسکریپت bash از فایل (در Termux با استفاده از bash)
def execute_bash_script(filename):
    try:
        # اجرای اسکریپت Bash
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

# اجرای مراحل مختلف
if __name__ == "__main__":
    # دانلود اسکریپت
    if download_bash_script(url, script_filename):
        # اجرای اسکریپت
        execute_bash_script(script_filename)

        # حذف فایل اسکریپت پس از اتمام
        os.remove(script_filename)
