#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import binascii
import argparse

class mp2coe:
    def __init__(self):
        self.bitPerWord = 28

        self.mpFileName = 'test.mp'
        self.mpData = []

        self.coeFileName = 'boot_memory.coe'
        self.coeData =  []

        self.read_mp()
        self.write_coe()

    def read_mp(self):
        try:
            with open(self.mpFileName, "rb") as file:
                while True:
                    bits = 0
                    data = []
                    byte = []
                    while bits < self.bitPerWord:
                        byte = file.read( 1 )
                        if byte:
                            data.append( byte )
                            bits += 8
                        else:
                            break

                    if not data:
                        return

                    for _byte in data:
                        # self.mpData.append( _byte.hex() )

                        str = ''
                        for i in range(8):
                            if int.from_bytes(_byte, 'big') & (0x80 >> i):
                                str += '1'
                            else:
                                str += '0'
                        self.mpData.append( str )

        except IOError:
            print(" * Error reading " + self.mpFileName )
            return


    def write_coe(self):
        try:
            with open(self.coeFileName, "w") as file:
                file.write("memory_initialization_radix=2;\n")
                file.write("memory_initialization_vector=")

                lines = 0
                n     = 0
                for b in self.mpData:
                    if (n % self.bitPerWord) == 0:
                        if lines > 0:
                            file.write('\n')
                        lines = lines + 1
                    file.write(b)
                    n = n + 1

                file.write(";\n")

        except IOError:
            print(" * Error writing " + self.coeFileName )

if __name__ == "__main__":

    #parser = argparse.ArgumentParser()
    #parser.add_argument('--infile', help='infile ', action='store', type=str, default='')
    #arg = parser.parse_args()

    main = mp2coe()
