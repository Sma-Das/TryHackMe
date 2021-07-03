# Beginner LFI on TryHackMe

IP=`10.10.6.199`

Ports:
```
22 ssh
80 http
```

Reading through the LFI attack documentation on the website it introduces how to do an LFI attack, which I proceed to use as they have presented.

I first get /etc/passwd which reveals the username `falconfeast` and their password. I decided to also check if /etc/shadow was also available. If it is, that means I have root priviledge and ssh'ing into the machine will not be needed

It revealed /etc/shadow with both the passwords for root and falconfeast as a hash available.

Then I checked falconfeast's home directory for the user flag (got it!)

And then I checked root's home directory for the root flag which I also managed to get!

Rooted!
