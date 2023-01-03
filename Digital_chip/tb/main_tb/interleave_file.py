#!/usr/bin/env python3

# cat ../../sim/vivado/maintb/main_mem.mif | ./interleave_file.py main_mem_p
# cat ../../sim/vivado/maintb/test_mem.mif | ./interleave_file.py test_mem_p
# mv main_mem_p0.mif ../../sim/vivado/maintb/
# mv main_mem_p1.mif ../../sim/vivado/maintb/
# mv test_mem_p0.mif ../../sim/vivado/maintb/
# mv test_mem_p1.mif ../../sim/vivado/maintb/

import sys
import os

def write_file_bytes(filename, data):
    with open(filename, "wt") as file:
        for s in data:
            file.write( s )
        print("Wrote " + str( len( data ) ) + " bytes to " + filename )

bitArray = []
rowArray = []

prefix = 'interleaved_part'
suffix = '.mif'
byte   = ''

if len( sys.argv ) > 1:
    prefix = sys.argv[1]

for line in sys.stdin:
    for ch in line:
        n = ord( ch )
        if n != 10 and n != 13:
            bitArray.append( ch )

for b, bit in enumerate( bitArray ):
    if (b % 8) == 0:
        byte = ''
    byte = byte + bit

    if (b % 8) == 7:
        byte = byte + chr( 10 )
        rowArray.append( byte )
        # cByte = (cByte + 1) % 8

file0 = prefix + '0' + suffix
file1 = prefix + '1' + suffix

data0 = write_file_bytes( file0, rowArray[0::2] )
data1 = write_file_bytes( file1, rowArray[1::2] )
