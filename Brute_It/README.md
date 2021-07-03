# Brute it TryHackMe CTF

IP=`10.10.116.1`

Ports:
```
22 ssh
80 http
```
Found an `/admin/` directory with a comment in the HTML for `john` that the username to login with is `admin`

Used hydra to brute force the password

`hydra -l admin -P ~/wordlists/passwords/rockyou.txt $IP http-post-form "/admin/:user=^USER^&pass=^PASS^:Username or password invalid"`

Got the id_rsa key for john but it has a passphrase on it

Used john to crack it and we now have access to the machine

Grabbed the user flag and checked john's sudo permissions

We can sudo /bin/cat as root... 

Sudo the root flag but there is one more question: what is root's password.

Using the sudo cat again on the shadow file and copying that into a new file followed by uploading it to my machine to crack with john.

Cracking the shadow file reveals root's password and the room is complete!
