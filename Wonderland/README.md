# Wonderland Medium CTF TryHackMe

IP=`10.10.148.157`

Ports:
```
22 ssh
80 http
```

gobuster
```
http://10.10.148.157/r/ -> keep going
    - http://10.10.148.157/r/a/b/b/i/t (I like this poem)
http://10.10.148.157/poem/ -> jabberwocky
```

In the last sub-directory of `rabbit` there is a code embedded and hidden in the html
`alice:HowDothTheLittleCrocodileImproveHisShiningTail`

This allows us to ssh into the box
`ssh alice@$IP` which the password from above

The user flag was in /root/user.txt
`thm{"Curiouser and curiouser!"}`

We can sudo the python file as rabbit
`sudo -u rabbit /usr/bin/python3 /home/alice/walrus...py`
And notice it has a stray random import which we can exploit using python's path

We now spawn a shell as rabbit
In his home directory we notice a binary file which uses a relative command rather than an absolute path we can again exploit

We can now login as hatter since he was the owner of the file
He has a file password.txt which is his password
`WhyIsARavenLikeAWritingDesk?`

Then I reached a bit of a dead end so I checked online for help
Found that I can use `getcap -r` to check for which files have their `cap_setuid`

perl showed that it had its `cap_setuid` set and I could gtfobin out of that
Got the root flag: `thm{Twinkle, twinkle, little bat! How I wonder what you’re at!}`
