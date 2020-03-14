module sdr_controller(
	input clk,
	input rst_n,
	//sdram控制写端口
	input 	 		sdr_wr_req,//sdram写请求
	output			sdr_wr_ack,//sdram写响应
	input [24:0] sdr_wr_addr,//sdram写地址
	input [15:0] sdr_din,//写入sdram的数据
	input [10:0] sdr_wr_burst,//写入sdram的突发长度
	//sdram控制器读端口
	input 		  sdr_rd_req,//sdram读请求
	output		  sdr_rd_ack,//sdram读响应
	input  [24:0]sdr_rd_addr,//sdram读地址
	output [15:0]sdr_dout,//从sdram读出的数据
	input [10:0] sdr_rd_burst,//从sdram读出的突发长度
	
	output sdr_init_done,
	
	//sdram芯片接口
	output 			 sdr_cke,//sdram 时钟有效
	output 		    sdr_cs_n,//sdram命令
	output 		    sdr_ras_n,//sdram命令
	output 		    sdr_cas_n,//sdram命令
	output 		    sdr_we_n,//sdram命令
	output [12:0]	sdr_a,//sdram 行/列地址
	output [1:0]	 sdr_ba,//sdram bank地址
	inout  [15:0]	 sdr_dq//sdram 数据
	);
	
	wire [4:0] init_state;
	wire [4:0] work_state;
	wire [10:0]cnt_clk;
	wire		  sdr_rd_wr;//sdram读写控制信号，低为写，高为读
	
	

	//状态控制模块
	sdr_ctrl SDR_CTRL(
		.clk(clk),
		.rst_n(rst_n),
		
		.sdr_wr_req(sdr_wr_req),//sdram写请求
		.sdr_rd_req(sdr_rd_req),//sdram读请求
		.sdr_wr_ack(sdr_wr_ack),//sdram写响应
		.sdr_rd_ack(sdr_rd_ack),//sdram读响应
		.sdr_wr_burst(sdr_wr_burst),//写入sdram的突发长度
		.sdr_rd_burst(sdr_rd_burst),//从sdram读出的突发长度
		.sdr_init_done(sdr_init_done),
		
		.init_state(init_state),//sdram 初始化状态
		.work_state(work_state),//sdram 工作状态
		.cnt_clk(cnt_clk),		//时钟计数器
		.sdr_rd_wr(sdr_rd_wr)//sdram读写控制信号，低为写，高为读
		
		);
	
	sdr_cmd SDR_CMD(
		.clk(clk),
		.rst_n(rst_n),
		
		.sdr_wr_burst(sdr_wr_burst),//写入sdram的突发长度
		.sdr_rd_burst(sdr_rd_burst),//从sdram读出的突发长度
		.sys_wraddr(sdr_wr_addr),//写SDRAM时地址
		.sys_rdaddr(sdr_rd_addr),//读SDRAM时地址
		
		.init_state(init_state),//sdram 初始化状态
		.work_state(work_state),//sdram 工作状态
		.cnt_clk(cnt_clk),
		.sdr_rd_wr(sdr_rd_wr),//sdram读写控制信号，低为写，高为读
		
		. sdr_cke 			(sdr_cke),
		. sdr_cs_n			(sdr_cs_n),				//sdram 片选
		. sdr_ras_n			(sdr_ras_n),			//sdram 行有效
		. sdr_cas_n			(sdr_cas_n),			//sdram 列有效
		. sdr_we_n			(sdr_we_n),				//sdram 写使能
		. sdr_a				(sdr_a),					//sdram 行/列地址
		. sdr_ba				(sdr_ba)					//sdram bank地址
	
	);

	//读写模块
	sdr_data SDR_DATA(
		.clk(clk),
		.rst_n(rst_n),
		.sdr_data_in(sdr_din),//写入sdram中的数据
		.sdr_data_out(sdr_dout),//从sdram中读出的数据
		.work_state(work_state),//sdram 工作状态
		.cnt_clk(cnt_clk),		//时钟计数器
		.sdr_data(sdr_dq)
		);

	endmodule 