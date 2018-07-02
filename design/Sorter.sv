`include "define.sv"
import MyDefine::*;

module Sorter(
	input  logic clk,
	input  logic rst,
	input  logic                   img_valid,
	input  logic [TAG_BIT    -1:0] img_tag, // tag, must bypass
	input  logic [TYPE_BIT   -1:0] img_type, // type, must bypass
	input  logic [CL_IMG_SIZE-1:0] img_num, // #pixels
	input  logic [SUM_BIT    -1:0] img_sum, // pixels sum
	output logic                o_valid,
	output logic [TAG_BIT -1:0] o_tag,
	output logic [TYPE_BIT-1:0] o_type
);
	// functional model !!!
	real avg[N_IMG];
	bit [TAG_BIT -1:0] ta[N_IMG];
	bit [TYPE_BIT-1:0] ty[N_IMG];
	real tmp_avg;
	bit [TAG_BIT -1:0] tmp_ta;
	bit [TYPE_BIT-1:0] tmp_ty;
	initial begin
		o_valid = 0;
		@(negedge rst)
		@(posedge rst)
		// input data
		for (int i = 0; i < N_IMG; i++) begin
			forever begin
				@(posedge clk)
				if (img_valid) begin
					ta[i] = img_tag;
					ty[i] = img_type;
					avg[i] = $itor(img_sum) / $itor(img_num);
					break;
				end
			end
		end
		// wait 10 cycles
		repeat (10) @(posedge clk)
		// insertion sort
		for (int i = 1; i < N_IMG; i++) begin
			for (int j = i-1; j >= 0; j--) begin
				if ((ty[j+1] < ty[j]) || (ty[j+1] == ty[j]) && (avg[j+1] < avg[j])) begin
					tmp_avg = avg[j];
					tmp_ta = ta[j];
					tmp_ty = ty[j];
					avg[j] = avg[j+1];
					ta[j] = ta[j+1];
					ty[j] = ty[j+1];
					avg[j+1] = tmp_avg;
					ta[j+1] = tmp_ta;
					ty[j+1] = tmp_ty;
				end else begin
					break;
				end
			end
		end
		// output answer
		o_valid <= 1;
		for (int i = 0; i < N_IMG; i++) begin
			o_tag <= ta[i];
			o_type <= ty[i];
			@(posedge clk);
		end
		o_valid <= 0;
	end
`ifdef OLD_VERILOG_SYNTAX
	// If you are happier with this, alright
	SorterVerilog u_old_style_verilog_wrapper(
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
