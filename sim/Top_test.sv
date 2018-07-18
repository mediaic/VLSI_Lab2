`ifdef SYN
`timescale 1ns/1ps
`else
`timescale 1ns/1ns
`endif
`include "Top.sv"

module Top_test;

logic clk, rst;
`Pos(rst_out, rst)
`ifdef SYN
	`PosIfDelayed(ck_ev, clk, rst, 1)
`else
`PosIf(ck_ev, clk, rst)
`endif
`WithFinish

always #5 clk = ~clk;
initial begin
	$fsdbDumpfile("Top.fsdb");
	$fsdbDumpvars(0, Top_test, "+mda");
	clk = 0;
	rst = 1;
	#1 $NicotbInit();
	#31 rst = 0;
	#30 rst = 1;
	#2500000 $display("Timeout");
	$NicotbFinal();
	$finish;
end

`ifdef SYN
TopWrap
`else
Top
`endif
dut(clk, rst);

endmodule
