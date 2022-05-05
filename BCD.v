module seg (BCD, seg);
input [3:0] BCD;
output [7:0] seg;
reg [7:0]  seg;
always @(BCD) begin
    case (BCD)
        4'h0: seg = 8'hc0;
        4'h1: seg = 8'hf9;
        4'h2: seg = 8'ha4;
        4'h3: seg = 8'hb0;
        4'h4: seg = 8'h99;
        4'h5: seg = 8'h92;
        4'h6: seg = 8'h82;
        4'h7: seg = 8'hf8;
        4'h8: seg = 8'h80;
        4'h9: seg = 8'h90;
        default: seg = 8'hff; 
    endcase
end
endmodule

module dff (clk, D, Din, load, Q4);
input clk, D, Din, load;
output reg Q4;
always@ (posedge clk)
    if (load) 
        Q4 = Din;
    else 
        Q4 = D;
endmodule

module BCD(clk, load, rst_syn, data, Q_out, seg_out);
reg Q0, Q1, Q2, Q3;
input clk, rst_syn, load;
input [3:0] data;
output [3:0] Q_out;
output [7:0]seg_out;
wire [3:0] Q_out;
wire [7:0] seg_out;

seg BCD_seg(Q_out, seg_out);
dff BCD_dff0(clk, Q0, Q0, load, Q_out[0]);
dff BCD_dff1(clk, Q1, Q1, load, Q_out[1]);
dff BCD_dff2(clk, Q2, Q2, load, Q_out[2]);
dff BCD_dff3(clk, Q3, Q3, load, Q_out[3]);

always@ (posedge clk)
begin
    if (!rst_syn)begin
        Q0=0;
        Q1=0;
        Q2=0;
        Q3=0;
    end

    else if (load)begin
        Q0<=data[0];
        Q1<=data[1];
        Q2<=data[2];
        Q3<=data[3];
    end
    
    else
        if (Q0==1 && Q3==1)begin
            Q0<=0;
            Q3<=0;   
        end
        
        else begin
            Q0 <= ~Q0;
            Q1 <= (Q0 & ~Q1) | (Q1 & ~Q0);
            Q2 <= (Q2 & ~Q1) | (Q2 & ~Q0) | (~Q2 & Q1 & Q0);
            Q3 <= Q3 | (Q0 & Q1 & Q2);
        end

    end
endmodule


