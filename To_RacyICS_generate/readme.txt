To create a delivery of files to RacyICS first.

-----------------------------------------------------------------------------------------------------
Create a tag in git
-----------------------------------------------------------------------------------------------------
git tag -a To_RacyICS_v0.4

After you have created the tag you have to commit it and push it to the main repository.

-----------------------------------------------------------------------------------------------------
Update compile_order
----------------------------------------------------------------------------------------------------- 
go to directory
/hw-accelerator/etc/

run command:
source proj_setup vivado

Go to directory
/hw-accelerator/Digital_chip/sim/vivado/maintb

run command:
make -n > ../../../../To_RacyICS_generate/makefile_file_list.txt

go back to To_RacyICS_generate directory.

Diff makefile_file_list.txt with previous delivery to see if compile_ordet.txt have to be updated


-----------------------------------------------------------------------------------------------------
Create archive to send to RacyICS
-----------------------------------------------------------------------------------------------------

run command

./to_racyICS_copy

zip the created archive

zip -r To_RacyICS_v0.4.zip To_RacyICS


