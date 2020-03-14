`timescale 1ns/1ns
module sdr_ctrl_top_tb;
	reg 				sys_clk;
	reg				sys_rst_n;
	//用户接口
//	reg sdr_rd_valid;
	reg [9:0] SW;
	reg KEY;
	//sdram芯片接口
	wire			   sdr_clk;//sdram 芯片时钟
	wire 				sdr_cke;//sdram 时钟有效
	wire				sdr_cs_n;//sdram 片选
	wire 				sdr_ras_n;//sdram 行有效
	wire 				sdr_cas_n;//sdram 列有效
	wire 				sdr_we_n;//sdram 写使能
	wire 	[12:0]	sdr_a;//sdram 行/列地址
	wire 	[1:0] 	sdr_ba;//sdram bank地址
	wire 	[1:0] 	sdr_dqm;//sdram 数据掩码
	wire  [15:0]	sdr_dq;//sdram 数据
	wire [9:0] LEDR;
	wire [6:0] HEX5;
	wire [6:0] HEX4;
	wire [6:0] HEX3;
	wire [6:0] HEX2;
	wire [6:0] HEX1;
	wire [6:0] HEX0;	

	
	sdr_ctrl_top   SDR_CTRL_TOP(
	. sys_clk(sys_clk),
	. sys_rst_n(sys_rst_n),
	
	//用户接口
	//. sdr_rd_valid(sdr_rd_valid),
	. SW(SW),
	. KEY(KEY),
	//sdram芯片接口
	. sdr_clk(sdr_clk),//sdram 芯片时钟
	. sdr_cke(sdr_cke),//sdram 时钟有效
	. sdr_cs_n(sdr_cs_n),//sdram 片选
	. sdr_ras_n(sdr_ras_n),//sdram 行有效
	. sdr_cas_n(sdr_cas_n),//sdram 列有效
	. sdr_we_n(sdr_we_n),//sdram 写使能
	. sdr_a(sdr_a),//sdram 行/列地址
	. sdr_ba(sdr_ba),//sdram bank地址
	. sdr_dqm(sdr_dqm),//sdram 数据掩码
	. sdr_dq(sdr_dq),//sdram 数据
	. LEDR(LEDR),
	. HEX5(HEX5),
	. HEX4(HEX4),
	. HEX3(HEX3),
	. HEX2(HEX2),
	. HEX1(HEX1),
	. HEX0(HEX0)	
);

		
	initial begin
	#0 	sys_clk = 0;
		sys_rst_n = 0;
		SW = 10'b1010101010;
		KEY = 0;
		
	#100 
		sys_rst_n = 1;

	end
	
	always #10 sys_clk = ~sys_clk;
	 
	
endmodule 