# Relevant Penetration Challenge on TryHackMe

IP=`10.10.227.93`

Notes:
There are multiple ways to root 

---

Started with an nmap Version and Script control scan
Discovered Ports:
```
* 80 http
* 135 msrpc
* 139 netbios-ssn
* 445 microsoft-ds
* 3389 ssl/ms-wbt-server
* 49663
* 49667
* 49669
```
Decided to access the smbclient via the Kali Box provided by TryHackMe
smbclient on macOS is extremely poor
`smbclient -L $IP`
Found an anonymously accessible directory `nt4wrksv`
`smbclient \\\\$IP\\nt4wrksv`
Within the directory there was a password.txt file available
```
Qm9iIC0gIVBAJCRXMHJEITEyMw==
QmlsbCAtIEp1dzRubmFNNG40MjA2OTY5NjkhJCQk
```
The first is a base64 that can be decoded to:
```
Bob - !P@$$W0rD!123
```
The second is also a base64 encoded that can be decoded to:
```
Bill - Juw4nnaM4n420696969!$$$
```
