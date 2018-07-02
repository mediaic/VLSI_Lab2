`include "define.sv"
`ifdef OLD_VERILOG_SYNTAX
`include "Top.v"
`else
`include "Counter.sv"
`include "Sorter.sv"
`endif
import MyDefine::*;

module Top(
	input  logic clk,
	input  logic rst,
	input  logic               pixel_valid,
	output logic               pixel_ready,
	input  logic [IMG_BIT-1:0] pixel_data [3],
	input  logic [TAG_BIT-1:0] pixel_tag,
	output logic                o_valid,
	output logic [TYPE_BIT-1:0] o_type,
	output logic [TAG_BIT -1:0] o_tag
);
	// TODO
`ifdef OLD_VERILOG_SYNTAX
	// If you are happier with this, alright
	TopVerilog u_old_style_verilog_wrapper(
		.clk(clk),
		.rst(rst),
		.pixel_valid(pixel_valid),
		.pixel_ready(pixel_ready),
		.pixel_data({pixel_data[2], pixel_data[1], pixel_data[0]}),
		.pixel_tag(pixel_tag),
		.o_valid(o_valid),
		.o_type(o_type),
		.o_tag(o_tag)
	);
`endif
endmodule
