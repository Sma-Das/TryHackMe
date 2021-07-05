# [Break out of the Cage](https://tryhackme.com/room/breakoutthecage1) TryHackMe Room

![Nicolas Cage](https://tryhackme-images.s3.amazonaws.com/room-icons/29ef13afaef5de5b8f1a27653f9d7a2d.jpeg)

IP=`10.10.103.237`

Ports
```
nmap -sV -sC -v $IP -oN initial.nmap
nmap -p- -T4 -v $IP -oN all_ports.nmap

21 ftp
22 ssh
80 http
```
Checking the ftp server first; and anonymous login is enabled with a file named `dad_tasks` given. It looks like some sort of cipher matieral which I first decoded with base 64 into what appeared to be rot13 but it did not translate to anything meaningful. I tried other rotations until I decided that it may be vignere.

I used this [vignere solving tool](https://www.boxentriq.com/code-breaking/vigenere-cipher) to generate a set of viable keys, after adjusting my settings to a max key length of 15 and a iteration cycle of 120, I got a key `namelesstwo`. Using that in my [CyberChef Recipe](https://gchq.github.io/CyberChef) gave me the decoded note and password

Enumerating the website now with gobuster reveals very many _interesting_ directories
```
/images/
/html/
/scripts/
/contracts/
/auditions/
```
Starting from auditions, I checked the mp3 file given and noticed a strange part in the middle where it probably has some encoded information. Throwing that into a spectogram analyser in Audacity shows me that it is the passphrase for the vignere cipher solved earlier.

After roaming around the website searching for clues, I decided to login as weston into the machine using the password decoded earlier.
Checking his `sudo` permissions, we have access to a `wall` binary which I try exploit via path manipulation to no avail.
I then check which other users are on the machine, `cage` is one of them but I cannot view his home directory.
I then search for his files on the machine which I can also view
```
find / -user cage -type f 2>/dev/null
```

Using this I then discover the python file sending wall messages using a quotes library.

I notice that a random line from the file is executed without filtering it. I use this to create a reverse shell as I have write permissions to the quotes file.

Now that I am logged in as _nicholas cage_ himself, I read through his emails, as there is not user flag file.
Within the emails are the first flag and a strange cipher. I suspect its vigenere like the prior ones but I quickly check it through rot-ciphers, which it is not.
I first tried to decrypt the cipher like before, where I got lucky, but it did not work. So I read over the email again and I was debating between two words as the key. `"Cage"` or `"Face"`. I tried `"Cage"` first and while it was mostly gibberish, it did have the word face recognisable in it...
Using `"Face"` as the cipher worked and gave me root access

PS: Prior to this, I did try normal PrivEsc with linpeas etc but it did not work

In the root folder, we have more emails... and the root's flag!

Complete!

I actually enjoyed the meme-themed room more than I expected to. High recommended
