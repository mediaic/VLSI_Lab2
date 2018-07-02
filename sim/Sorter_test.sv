`timescale 1ns/1ns
`include "Sorter.sv"

module Sorter_test;

logic clk, rst;
`Pos(rst_out, rst)
`PosIf(ck_ev, clk, rst)
`WithFinish

always #1 clk = ~clk;
initial begin
	$fsdbDumpfile("Sorter.fsdb");
	$fsdbDumpvars(0, Sorter_test, "+mda");
	clk = 0;
	rst = 1;
	#1 $NicotbInit();
	#11 rst = 0;
	#10 rst = 1;
	#10000 $display("Timeout");
	$NicotbFinal();
	$finish;
end

Sorter dut(clk, rst);

endmodule
