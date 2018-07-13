`include "define.sv"
import MyDefine::*;
`ifdef OLD_VERILOG_STYLE
`include "Counter.v"
`endif

module Counter(
	input  logic clk,
	input  logic rst,
	input  logic               pixel_valid,
	output logic               pixel_ready,
	input  logic [IMG_BIT-1:0] pixel_data [3],
	input  logic [TAG_BIT-1:0] pixel_tag,
	output logic                   img_valid,
	output logic [TAG_BIT    -1:0] img_tag, // tag, must bypass
	output logic [TYPE_BIT   -1:0] img_type, // type, must bypass
	output logic [CL_IMG_SIZE-1:0] img_num, // #pixels
	output logic [SUM_BIT    -1:0] img_sum // pixels sum
);
	// functional model !!!
	integer pxsum [3];
	integer pxcnt [3];
	integer pxtag;
	integer cur;
	bit rg, rb, gb;

	initial begin
		pixel_ready = 1;
		img_valid = 0;
		@(negedge rst)
		@(posedge rst)
		// input data
		for (int i = 0; i < N_IMG; i++) begin
			pxsum[0] = 0;
			pxsum[1] = 0;
			pxsum[2] = 0;
			pxcnt[0] = 0;
			pxcnt[1] = 0;
			pxcnt[2] = 0;
			for (int j = 0; j < IMG_SIZE; j++) begin
				forever begin
					@(posedge clk)
					if (pixel_valid) begin
						rg = pixel_data[0] >= pixel_data[1];
						rb = pixel_data[0] >= pixel_data[2];
						gb = pixel_data[1] >= pixel_data[2];
						if (rg && rb) begin
							cur = 0;
						end else if (!rg && gb) begin
							cur = 1;
						end else begin
							cur = 2;
						end
						pxsum[cur] += pixel_data[cur];
						pxcnt[cur] += 1;
						if (j == 0) begin
							pxtag = pixel_tag;
						end
						break;
					end
				end
			end
			// enable output
			pixel_ready <= 0;
			img_valid <= 1;
			rg = pxcnt[0] >= pxcnt[1];
			rb = pxcnt[0] >= pxcnt[2];
			gb = pxcnt[1] >= pxcnt[2];
			if (rg && rb) begin
				cur = 0;
			end else if (!rg && gb) begin
				cur = 1;
			end else begin
				cur = 2;
			end
			img_tag <= pxtag;
			img_type <= cur;
			img_num <= pxcnt[cur];
			img_sum <= pxsum[cur];
			// disable output
			@(posedge clk)
			pixel_ready <= 1;
			img_valid <= 0;
		end
	end
`ifdef OLD_VERILOG_SYNTAX
	// If you are happier with this, alright
	CounterVerilog u_old_style_verilog_wrapper(
		.clk(clk),
		.rst(rst),
		.pixel_valid(pixel_valid),
		.pixel_ready(pixel_ready),
		.pixel_data({pixel_data[2], pixel_data[1], pixel_data[0]}),
		.pixel_tag(pixel_tag),
		.img_valid(img_valid),
		.img_tag(img_tag),
		.img_type(img_type),
		.img_num(img_num),
		.img_sum(img_sum)
	);
`endif
endmodule
