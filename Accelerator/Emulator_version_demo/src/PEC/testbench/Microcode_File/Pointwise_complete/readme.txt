{
	"command": "LOAD_MP",
	"address": "0x0000",
	"path": "test_mp.ascii"
},
{
	"command": "LOAD_CM",
	"address": "0x1000",
	"path": "test_params.ascii"
},
{
	"command": "LOAD_CM",
	"address": "0x2000",
	"path": "test_k.ascii"
},
{
	"command": "LOAD_CM",
	"address": "0x3000",
	"path": "test_bias.ascii"
},
{
	"command": "LOAD_CM",
	"address": "0x4000",
	"path": "test_in_pec_1.ascii"
},
{
	"command": "EXECUTE",
},
{
	"command": "READ_CM",
	"address": "0x14000",
	"size": "294912",
	"path": "test_result_ascii"
},
{
	"command": "VERIFY",
	"file1": "test_result_ascii",
	"file2": "test_out_pec_1.ascii"
}