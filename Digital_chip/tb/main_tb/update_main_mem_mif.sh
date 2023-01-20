#!/usr/bin/bash

################################################################
### Create non-interleaved MIFs ################################

# Addr 0x00000
cat Pointwise_expand_v20.data   | ./txt2bin.py > Mem01.mp

# Addr 0x08000
cat boot_ram.txt                | ./txt2bin.py > Mem23.mp

# Addr 0x10000
cat pw_data_pec_1_64x32x32.data | ./txt2bin.py | split -b 16k - -d Mem47
mv Mem4700 Mem45.mp
mv Mem4701 Mem67.mp

# Addr 0x20000
cat CM_params.data              | ./txt2bin.py > Mem89.mp

# Addr 0x28000
cat CM_kernels_pwe_u8.data      | ./txt2bin.py > Mem1011.mp

# Addr 0x30000
cat CM_bias_pwe_s16.data        | ./txt2bin.py > Mem1213.mp

################################################################
### Create .coe files from mp files ############################
./main_mem_mp2coe.py Mem01.mp   Mem01.coe
./main_mem_mp2coe.py Mem23.mp   Mem23.coe
./main_mem_mp2coe.py Mem45.mp   Mem45.coe
./main_mem_mp2coe.py Mem67.mp   Mem67.coe
./main_mem_mp2coe.py Mem89.mp   Mem89.coe
./main_mem_mp2coe.py Mem1011.mp Mem1011.coe
./main_mem_mp2coe.py Mem1213.mp Mem1213.coe

cp Mem01.coe   ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p0/main_mem_p0.coe
cp Mem23.coe   ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p1/main_mem_p1.coe
cp Mem45.coe   ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p2/main_mem_p2.coe
cp Mem67.coe   ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p3/main_mem_p3.coe
cp Mem89.coe   ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p4/main_mem_p4.coe
cp Mem1011.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p5/main_mem_p5.coe
cp Mem1213.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p6/main_mem_p6.coe

#
echo Please regeneratate MIF files main_mem_p0-6 in Vivado, then press [ENTER]
read

################################################################
### Interleave each dual-mem block into two block sized MIF ####
cat ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p0/main_mem_p0.mif | ./interleave_file.py main_mem_p0_
cat ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p1/main_mem_p1.mif | ./interleave_file.py main_mem_p1_
cat ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p2/main_mem_p2.mif | ./interleave_file.py main_mem_p2_
cat ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p3/main_mem_p3.mif | ./interleave_file.py main_mem_p3_
cat ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p4/main_mem_p4.mif | ./interleave_file.py main_mem_p4_
cat ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p5/main_mem_p5.mif | ./interleave_file.py main_mem_p5_
cat ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p6/main_mem_p6.mif | ./interleave_file.py main_mem_p6_

################################################################
### Make mp files from interleaved MIFs ########################

cat main_mem_p0_0.mif | ./mif2bin.py > main_mem_p0.mp
cat main_mem_p0_1.mif | ./mif2bin.py > main_mem_p1.mp
cat main_mem_p1_0.mif | ./mif2bin.py > main_mem_p2.mp
cat main_mem_p1_1.mif | ./mif2bin.py > main_mem_p3.mp
cat main_mem_p2_0.mif | ./mif2bin.py > main_mem_p4.mp
cat main_mem_p2_1.mif | ./mif2bin.py > main_mem_p5.mp
cat main_mem_p3_0.mif | ./mif2bin.py > main_mem_p6.mp
cat main_mem_p3_1.mif | ./mif2bin.py > main_mem_p7.mp
cat main_mem_p4_0.mif | ./mif2bin.py > main_mem_p8.mp
cat main_mem_p4_1.mif | ./mif2bin.py > main_mem_p9.mp
cat main_mem_p5_0.mif | ./mif2bin.py > main_mem_p10.mp
cat main_mem_p5_1.mif | ./mif2bin.py > main_mem_p11.mp
cat main_mem_p6_0.mif | ./mif2bin.py > main_mem_p12.mp
cat main_mem_p6_1.mif | ./mif2bin.py > main_mem_p13.mp

################################################################
### Make mp files from interleaved MIFs ########################
./mp2coe.py main_mem_p0.mp  ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p0/main_mem_p0.coe
./mp2coe.py main_mem_p1.mp  ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p1/main_mem_p1.coe
./mp2coe.py main_mem_p2.mp  ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p2/main_mem_p2.coe
./mp2coe.py main_mem_p3.mp  ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p3/main_mem_p3.coe
./mp2coe.py main_mem_p4.mp  ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p4/main_mem_p4.coe
./mp2coe.py main_mem_p5.mp  ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p5/main_mem_p5.coe
./mp2coe.py main_mem_p6.mp  ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p6/main_mem_p6.coe
./mp2coe.py main_mem_p7.mp  ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p7/main_mem_p7.coe
./mp2coe.py main_mem_p8.mp  ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p8/main_mem_p8.coe
./mp2coe.py main_mem_p9.mp  ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p9/main_mem_p9.coe
./mp2coe.py main_mem_p10.mp ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p10/main_mem_p10.coe
./mp2coe.py main_mem_p11.mp ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p11/main_mem_p11.coe
./mp2coe.py main_mem_p12.mp ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p12/main_mem_p12.coe
./mp2coe.py main_mem_p13.mp ; mv out.coe ../../../fpga_synth/gpp/gpp.srcs/sources_1/ip/main_mem_p13/main_mem_p13.coe

echo Please regeneratate MIF files for ALL main_mem_pX in Vivado, then press [ENTER]
read

################################################################
### Copy all MIF files to maintb, for sim ######################
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p0/main_mem_p0.mif   ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p1/main_mem_p1.mif   ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p2/main_mem_p2.mif   ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p3/main_mem_p3.mif   ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p4/main_mem_p4.mif   ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p5/main_mem_p5.mif   ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p6/main_mem_p6.mif   ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p7/main_mem_p7.mif   ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p8/main_mem_p8.mif   ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p9/main_mem_p9.mif   ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p10/main_mem_p10.mif ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p11/main_mem_p11.mif ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p12/main_mem_p12.mif ../../sim/vivado/maintb/
cp ../../../fpga_synth/gpp/gpp.gen/sources_1/ip/main_mem_p13/main_mem_p13.mif ../../sim/vivado/maintb/
