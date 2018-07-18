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
	logic                   img_valid;
	logic [TAG_BIT    -1:0] img_tag;
	logic [TYPE_BIT   -1:0] img_type;
	logic [CL_IMG_SIZE-1:0] img_num;
	logic [SUM_BIT    -1:0] img_sum;
	Counter u_counter(
		.clk(clk),
		.rst(rst),
		.pixel_valid(pixel_valid),
		.pixel_ready(pixel_ready),
		.pixel_data(pixel_data),
		.pixel_tag(pixel_tag),
		.img_valid(img_valid),
		.img_tag(img_tag),
		.img_type(img_type),
		.img_num(img_num),
		.img_sum(img_sum)
	);
	Sorter u_sorter(
		.clk(clk),
		.rst(rst),
		.img_valid(img_valid),
		.img_tag(img_tag),
		.img_type(img_type),
		.img_num(img_num),
		.img_sum(img_sum),
		.o_valid(o_valid),
		.o_tag(o_tag),
		.o_type(o_type)
	);
`endif
endmodule
