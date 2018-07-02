`timescale 1ns/1ns
`include "Top.sv"

module Top_test;

logic clk, rst;
`Pos(rst_out, rst)
`PosIf(ck_ev, clk, rst)
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

Top dut(clk, rst);

endmodule
