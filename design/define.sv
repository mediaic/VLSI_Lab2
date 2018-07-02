`ifndef __DEFINE_SV__
`define __DEFINE_SV__
package MyDefine;
	parameter N_IMG = 16;
	parameter IMG_SIZE = 120*80;
	parameter IMG_BIT = 8;
	parameter TAG_BIT = 5;
	parameter TYPE_BIT = 2;
	// derived
	parameter CL_N_IMG = $clog2(N_IMG);
	parameter CL_IMG_SIZE = $clog2(IMG_SIZE);
	parameter SUM_BIT = IMG_BIT+$clog2(IMG_SIZE);
endpackage
`endif
