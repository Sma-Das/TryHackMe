# Year of The Rabbit TryHackMe

IP=`10.10.23.204`

Ports:
```
21 ftp
22 ssh
80 http
```

Found a secret directory with a hint in "Never gonna give you up"

Watching the video, there is a message embedded in it which burps and says we're in the wrong place. This is probably a clue to use Burpsuite.

Running burpsuite and going to the page again in intercept mode, it is noticed that there is some hidden directory.

Going to that directory reveals a picture which I download and run a few tools on.

binwalk shows nothing
stegsolve and steg-unhide show nothing
running exiftool on the image reveals that it has trailing data
So I run it through strings and it reveals the ftp credentials to use and a bunch of passwords I must also use.

Using those I login into the ftp server and get a file named "Eli's creds" which has a bunch of strange symbols like the brainfuck language. Executing the brainfuck gives eli's ssh credentials

Logging into ssh, there is a message from root to Gwendoline that gwen must check "out leet s3cr3t hiding place" where a message is located

Using the find command to search for the name we find  folder with Gwen's credentials in them and are able to log into Gwen's account

Once logging into Gwen's account I accessed her home directory and checked sudo perms. Gwen was able to sudo vim as everyone except root, but I checked for a gtfobin for sudo and gained root access

Rooted
