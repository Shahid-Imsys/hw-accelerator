#!/usr/bin/env python3

# cat boot_ram.txt | ./txt2bin.py > boot_ram.mp

import sys
import os

bitArray  = []
byteArray = []
wordArray = []

for line in sys.stdin:
    for ch in line:
        bit = ord(ch) - ord('0')
        if bit == 0 or bit == 1:
            bitArray.append( bit )

# print("Collected {} bit from stdin".format(len(bitArray)))

i = 0
byte = 0
word = 0

for bit in bitArray:
    byte |= bit << (7 - i)
    i = (i + 1) % 8
    if i == 0:
        wordArray.append( byte )
        byte = 0
        word = (word + 1) % 16
        if word == 0:
            for w in wordArray[12:16]:
                byteArray.append( w )
            for w in wordArray[8:12]:
                byteArray.append( w )
            for w in wordArray[4:8]:
                byteArray.append( w )
            for w in wordArray[0:4]:
                byteArray.append( w )
            # Clear array
            wordArray.clear()

# print("Collected {} byte from bit stream".format(len(byteArray)))

if i != 0:
    sys.stderr.write("Final bit index ended up {}\n".format(i))

os.write(1, bytes( byteArray ))