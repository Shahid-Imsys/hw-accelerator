#!/usr/bin/env python3

# ln -s ../../../Processors/IM3000E/src/ext/pe_test/Sequence_test/Sequence_Test.data
# cat Sequence_Test.data | ./word2byte.py > Sequence_Test.mif

import sys
import os

bitArray  = []
byteArray = []
wordArray = []

def chunks(lst, n):
    """Yield successive n-sized chunks from lst."""
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

for line in sys.stdin:
    for ch in line:
        bitArray.append
        if ch == '0' or ch == '1':
            bitArray.append( ch )

# print("Collected {} bit from stdin".format(len(bitArray)))

str = ""

for byte in chunks(bitArray, 8):
    byteArray.append( str.join(byte) )

# print("Collected {} bytes from bit stream".format(len(byteArray)))

for word in chunks(byteArray, 16):
    for byte in word[::-1]:
        wordArray.append( byte )

# print("Collected {} words from bit stream".format(len(wordArray)))

for word in wordArray:
    print( word )
