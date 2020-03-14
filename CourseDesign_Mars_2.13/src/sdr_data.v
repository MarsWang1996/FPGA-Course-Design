module sdr_data(
	input clk,
	input rst_n,
	
	input [15:0] sdr_data_in,//写入sdram中的数据
	
	input [3:0] work_state,//sdram工作状态寄存器
	input [10:0] cnt_clk,//时钟计数
	output [15:0] sdr_data_out,//从sdram和fpga中读出的数据
	
	inout  [15:0] sdr_data
	);

	`include "para.v"
	
	reg   sdr_out_en;//sdram数据总线输出使能
	reg [15:0] sdr_din_r;//寄写入sdram中的数据
	reg [15:0] sdr_dout_r;//寄存从sdram中读取的数据
	
	//***************************************************************************************************************
	
	//sdram 双向数据线作为输入时保持高阻态
	assign sdr_data = sdr_out_en ? sdr_din_r : 16'hzzzz;
	//sdram数据总线输出使能
	always @ (posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				sdr_out_en <= 1'd0;
				sdr_din_r <= 16'd0;	
			end
		else if((work_state == `W_WRITE) |(work_state == `W_WD))
			begin
				sdr_out_en <= 1'd1;
				sdr_din_r <= sdr_data_in;
			end
		else
			begin
				sdr_out_en <= 1'd0;
				sdr_din_r <= sdr_data_in;	
			end
	end
	
	//读数据
	always @ (posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			sdr_dout_r <= 16'd0;
		else
			sdr_dout_r <= sdr_data;
	end
		//输出sdram中读取的数据
	assign sdr_data_out = sdr_dout_r;
endmodule 