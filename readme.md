### README for Latency Measurement Script

---

### **Project Title**: Fastly Ip Scanner & IP Latency Measurement & Sorting Script  
**Version**: 1.0  
**Created By**: KayH GNG  
**Original Concept**: Based on Kolandone's Project  

---

### **English Version**

#### **Overview**

This script is a customized and enhanced version of the original Kolandone project. The purpose of this script is to measure the latency of randomly selected IP addresses from a set of CIDR blocks, sort the latency in increasing order, and output the results in both human-readable format and JSON format.

#### **Key Features and Customization:**

- **Sorting Latency**: The latency results are now sorted in ascending order (from lowest to highest latency).
- **JSON Output**: The script generates a `latency_data.json` file containing the IP addresses and their corresponding latencies. This structured data format makes it easier to analyze and store the results.
- **Improved Output**: The output is cleaner and more structured, with each IP and its latency presented in a clear format.

#### **How It Works:**

1. The script generates random IP addresses from the selected CIDR blocks.
2. It pings each IP address to measure its latency.
3. The latencies are sorted from lowest to highest.
4. A `latency_data.json` file is generated in the directory where the script is run, containing the IP addresses, their latencies, and developer information.
5. The results are printed to the terminal in a human-readable format, showing the IP addresses and latencies.

#### **How to Use:**

1. **Install Dependencies**: The script automatically checks for and installs necessary packages such as `ping`, `awk`, `grep`, `cut`, `curl`, and `bc`.
2. **Run the Script**: Simply execute the script in your terminal.
3. **View the Results**: The script will display the IP addresses and their latencies in a clean format in the terminal. Additionally, the script will generate a `latency_data.json` file that contains the structured data.

## How we can use in termux?
```
bash <(curl -fsSl https://raw.githubusercontent.com/kayhgng/fastly/refs/heads/main/fastlyscanipjson.bash)
```

## چجوری در ترموکس ازش استفاده کنیم؟

```
bash <(curl -fsSl https://raw.githubusercontent.com/kayhgng/fastly/refs/heads/main/fastlyscanipjson.bash)
```



#### **Example Output in Terminal:**

```
Displaying top IPs with valid latency...
104.156.90.24 -----------> 322 ms
151.101.18.39 -----------> 196 ms
172.111.79.134 -----------> 174 ms
151.101.0.29 -----------> 114 ms

Based on Kolandone Project with Customized and better Edited by KayH GNG
```

#### **Example Output in JSON (`latency_data.json`):**

```json
[
  {"ip": "104.156.90.24", "latency": "322 ms"},
  {"ip": "151.101.18.39", "latency": "196 ms"},
  {"ip": "172.111.79.134", "latency": "174 ms"},
  {"ip": "151.101.0.29", "latency": "114 ms"},
  {"developer": "Alikay_h"}
]
```

---

### **فارسی**

#### **مروری بر پروژه**

این اسکریپت نسخه‌ی شخصی‌سازی شده و بهبود یافته‌ای از پروژه‌ی اصلی Kolandone است. هدف این اسکریپت اندازه‌گیری تاخیر (Latency) آدرس‌های IP به‌طور تصادفی از مجموعه‌ای از بلوک‌های CIDR انتخاب‌شده، مرتب‌سازی آن‌ها بر اساس تاخیر از کم به زیاد، و خروجی گرفتن هم به‌صورت قابل خواندن توسط انسان و هم به‌صورت فرمت JSON است.

#### **ویژگی‌ها و تغییرات:**

- **مرتب‌سازی تاخیر**: نتایج تاخیر حالا بر اساس تاخیر کم به زیاد مرتب می‌شوند.
- **خروجی JSON**: این اسکریپت یک فایل `latency_data.json` ایجاد می‌کند که شامل آدرس‌های IP و تاخیر‌های مربوط به آن‌ها است. این فرمت داده ساختاریافته باعث می‌شود که نتایج به راحتی تحلیل و ذخیره شوند.
- **خروجی بهبودیافته**: خروجی به‌طور کلی تمیزتر و ساختاریافته‌تر است، به‌طوری که هر IP و تاخیر آن به‌صورت واضح نمایش داده می‌شود.

#### **چطور کار می‌کند:**

1. اسکریپت آدرس‌های IP تصادفی از بلوک‌های CIDR انتخاب‌شده ایجاد می‌کند.
2. به هر آدرس IP پینگ می‌زند تا تاخیر آن را اندازه‌گیری کند.
3. تاخیر‌ها از کم به زیاد مرتب می‌شوند.
4. یک فایل `latency_data.json` در دایرکتوری که اسکریپت اجرا شده است ساخته می‌شود که شامل آدرس‌های IP، تاخیر آن‌ها، و اطلاعات توسعه‌دهنده است.
5. نتایج به‌صورت خوانا در ترمینال نمایش داده می‌شود.

#### **نحوه استفاده:**

1. **نصب وابستگی‌ها**: اسکریپت به‌طور خودکار بررسی می‌کند که پکیج‌های مورد نیاز مانند `ping`، `awk`، `grep`، `cut`، `curl` و `bc` نصب شده‌اند یا خیر.
2. **اجرای اسکریپت**: تنها کافیست اسکریپت را در ترمینال خود اجرا کنید.
3. **مشاهده نتایج**: اسکریپت آدرس‌های IP و تاخیرهای مربوطه را در قالبی مرتب و خوانا در ترمینال نمایش می‌دهد. علاوه بر این، اسکریپت یک فایل `latency_data.json` ایجاد می‌کند که شامل داده‌های ساختار یافته است.

#### **مثال خروجی در ترمینال:**

```
Displaying top IPs with valid latency...
104.156.90.24 -----------> 322 ms
151.101.18.39 -----------> 196 ms
172.111.79.134 -----------> 174 ms
151.101.0.29 -----------> 114 ms

Based on Kolandone Project with Customized and better Edited by KayH GNG
```

#### **مثال خروجی در JSON (`latency_data.json`):**

```json
[
  {"ip": "104.156.90.24", "latency": "322 ms"},
  {"ip": "151.101.18.39", "latency": "196 ms"},
  {"ip": "172.111.79.134", "latency": "174 ms"},
  {"ip": "151.101.0.29", "latency": "114 ms"},
  {"developer": "Alikay_h"}
]
```

---

### **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

