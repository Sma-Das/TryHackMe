# LazyAdmin TryHackMe Room

IP=`10.10.28.249`

Ports:
```
22 ssh
80 http
```

Running gobuster reveals a directory:
```
/content/
```
And accessing that directory reveals that this is a sweetrice website v1.5.1.
I then ran gobuster again on the `/content/` directory and it reveals more directories, therefore I suspect `/content/` is a replacement for the base `/sweetrice/` 

New directories
```
/images/
/js/
/inc/
/as/
/_themes/
/attachment/
```
Accessing `inc` and `as` were the most interesting as `inc` was the main hold for the website's files. It revealed a database backup that had credentials and a password hash for a suspected admin. 
`manager:42f749ade7f9e195bf475f37a44cafcb`
Cracking this password revealed it to be a weak one
`Password123`

Going into the `as` directory, it is evident that it is an admin login. I attempted a few basic SQL and Cookie Injection techniques and noted that a cookie injection was possible but I was not sure how to pursue this. 
Instead I used the credentials from above to login into the admin site

I created and uploaded a reverse shell using the upload feature in the website and used my listener

Once I had box access I got the user flag

I noticed a strange backup.pl file which I saw referenced a shell script in /etc/ which I was able to modify 
Running `sudo -l` also showed that I was able to sudo that script which made spawning a priviledged shell simple
