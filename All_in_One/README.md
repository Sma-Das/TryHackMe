# [All in One](https://tryhackme.com/room/allinonemj)

![All in one](All_in_One.png)

IP=`10.10.125.191`

Ports:
```
21 ftp --> Anonymous Login enabled
22 ssh
80 http
```

No files found on the ftp server

gobuster:
```
/wordpress/ --> wordpress related directories
/hackathon/
```

Exploring the wordpress site quickly gave me some valuable information. I first learnt about the user `elyana` and upon trying to log into their account, it said that the `'The password for elyana is incorrect'` so I decided to fire up a hydra script with which to attack it with

In the meantime I decided to check out the other directory I discovered, `/hackathon/` and noticed it was a simple page with `'I hate vinegar'` the only available information. I then checked the source code of the page and discovered a cipher right at the bottom for what was presumably a vingere cipher with the key below the cipher. 

Logging onto the admin site, I explore it a bit before realising that I can simply add a php file to create a reverse shell.

Now that I have machine access I decide to explore and try find the user flag. Unfortunately it is not readable by `www-data`
But we are given a hint that her login is somewhere on this machine...

`find / -user elyana -type f 2>/dev/null`

Simple little command to find files owned by `elyana` and filter out any permission restrictions or if the file does not actually exist. I love bash one liners 

I find `/etc/mysql/conf.d/private.txt` which has her password! Similar to her previous in fact...

Now that I have the user flag, my attention shifts to finding privesc methods. Before I do so, I run two simple commands to check for capabilities and SUID/SGID permissions. 

Capabilities: `getcap / -r 2>/dev/null`

SUID/SGID: `find / -type f -a \( -perm -u+s -o -perm -g+s \) -exec ls -l {} \; 2>/dev/null`

And lo and behold. There are so many easily exploitable root methods that I didn't even need to waste time finding elyana's password

`chmod`, `socat`, and `bash` all have their SUID's and SGID's enabled.

`/bin/bash -ip`

Got the root flag!

(Sidenote, both flags are base64 encoded!)

The box was advertised as having multiple ways to root or access it, therefore out of curiousity, I decided to google some writeups to see what others had done to get access to the box. I felt getting root access, was extremely easy to get but I struggled slightly with identifying potential doors after enumeration.

Other methods used LFI to view files from the box. I discovered this as well when enumerating the box as I was able to access `/etc/passwd` but I was not sure how to access sensitive information related to the box. One [writeup](https://i7m4d.medium.com/all-in-one-tryhackme-write-up-303eaa2caa8) used it to view the database passwords in the box. I had tried to create a reverse shell but failed unfortunately failed.

Other methods included exploiting another wp plugin (wpscan is a lovely resource for finding these).

Editing the template was done several ways. I overwrote the navigation php file, whereas others added their as a `404` page but I prefer mine ;)

Thanks for reading!
