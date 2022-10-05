#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse

class mp2coe:
    def __init__(self):
        self.maxLines   = 256
        self.bitPerWord = 28

        self.mpFileName = 'boot_rom.mp'
        self.mpData = []

        self.coeFileName = 'boot_memoy.coe'

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
                        if (bits % 32) < 4:
                            pass
                        elif _byte & (0x80 >> i):
                            self.mpData.append( '1' )
                        else:
                            self.mpData.append( '0' )

                        bits = bits + 1

                print("Read " + str( bits ) + " bits")

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
                for b in self.mpData:
                    if (n % self.bitPerWord) == 0:
                        if lines > 0:
                            file.write('\n')
                        lines = lines + 1
                        if lines > self.maxLines:
                            done = True
                    if not done:
                        file.write(b)
                        n = n + 1
                    else:
                        break

                file.write(";\n")
                print("Wrote " + str( lines - 1 ) + " lines" )

        except IOError:
            print(" * Error writing " + self.coeFileName )

if __name__ == "__main__":

    #parser = argparse.ArgumentParser()
    #parser.add_argument('--infile', help='infile ', action='store', type=str, default='')
    #arg = parser.parse_args()

    main = mp2coe()
