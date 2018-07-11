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
`PosIf(ck_ev, clk, rst)
`else
`PosIfDelayed(ck_ev, clk, rst, 0.1)
`endif
`WithFinish

always #1 clk = ~clk;
initial begin
	$fsdbDumpfile("Top.fsdb");
	$fsdbDumpvars(0, Top_test, "+mda");
	clk = 0;
	rst = 1;
	#1 $NicotbInit();
	#11 rst = 0;
	#10 rst = 1;
	#500000 $display("Timeout");
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
