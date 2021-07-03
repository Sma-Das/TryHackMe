# Overpass TryHackMe CTF

IP=`10.10.225.57`

Ports:
```
22 ssh
80 http
```

Used gobuster to enumerate some directories on the website
Found a promising directory:
```
/admin/
```
At first I tried some basic SQL injection but then I checked the script of the login code with was **not** obfuscated and noticed it used cookies to validate the user.
I put an empty cookie to see if it would reflect between the server and myself but the simple presence of the cookie validated me

In the admin site, there's a blatant private ssh key for james
attempting to login to with the key but it has a passphrase on it

used ssh2john.py to convert the rsa key into a hash for Jtr

cracked the passphrase to be `james13`

Found the user flag:
`thm{65c1aaf000506e56996822c6281e6bf7}`

Also found a weird note in his home directory, saying his password is in a rot47 ciper somewhere
The file was `.overpass`:`,LQ?2>6QiQ$JDE6>Q[QA2DDQiQD2J5C2H?=J:?8A:4EFC6QN.`
deciphered: `[{"name":"System","pass":"saydrawnlyingpicture"}]`

But we have no sudo access

The trickiest part of this was getting sudo access
Running linpeas showed crontab was curling something as root so I tried to exploit that

first I tried moving curl but had permission denied then I checked online for a hint

I saw that you can modify /etc/hosts which I changed to redirect to me
/etc/hosts is basically a DNS resolver locally 

I then gained a root reverse shell and I got the root flag!
`thm{7f336f8c359dbac18d54fdd64ea753bb}`
