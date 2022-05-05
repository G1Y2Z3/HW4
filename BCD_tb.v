`timescale 1ns/1ps
module BCD_tb;
reg clk;
reg rst_syn;
reg load;
reg [3:0]data;
wire [7:0]seg_out;
wire [3:0]Q_out;

BCD BCD_tb(clk, load, rst_syn, data, Q_out, seg_out);

initial begin
    clk = 1;
    rst_syn = 1;
    load = 1;
    data = 4'b1000;
end

always #50 clk = ~clk;

initial #100 load = 1'b0;
initial #200 load = 1'b1;
initial #300 load = 1'b0;
initial #700 rst_syn = 1'b0;
initial #800 rst_syn = 1'b1;
initial #2000 $finish;

initial begin
    $dumpfile("BCD.vcd");
    $dumpvars(0, BCD_tb);
end
endmodule