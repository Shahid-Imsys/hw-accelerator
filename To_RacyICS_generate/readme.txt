To create a delivery of files to RacyICS first.

Go to directory
/hw-accelerator/Digital_chip/sim/vivado/maintb

run command:
make -n > ../../../../To_RacyICS_generate/makefile_file_list.txt

go back to To_RacyICS_generate directory.

Diff makefile_file_list.txt with previous delivery to see if compile_ordet.txt have to be updated

run command

./to_racyICS_copy


