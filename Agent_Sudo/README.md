# Agent Sudo

IP=`10.10.20.177`

Ports:
```
21 ftp
22 ssh
80 http
```

Used `curl -A "C" -L $IP` to get the secret message

Brute-forced `chris` password with hydra: `crystal`
(Had ftp issues which were fixed by: `binary 200 Type set to I` while accessing the ftp server)
Got two files
`cutie.png` and `cute-alien.jpg`

Decided to binwalk both of them, cutie had a zip file embedded in it
cute-alien didn't so I decided to steg-unhide it

`binwalk -e cutie.png` worked but
`unzip 8702.zip` did not
I had to use another tool
`7za x 8702` to unzip it but it required a password
I converted the zip file into a hash for john using zip2john and cracked it, with the password:
`alien`
I then unzipped it and got a message with a curious message in the middle of it
`QXJlYTUx` which I used b64 to decode and got `Area51` from it

I then proceeded to analyse the jpg file. Attempts to unhide it were unsuccessful, I then tried the `Area51` as the password from earlier whcih was a success and I got the messaege for:
`james` that his password was `hackerrules!` from chris

Now I used this password to access the server from ssh server as james
Got the first user flag: `b03d975e8c92a7c04146cfa7a5a313c7`

Grabbed the jpg file also there and it was the `Roswell Alien Autopsy` incident

Running `sudo -l` shows me that james can run sudo as _anyone_ except root
`(ALL, !root) /bin/bash` 
So I googled an exploit for this and found `CE-2019-14287` which says to run: 
`sudo -u#-1 /bin/bash` which will work as the exploit

Then I got the root flag: `b53a02f55b57d4439e3341834d70c062`
And Agent R's name: `DesKel`

Completed!
