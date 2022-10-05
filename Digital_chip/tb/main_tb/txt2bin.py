#!/usr/bin/env python3

# cat noc_code.txt | ./txt2bin.py > noc_code.bin

import sys
import os

bitArray  = []
byteArray = []

for line in sys.stdin:
    for ch in line:
        bit = ord(ch) - ord('0')
        if bit == 0 or bit == 1:
            bitArray.append( bit )

# print("Collected {} bit from stdin".format(len(bitArray)))

i = 0
byte = 0

for bit in bitArray:
    byte |= bit << (7 - i)
    i = (i + 1) % 8
    if i == 0:
        byteArray.append( byte )
        byte = 0

# print("Collected {} byte from bit stream".format(len(byteArray)))

if i != 0:
    sys.stderr.write("Final bit index ended up {}\n".format(i))

os.write(1, bytes( byteArray ))
