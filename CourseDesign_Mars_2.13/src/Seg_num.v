module Seg_num(clk, rst_n, add_enable, multi_enable, Addent_1, Addent_2, Sum, mul_out, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	input					clk;
	input        		rst_n;
	input        		add_enable, multi_enable;
	input 	[4:0]		Addent_1, Addent_2;
	input 	[5:0]  	Sum;
	input 	[9:0]  	mul_out;	
	output	[6:0]  	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	reg   	[3:0]  	HEX0_num, HEX1_num, HEX2_num, HEX3_num, HEX4_num, HEX5_num;
	wire  	[3:0]		Addent_1_one, Addent_1_ten, Addent_1_hun, Addent_1_tho;
	wire  	[3:0]		Addent_2_one, Addent_2_ten, Addent_2_hun, Addent_2_tho;
	wire		[3:0]		Sum_one, Sum_ten, Sum_hun, Sum_tho;
	wire		[3:0]		mul_out_one, mul_out_ten, mul_out_hun, mul_out_tho;	

	Bin2BCD Addent_1_BCD(
	.clk(clk),
	.bin(Addent_1),
	.rst_n(rst_n),
	.one(Addent_1_one),
	.ten(Addent_1_ten),
	.hun(Addent_1_hun),
	.tho(Addent_1_tho)	
	);

	Bin2BCD Addent_2_BCD(
	.clk(clk),
	.bin(Addent_2),
	.rst_n(rst_n),
	.one(Addent_2_one),
	.ten(Addent_2_ten),
	.hun(Addent_2_hun),
	.tho(Addent_2_tho)	
	);
	
	Bin2BCD Sum_BCD(
	.clk(clk),
	.bin(Sum),
	.rst_n(rst_n),
	.one(Sum_one),
	.ten(Sum_ten),
	.hun(Sum_hun),
	.tho(Sum_tho)	
	);

	Bin2BCD multi_BCD(
	.clk(clk),
	.bin(mul_out),
	.rst_n(rst_n),
	.one(mul_out_one),
	.ten(mul_out_ten),
	.hun(mul_out_hun),
	.tho(mul_out_tho)	
	);
	
	always @(posedge clk or negedge rst_n) 
	begin
        if(!rst_n) 
			begin
				HEX0_num <= 0;	
				HEX1_num <= 0;
				HEX2_num <= 0;
				HEX3_num <= 0;
				HEX4_num <= 0;
				HEX5_num <= 0;		
			end
        else 
			begin
				if(add_enable == 1 && multi_enable == 0)
					begin
						HEX5_num <= Addent_1_ten;
						HEX4_num <= Addent_1_one;
						HEX3_num <= Addent_2_ten;
						HEX2_num <= Addent_2_one;
						HEX1_num <= Sum_ten;
						HEX0_num <= Sum_one;
					end
				else if(add_enable == 0 && multi_enable == 1)
					begin
						HEX5_num <= 0;
						HEX4_num <= 0;
						HEX3_num <= 0;
						HEX2_num <= mul_out_hun;
						HEX1_num <= mul_out_ten;
						HEX0_num <= mul_out_one;
					end
				else if(add_enable == 0 && multi_enable == 0)
					begin
						HEX5_num <= Addent_1_ten;
						HEX4_num <= Addent_1_one;
						HEX3_num <= Addent_2_ten;
						HEX2_num <= Addent_2_one;
						HEX1_num <= 0;
						HEX0_num <= 0;
					end
			end
    end
	
	Seg u5(.clk(clk),.rst_n(rst_n),.in(HEX5_num),.out(HEX5));
	Seg u4(.clk(clk),.rst_n(rst_n),.in(HEX4_num),.out(HEX4));
	Seg u3(.clk(clk),.rst_n(rst_n),.in(HEX3_num),.out(HEX3));	
	Seg u2(.clk(clk),.rst_n(rst_n),.in(HEX2_num),.out(HEX2));
	Seg u1(.clk(clk),.rst_n(rst_n),.in(HEX1_num),.out(HEX1));
	Seg u0(.clk(clk),.rst_n(rst_n),.in(HEX0_num),.out(HEX0));
	
endmodule

