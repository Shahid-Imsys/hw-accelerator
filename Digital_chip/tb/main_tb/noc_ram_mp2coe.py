#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse

class mp2coe:
    def __init__(self):
        self.maxLines   = 16384
        self.bitPerWord = 8

        self.mpFileName = 'boot_ram.mp'
        self.mpData = []

        self.coeFileName = 'main_mem.coe'

        self.read_mp()
        self.write_coe()

    def read_mp(self):
        try:
            with open(self.mpFileName, "rb") as file:
                data = file.read( -1 )
                bits = 0

                if not data:
                    print( " * Could not read " + self.mpFileName )
                    return

                for _byte in data:
                    for i in range(8):
                        if _byte & (0x80 >> i):
                            self.mpData.append( '1' )
                        else:
                            self.mpData.append( '0' )

                        bits = bits + 1

                print("Read " + str( bits ) + " bits from " + self.mpFileName )

        except IOError:
            print(" * Error reading " + self.mpFileName )
            return


    def write_coe(self):
        try:
            with open(self.coeFileName, "w") as file:
                file.write("memory_initialization_radix=2;\n")
                file.write("memory_initialization_vector=")

                done  = False
                lines = 0
                n     = 0
                word  = [0 for i in range(16)] # 16 byte word as array of bytes
                
                for b in self.mpData:
                    if (n % self.bitPerWord) == 0:
                        # Start new byte
                        byte = ''

                    if b == '0':
                        byte += '0'
                    else:
                        byte += '1'
                    
                    if (n % self.bitPerWord) == (self.bitPerWord - 1):
                        index = (n >> 3) % 16
                        word[ index ] = byte
                        if index == 15:
                            for i in reversed( range(16) ):
                                if lines < self.maxLines:
                                    file.write( word[i] )
                                    file.write( ' ' )
                                    lines += 1
                                else:
                                    print("Max memory length reached!")
                    n += 1

                file.write(";\n")
                print("Wrote " + str( lines - 1 ) + " lines to " + self.coeFileName )

        except IOError:
            print(" * Error writing " + self.coeFileName )

if __name__ == "__main__":

    #parser = argparse.ArgumentParser()
    #parser.add_argument('--infile', help='infile ', action='store', type=str, default='')
    #arg = parser.parse_args()

    main = mp2coe()
