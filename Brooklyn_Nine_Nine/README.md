# Brooklyn Nine Nine THM

IP=`10.10.75.6`

Ports:
```
21 ftp
22 ssh
80 http
880 ?
10616 ?
```

Found a note in the FTP server:
Amy -> Jake: Weak password -> angry holt

hydra jake for his password
login as jake
run `sudo -l` 
He can run sudo -l on less which can give us root access
get the root flag
go to home directory for holt and there is the user flag
