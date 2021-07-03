# Madness CTF TryHackMe
## This was easily the trickiest but most enjoyable room I have done yet

IP=`10.10.69.115`

Ports:
```
22 ftp
80 http
```

The picture in the header of the task was really weird and I decided to save it and possibly reverse search it for a hint

Found a weird picture that I repaired the headers of on the default page.
It gave the address of the secret directory

Accessing this directory, it prompted me to find the secret between 0-99. At first I thought it was an extra directory but upon googling for a hint, I realised I have to _query_ the current page as opposed to another directory.

I quickly wrote a simple bash script for that upon doing a quick test to see how the query response looked like.

```bash
for i in {0..99}; do
    echo "?secret=$i" >> secrets.txt
done
gobuster dir -u http://$IP/<<secret dir>>/ -w secrets.txt -t 64 | grep -vE "407|408"
```

I found the secret to be `73` which gave me a strange string

I tried several ROT ciphers and base decodes to no avail. Googled for a hint and found out it has something to do with the pictures. So I went back to the picture that gave me the secret directory and decided to use the `secret` as a password, which worked!

I got another strange set of letters! But this time running a ROT cipher decode revealed it to be a rot13 cipher with an english word!
But I need a password and the room was clear from the onset _that it did not need to be brute-forced_ so I decided to take inspiration from the previous task and check what other images I had to work with...The room's picture

Decoding the room's picture gave me the ssh password!

I now had access to the box and its first flag.
The tricky part was the root flag. 
I first checked sudo permissions for the user, nothing
Then I decided to run linpeas and check for any glaring errors.
Nothing extremely obvious, so I decided to poke my head into some SUID exploitation by googling an exploit for each SUID enabled binary. I managed to find one for screen v4.5 that worked and gave me root access.

With root access, I got the final flag!

Complete
