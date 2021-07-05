# [Easy Peasy](https://tryhackme.com/room/easypeasyctf)

IP=`export IP=10.10.51.109`

Ports:
```
80 http
6498 ssh
65524 http
```

gobuster
Port 80
nginx server
```
/hidden/ --> picture.jpg
```

Port 65524
apache server

In the default page's source code, there are comments with a clue
```
ObsJmP173N2X6dOrAgEAL0Vu
```
Doing some analysis of this with cyberchef, I see that it is a base62 cipher which when decoded reveals a hidden directory [REDACTED]

In that directory we see a picture and in the source code there is a strange hash in it.
Throwing that hash into a hash analyser indicates that it may be multiple types of hashes - therefore I decided to use john to crack it as it is more versatile with hashes.

Cracking the hash reveals a password which I assumed correctly would be used to decode the image given as a steg file.

Decoding it gives us a username and a long string of binary said to be the password

`boring:iconvertedmypasswordtobinary`

I log on to the machine with ssh and grab the user flag
Once I do that, I check my sudo perms (none) and I grabbed linpeas to enumerate the system. I notice that there is a file owned by boring (me) that is run in the crontab as root. Meaning I can access root via that crontab.

Modifying the script and I gained root access! 

However, we are not quite done yet, as we have a few flags from previous questions to get.

Now that we have machine access, there is no need to enumerate the website with gobuster as we can directly view what directories are there.

The first is a robots.txt file which gives us a user agent to grab a flag from. This is revealed to be flag 3

Flag one was located in the html source code for a hidden directory inside the hidden directory

Then after looking at the user-agent they gave and running that through a hash analyser, I realised that it actually was a _hash_. Trying to 
