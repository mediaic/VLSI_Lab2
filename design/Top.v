`include "Counter.v"
`include "Sorter.v"

module TopVerilog(
	input  clk,
	input  rst,
	input                  pixel_valid,
	output                 pixel_ready,
	input  [3*IMG_BIT-1:0] pixel_data,
	input  [TAG_BIT-1:0]   pixel_tag,
	output                o_valid,
	output [TYPE_BIT-1:0] o_type,
	output [TAG_BIT -1:0] o_tag
);
	// TODO
endmodule
