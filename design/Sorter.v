module SorterVerilog(
	input  clk,
	input  rst,
	input                    img_valid,
	input  [TAG_BIT    -1:0] img_tag, // tag, must bypass
	input  [TYPE_BIT   -1:0] img_type, // type, must bypass
	input  [CL_IMG_SIZE-1:0] img_num, // #pixels
	input  [SUM_BIT    -1:0] img_sum, // pixels sum
	output                o_valid,
	output [TAG_BIT -1:0] o_tag,
	output [TYPE_BIT-1:0] o_type
);
	// TODO
endmodule
