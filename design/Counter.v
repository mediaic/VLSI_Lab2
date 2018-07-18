module CounterVerilog(
	input  clk,
	input  rst,
	input                  pixel_valid,
	output                 pixel_ready,
	input  [3*IMG_BIT-1:0] pixel_data,
	input  [TAG_BIT-1:0]   pixel_tag,
	output                   img_valid,
	output [TAG_BIT    -1:0] img_tag, // tag, must bypass
	output [TYPE_BIT   -1:0] img_type, // type, must bypass
	output [CL_IMG_SIZE-1:0] img_num, // #pixels
	output [SUM_BIT    -1:0] img_sum // pixels sum
);
endmodule
