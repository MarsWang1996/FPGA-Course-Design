module Adder(rd_data, clk, rst_n, Addent_1, Addent_2, Sum);

	input [15:0] rd_data;
	input        clk;
	input        rst_n;
	output[4:0]  Addent_1, Addent_2;	
	output[5:0]  Sum;
	
	reg	[4:0]  Addent_1_num, Addent_2_num;	
	reg 	[5:0]  Sum_num;
	
	always @(posedge clk or negedge rst_n) 
	begin
			if(!rst_n) 
				begin
					Addent_1_num <= 0;
					Addent_2_num <= 0;
					Sum_num <= 0;
				end
			else 
				begin
					Addent_1_num = rd_data[9:5];
					Addent_2_num = rd_data[4:0];
					Sum_num <= Addent_1 + Addent_2;
				end
   end
	
	assign Addent_1 = Addent_1_num;	
	assign Addent_2 = Addent_2_num;
	assign Sum = Sum_num;
	
endmodule
