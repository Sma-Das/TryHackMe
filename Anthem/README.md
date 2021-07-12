# Anthem CTF

---

![Room Logo](./.assets/logo.gif)

---

## Index
- [Enumeration](#enumeration)
- [Flag Hunting](#finding-those-flags)
- [Machine Access](#gaining-access-to-the-machine)
- [PrivEsc](#priviledge-escalation)
- [Final Thoughts](#final-thoughts)

---

```bash
$ export IP=10.10.109.175
```

---

### Enumeration

```bash
$ nmap -sC -sV -v $IP -oN nmap/initial.nmap
$ nmap -p- -T4 -v $IP -oN nmap/all_ports.nmap
$ gobuster dir -t 64 -u $IP -w ~/wordlists/website_dir/directory-list-2.3-medium.txt -x .php,.txt,.html,.jpg,.png -o gobuster/dir_med_init.txt
```

Ports:

```
80 http
3389 rdp
```

Interesting directories:
```
/robots.txt
/Authors
```

Going into `robots.txt` we notice some interesting and juicy information.

A potential password: `UmbracoIsTheBest!`
CMS (control management system): `umbraco`

We can also log into the umbraco center if needed now!

Manually exploring the website now, we notice some interesting facts. They have a domain name `Anthem.com` (you don't have to add this to your `hosts` file thankfully)

Trying to find the Administrator's name proved surprising tricky. I tried various googling methods (simultaneously avoiding other write-ups on my journey) but I finally found something that seemed valid.

When you google
```
Born on a Monday, Christened on Tuesday...
```
It shows that it is a reference to a DC character `Solomon Grundy`'s poem about his life.
He was

```poem
Born on a Monday,
Christened on Tuesday,
Married on Wednesday,
Took ill on Thursday,
Grew worse on Friday,
Died on Saturday,
Buried on Sunday.
That was the end…
```

As a DC fan, I loved this cheeky reference but I had to turn my attention _back_ to the machine now.
We had a name now and I had noticed earlier that another user `Jane Doe`'s email was `JD@anthem.com` which probably means that `Solomon Grundy`'s email was `SG@anthem.com`. Which it was!

---

### Finding those flags

To preface this, I didn't know about website crawlers until _after_ I had completed this room and checked other write-ups about how they had fared.
The way **_novice I_** went about was opening inspector, clicking every half-interesting link and searching for THM.
I knew I was looking for THM flags because I accidently found one earlier under the `Authors` directory when enumerating the website.

Flag 1 - Check your posts: `THM{***_***_****_****}`

Flag 2 - Just search THM: `THM{***_***}`

Flag 3 - Check who wrote it: `THM{***_***_***}`

Flag 4 - Check flag 1: `THM{*******_****}`

---

### Gaining access to the machine

This section really highlighted to me how accustomed I had become to Linux and how much I _despise_ using Windows, not to mention the sluggishness of the machine.

Using the credentials we got earlier, `SG@anthem.com` and the password from `robots.txt` we can now log into the machine with RDP. Since I am on MacOS I used Microsoft's [app](https://apps.apple.com/us/app/microsoft-remote-desktop/id1295203466?mt=12) on the App Store.

---

### Priviledge Escalation

Now that we have logged in, we can see the user flag on the desktop `THM{****_****}` and we can start looking for ways to escalate our priviledges

I opened up powershell since that had similarity to Bash that I felt somewhat comfortable ( :/ ) with.

I decided that since this is an easy box, there is probably some hidden folder and I was not in the mood to figure out how to get winpeas working.

Thankfully, starting from the root directory and using `ls -Force` reveals a hidden `backup` folder. Navigating into it and trying to view the file though indicated I didn't have permissions.
But I also knew I was something of an admin so I could probably force it to? Googling for answers I realised I could add the `Users` group to view the file (I really don't like Windows) and I now had a password `*********************` for the Administrator. I think?


But then, after a bit of googling I found that it was as easy as logging in with the username `Administrator`...

`su Administrator` didn't work... :/

Now that I had logged out of Solomon's account and into the "Administrator" account, I had the root flag on the desktop `THM{***_***_****}`! Thank god

---

### Final thoughts

Overall I enjoyed this machine and despite my Window's whining, it did make me realise that I really do have to dote more attention to properly learning Windows and its ins and outs.

And a huge plus side is that this was a lot more enjoyable (and less buggy) than the actual Anthem game ;)

Strongly recommened for beginers like myself

---

![Solomon Grundy](./.assets/solomon_grundy.png)
