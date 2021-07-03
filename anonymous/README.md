# anonymous CTF room on TryHackMe

IP=`10.10.190.158`

Ports:
```
21 ftp
22 ssh
139 smbd
445 smbd 
```

Logged onto the ftp server anonymously and replaced the crontab executable file with a reverse shell file

Once I had the reverse shell I got the user flag and loaded linpeas onto the system 

Using linpeas I noticed that env was running as root meaning that I could use it to exploit root and I did so
