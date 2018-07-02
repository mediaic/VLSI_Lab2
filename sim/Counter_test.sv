`timescale 1ns/1ns
`include "Counter.sv"

module Counter_test;

logic clk, rst;
`Pos(rst_out, rst)
`PosIf(ck_ev, clk, rst)
`WithFinish

always #1 clk = ~clk;
initial begin
	$fsdbDumpfile("Counter.fsdb");
	$fsdbDumpvars(0, Counter_test, "+mda");
	clk = 0;
	rst = 1;
	#1 $NicotbInit();
	#11 rst = 0;
	#10 rst = 1;
	#500000 $display("Timeout");
	$NicotbFinal();
	$finish;
end

Counter dut(clk, rst);

endmodule
