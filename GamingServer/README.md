# [Gaming Server](https://tryhackme.com/room/gamingserver) TryHackMe Room
![Gaming Server Icon](https://tryhackme-images.s3.amazonaws.com/room-icons/80d16a6756c805903806f7ecbdd80f6d.jpeg)

`export IP=10.10.138.11`

Ports:
```
22 ssh
80 http
```

Checking the website, the source code for the home page makes mention of a person `john` who needs to clean-up the lorem-ipsum on it.

Running gobuster on it:
```
gobuster dir -t 64 -u $IP -w ~/wordlists/website_dir/directory-list-2.3-medium.txt -x .html,.php,.txt,.jpg,.png -o dir_med.txt
```
```
/uploads/
/robots.txt
/secret
```
Uploads contains some sort of wordlist for a potential password (hydra maybe?)
robots.txt simply points to uploads
And secret contains an ssh private key of the presumed user we found earlier

```
hydra -l john -P pot_passwords.txt -t 64 ssh://$IP
``` 
Results in no found passwords, so instead I focus on the ssh key. Trying to login as john results in it requesting a passphrase. 
I fire up ssh2john.py 

```
ssh2john.py id_rsa_john > ssh_john_hash
```
Followed by using the previously given password pot to crack the hash
```
john -wordlist=pot_passwords.txt ssh_john_hash
```
Which results in cracking the ssh passphrase!

Logging into the machine, we immediately get the user flag
Hunting through the machine with linpeas, I notice that we are part of the lxd/lxc group for which there is a known exploit.

Copying and running the commands as a simple script that I got from [this website](https://book.hacktricks.xyz/linux-unix/privilege-escalation/interesting-groups-linux-pe/lxd-privilege-escalation)

We now have root access and can search for the flag!
