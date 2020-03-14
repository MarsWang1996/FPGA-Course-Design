module Seg(clk,rst_n,in,out);

input clk,rst_n;
input [3:0] in;
output [6:0] out;

reg [6:0] out;

always @(posedge clk or negedge rst_n)
	if(!rst_n)
		out <= 7'b100_0000;
	else
		begin
			case(in)
				4'd0: out <= 7'b100_0000;
        		4'd1: out <= 7'b111_1001;
        		4'd2: out <= 7'b010_0100;
        		4'd3: out <= 7'b011_0000;
        		4'd4: out <= 7'b001_1001;
        		4'd5: out <= 7'b001_0010;
        		4'd6: out <= 7'b000_0010;
        		4'd7: out <= 7'b111_1000;
        		4'd8: out <= 7'b000_0000;
        		4'd9: out <= 7'b001_0000;
        		default: out <= 7'b111_1111;
			endcase
		end
			
endmodule