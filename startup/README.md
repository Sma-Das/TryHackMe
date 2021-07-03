# startup ctf room on TryHackMe

IP=`10.10.96.185`

Ports:
```
21 ftp anon allowed
22 ssh
80 http
```
notice.txt on the webserver indicates a user by the name of `Maya`
There is also a jpg file which I am going to steg analyse

There was nothing in the steg file.

I then realised I can easily upload anything via the FTP server so I uploaded a simple reverse shell php file

Upload sshing into the I notice a strange file containing curious activity file which had the `lennie` user's password in plaintext

Upon logging onto the user I noticed a script run by root by crontab, I added code to the script to make a priviledged bash shell and gained root access
