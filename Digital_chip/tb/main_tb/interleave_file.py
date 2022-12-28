#!/usr/bin/env python3

# cat ../../sim/vivado/maintb/main_mem.mif | ./interleave_file.py mainmem_part
# cat ../../sim/vivado/maintb/test_mem.mif | ./interleave_file.py testmem_part

import sys
import os

def write_file_bytes(filename, data):
    with open(filename, "wb") as file:
        file.write( bytearray( data ) )
        print("Wrote " + str( len( data ) ) + " bytes to " + filename )

byteArray = []

prefix = 'interleaved_part'
suffix = '.mif'

if len( sys.argv ) > 1:
    prefix = sys.argv[1]

for line in sys.stdin:
    for ch in line:
        n = ord( ch )
        if (n != 13) and (n != 10 ):
            byteArray.append( n )

file0 = prefix + '0' + suffix
file1 = prefix + '1' + suffix

data0 = write_file_bytes( file0, byteArray[0::2] )
data1 = write_file_bytes( file1, byteArray[1::2] )
