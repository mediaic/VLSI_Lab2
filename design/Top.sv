`include "define.sv"
import MyDefine::*;
`ifdef OLD_VERILOG_STYLE
`ifdef SYN
`include "Top_syn.v"
`else
`include "Counter.v"
`include "Sorter.v"
`include "Top.v"
`endif
`else
`include "Counter.sv"
`include "Sorter.sv"
`endif

module
`ifdef SYN
TopWrap
`else
Top
`endif
(
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
`ifdef OLD_VERILOG_STYLE
`ifdef SYN
	Top
`else
	TopVerilog
`endif
	u_old_style_verilog_wrapper(
		.clk(clk),
		.rst(rst),
		.pixel_valid(pixel_valid),
		.pixel_ready(pixel_ready),
`ifdef SYN
		.pixel_data({>>{pixel_data}}),
`else
		.pixel_data({pixel_data[2], pixel_data[1], pixel_data[0]}),
`endif
		.pixel_tag(pixel_tag),
		.o_valid(o_valid),
		.o_type(o_type),
		.o_tag(o_tag)
	);
`else
	// SystemVerilog version here
`endif
endmodule
