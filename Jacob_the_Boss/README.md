# Jacob the Boss CTF [TryHackMe](https://tryhackme.com/room/jacobtheboss)

---

![](https://tryhackme-images.s3.amazonaws.com/room-icons/065e4dc344a4c5fc9155dd4ae9eca52b.jpeg)

---

```bash
export IP=10.10.93.83
```

---

## Enumeration

```bash
nmap -sC -sV -A -v -oN nmap/initial.log $IP
```

```
# Nmap 7.91 scan initiated Mon Aug  2 13:35:54 2021 as: nmap -vvv -p 22,80,111,1090,1098,1099,3306,3873,4444,4445,4446,4457,4712,4713,8009,8080,8083,13101,41513,43583 -sC -sV -v -A -oN nmap/initial.log 10.10.93.83
Nmap scan report for jacobtheboss.box (10.10.93.83)
Host is up, received syn-ack (0.14s latency).
Scanned at 2021-08-02 13:35:55 +04 for 192s

PORT      STATE SERVICE      REASON  VERSION
22/tcp    open  ssh          syn-ack OpenSSH 7.4 (protocol 2.0)
| ssh-hostkey:
|   2048 82:ca:13:6e:d9:63:c0:5f:4a:23:a5:a5:a5:10:3c:7f (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOLOk6ktnJtucoDmXmBrc4H4gGe5Cybdy3jh1VZg+CYg+sZbYXzGi2/JO45cRqYd2NFIq7l+oTsjFgh76qAayKMU4D3+gKaC+U2VL93nCU1SywzvZLLc8MEy7mTHflOm4kZCmycgtJO4tfUhuH64yEP+lv3ENFeH5jgyJcGABF/p44MMSwnvpaLMfOuEGuEhKMPA4c+XAiS3J+sErUbpx6ragGGJAKTpww+arDy11slMsyJgjN6GUjlR0y+P0E4/NsrNHe86GKXJ1G4bfKEdKOPeTZ+wZMNFDCVNLPHLWUBIgWNQHIgRcXiBvPAvIrrt8gV/+td9C74Bsj0VqEEJnP
|   256 a4:6e:d2:5d:0d:36:2e:73:2f:1d:52:9c:e5:8a:7b:04 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNUtPCeXKNaq6WZlT3PxbZbQmka1bb5I+yBRhUb5tzmf2GEmdDOk6R7MSUlEtzGzQ4GjAWFZG3q7ZcBahg8ur8A=
|   256 6f:54:a6:5e:ba:5b:ad:cc:87:ee:d3:a8:d5:e0:aa:2a (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJI3bQUWzwhk0iJYl+gGn09NgvRLtN4vJ4DG6SrE7/Hb
80/tcp    open  http         syn-ack Apache httpd 2.4.6 ((CentOS) PHP/7.3.20)
| http-methods:
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Apache/2.4.6 (CentOS) PHP/7.3.20
|_http-title: My first blog
111/tcp   open  rpcbind      syn-ack 2-4 (RPC #100000)
| rpcinfo:
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|_  100000  3,4          111/udp6  rpcbind
1090/tcp  open  java-rmi     syn-ack Java RMI
|_rmi-dumpregistry: ERROR: Script execution failed (use -d to debug)
1098/tcp  open  java-rmi     syn-ack Java RMI
1099/tcp  open  java-object  syn-ack Java Object Serialization
| fingerprint-strings:
|   NULL:
|     java.rmi.MarshalledObject|
|     hash[
|     locBytest
|     objBytesq
|     xp'w]
|     http://jacobtheboss.box:8083/q
|     org.jnp.server.NamingServer_Stub
|     java.rmi.server.RemoteStub
|     java.rmi.server.RemoteObject
|     xpw;
|     UnicastRef2
|_    jacobtheboss.box
3306/tcp  open  mysql        syn-ack MariaDB (unauthorized)
3873/tcp  open  java-object  syn-ack Java Object Serialization
4444/tcp  open  java-rmi     syn-ack Java RMI
4445/tcp  open  java-object  syn-ack Java Object Serialization
4446/tcp  open  java-object  syn-ack Java Object Serialization
4457/tcp  open  tandem-print syn-ack Sharp printer tandem printing
4712/tcp  open  msdtc        syn-ack Microsoft Distributed Transaction Coordinator (error)
4713/tcp  open  pulseaudio?  syn-ack
| fingerprint-strings:
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, Help, JavaRMI, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NCP, NULL, NotesRPC, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServer, TerminalServerCookie, WMSRequest, X11Probe, afp, giop, ms-sql-s, oracle-tns:
|_    a229
8009/tcp  open  ajp13        syn-ack Apache Jserv (Protocol v1.3)
| ajp-methods:
|   Supported methods: GET HEAD POST PUT DELETE TRACE OPTIONS
|   Potentially risky methods: PUT DELETE TRACE
|_  See https://nmap.org/nsedoc/scripts/ajp-methods.html
8080/tcp  open  http         syn-ack Apache Tomcat/Coyote JSP engine 1.1
|_http-favicon: Unknown favicon MD5: 799F70B71314A7508326D1D2F68F7519
| http-methods:
|   Supported Methods: GET HEAD POST PUT DELETE TRACE OPTIONS
|_  Potentially risky methods: PUT DELETE TRACE
|_http-server-header: Apache-Coyote/1.1
|_http-title: Welcome to JBoss&trade;
8083/tcp  open  http         syn-ack JBoss service httpd
|_http-title: Site doesn't have a title (text/html).
13101/tcp open  unknown      syn-ack
41513/tcp open  unknown      syn-ack
43583/tcp open  java-rmi     syn-ack Java RMI
5 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at https://nmap.org/cgi-bin/submit.cgi?new-service :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port1099-TCP:V=7.91%I=7%D=8/2%Time=6107BC7C%P=x86_64-apple-darwin18.7.0
SF:%r(NULL,16F,"\xac\xed\0\x05sr\0\x19java\.rmi\.MarshalledObject\|\xbd\x1
SF:e\x97\xedc\xfc>\x02\0\x03I\0\x04hash\[\0\x08locBytest\0\x02\[B\[\0\x08o
SF:bjBytesq\0~\0\x01xp'w\]\x91ur\0\x02\[B\xac\xf3\x17\xf8\x06\x08T\xe0\x02
SF:\0\0xp\0\0\0\.\xac\xed\0\x05t\0\x1dhttp://jacobtheboss\.box:8083/q\0~\0
SF:\0q\0~\0\0uq\0~\0\x03\0\0\0\xc7\xac\xed\0\x05sr\0\x20org\.jnp\.server\.
SF:NamingServer_Stub\0\0\0\0\0\0\0\x02\x02\0\0xr\0\x1ajava\.rmi\.server\.R
SF:emoteStub\xe9\xfe\xdc\xc9\x8b\xe1e\x1a\x02\0\0xr\0\x1cjava\.rmi\.server
SF:\.RemoteObject\xd3a\xb4\x91\x0ca3\x1e\x03\0\0xpw;\0\x0bUnicastRef2\0\0\
SF:x10jacobtheboss\.box\0\0\x04J\0\0\0\0\0\0\0\0\x9ez\xba>\0\0\x01{\x062B\
SF:x02\x80\0\0x");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port3873-TCP:V=7.91%I=7%D=8/2%Time=6107BC82%P=x86_64-apple-darwin18.7.0
SF:%r(NULL,4,"\xac\xed\0\x05");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port4445-TCP:V=7.91%I=7%D=8/2%Time=6107BC82%P=x86_64-apple-darwin18.7.0
SF:%r(NULL,4,"\xac\xed\0\x05");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port4446-TCP:V=7.91%I=7%D=8/2%Time=6107BC82%P=x86_64-apple-darwin18.7.0
SF:%r(NULL,4,"\xac\xed\0\x05");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port4713-TCP:V=7.91%I=7%D=8/2%Time=6107BC82%P=x86_64-apple-darwin18.7.0
SF:%r(NULL,5,"a229\n")%r(GenericLines,5,"a229\n")%r(GetRequest,5,"a229\n")
SF:%r(HTTPOptions,5,"a229\n")%r(RTSPRequest,5,"a229\n")%r(RPCCheck,5,"a229
SF:\n")%r(DNSVersionBindReqTCP,5,"a229\n")%r(DNSStatusRequestTCP,5,"a229\n
SF:")%r(Help,5,"a229\n")%r(SSLSessionReq,5,"a229\n")%r(TerminalServerCooki
SF:e,5,"a229\n")%r(TLSSessionReq,5,"a229\n")%r(Kerberos,5,"a229\n")%r(SMBP
SF:rogNeg,5,"a229\n")%r(X11Probe,5,"a229\n")%r(FourOhFourRequest,5,"a229\n
SF:")%r(LPDString,5,"a229\n")%r(LDAPSearchReq,5,"a229\n")%r(LDAPBindReq,5,
SF:"a229\n")%r(SIPOptions,5,"a229\n")%r(LANDesk-RC,5,"a229\n")%r(TerminalS
SF:erver,5,"a229\n")%r(NCP,5,"a229\n")%r(NotesRPC,5,"a229\n")%r(JavaRMI,5,
SF:"a229\n")%r(WMSRequest,5,"a229\n")%r(oracle-tns,5,"a229\n")%r(ms-sql-s,
SF:5,"a229\n")%r(afp,5,"a229\n")%r(giop,5,"a229\n");
Service Info: OS: Windows; Device: printer; CPE: cpe:/o:microsoft:windows

Read data files from: /usr/local/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Mon Aug  2 13:39:07 2021 -- 1 IP address (1 host up) scanned in 192.92 seconds
```

So, you may be inclined to believe that this is a Windows box considering the amount of ports open, however, notice port `8080`. It's a Tomcat/Coyote JSP engine.

Let's have a peek at that.

(Keep in mind that as my `nmap` scan was going on - manually explored the site and also launched gobuster - those however, will not be needed here)

Looking at http://jacobtheboss.box:8080 we notice a few things. First this is obviously a Tomcat server but it also has JBoss on it. This will probably be our vunerability.

---

### Finding Vunerabilities

Googling around for some JBoss v.5 exploits (the console while checking the site gives information about its version etc...) I stumble onto this [Github Repo](https://github.com/joaomatosf/jexboss) with an automated tool for exploiting JBoss.

```bash
git clone https://github.com/joaomatosf/jexboss.git
pip2 install -r requires.txt
python2 jexboss.py -u http://$IP:8080
```

The tool finds multiple RCE vunerabilities and even has the ability to generate a reverse shell for us!

---

### PrivEsc

I open a netcat listener and gain a reverse shell using the tool above!

Now that I have it, I see that I am logged on as a user `jacob`. I grab the user flag and launch `linpeas`.

It first picks up on something named `/srv/java/bin/java` as a severe binary exploitation vunerability as well as the Linux kernel version being `3.10`. But before I launch myself down that avenue, I notice a strange SUID bit set: `pingsys`. Linpeas does not recognise it so it is probably an external command that may be poorly configured.

Googling for an exploit for `pingsys` (and guessing I'm on the right track as every 3 result is related to the room) I find a super simple one [here](https://security.stackexchange.com/questions/196577/privilege-escalation-c-functions-setuid0-with-system-not-working-in-linux).

```bash
pingsys 'localhost; /bin/sh'
```

And we're now root! Pretty easy actually and I'm super thankful I didn't stumble down the rabbit hole of java exploitation from the first vunerability we found!

---

### Final Thoughts

A room which seems intimidating at first but it is super simple if you follow your head and don't fall down the multiple rabbit holes!

Recommended!

---

![](https://w7.pngwing.com/pngs/769/261/png-transparent-jboss-enterprise-application-platform-wildfly-red-hat-java-java-server-pages-hat-text-logo.png)
