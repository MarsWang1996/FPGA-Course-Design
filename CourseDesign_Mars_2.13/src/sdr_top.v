module sdr_top(
	input 			ref_clk,//sdram控制器参考时钟
	input 			out_clk,//用于输出的相位偏移时钟
	input 			rst_n,//复位
	//用户写接口
	input 			wr_clk,//写FIFO:写时钟
	input 			wr_en,//写FIFO:写使能
	input [15:0]	wr_data,//写FIFO:写数据
	input [24:0]	wr_min_addr,//写sdram起始地址
	input [24:0]	wr_max_addr,//写sdram结束地址
	input [10:0]	wr_len,////写突发长度
	input 			wr_load,//写端口复位：复位读地址，清空写FIFO
	//用户读接口
	input 			rd_clk,//读FIFO:读时钟
	input 			rd_en,//读FIFO:读使能
	output[15:0]	rd_data,//读FIFO:读数据
	input [24:0]	rd_min_addr,//读sdram起始地址
	input [24:0]	rd_max_addr,//读sdram结束地址
	input [10:0]	rd_len,////读突发长度
	input 			rd_load,//读端口复位：复位读地址，清空读FIFO
	//用户控制接口
	input 			sdr_rd_valid,//sdram读使能
	output 			sdr_init_done,//sdram初始化完成标志
	//sdram芯片接口
	output 			sdr_clk,//sdram 芯片时钟
	output 			sdr_cke,//sdram 时钟有效
	output 			sdr_cs_n,//sdram 片选
	output 			sdr_ras_n,//sdram 行有效
	output 			sdr_cas_n,//sdram 列有效
	output 			sdr_we_n,//sdram 写使能
	output [12:0]	sdr_a,//sdram 行/列地址
	output [1:0] 	sdr_ba,//sdram bank地址
	output [1:0] 	sdr_dqm,//sdram 数据掩码
	inout  [15:0] 	sdr_dq//sdram 数据
	
	);

	wire sdr_wr_req;//sdram写请求
	wire sdr_wr_ack;//sdram写响应
	wire [24:0]sdr_wr_addr;//sdram写地址
	wire [15:0]sdr_din;//sdram写数据
	
	wire sdr_rd_req;//sdram读请求
	wire sdr_rd_ack;//sdram读响应
	wire [24:0]sdr_rd_addr;//sdram读地址
	wire [15:0]sdr_dout;//sdram读数据
	//**********************************************
	 assign sdr_clk = out_clk;
	 assign sdr_dqm = 2'b00;

	

	//sdram读写端口
	//异步时钟域的时钟同步，数据缓存
	sdr_fifo_ctrl SDR_FIFO_CTRL(
	. ref_clk(ref_clk),//sdram控制器时钟
	. rst_n(rst_n),//复位
	
	//用户写接口
	. clk_write(wr_clk),//写FIFO:写时钟
	. wrf_wrreq(wr_en),//写FIFO:写使能
	. wrf_din(wr_data),//写FIFO:写数据
	. wr_min_addr(wr_min_addr),//写sdram起始地址
	. wr_max_addr(wr_max_addr),//写sdram结束地址
	. wr_len(wr_len),////写突发长度
	. wr_load(wr_load),//写端口复位：复位读地址，清空写FIFO
	
	//用户读接口
	. clk_read(rd_clk),//读FIFO:读时钟
	. rdf_rdreq(rd_en),//读FIFO:读使能
	. rdf_dout(rd_data),//读FIFO:读数据
	. rd_min_addr(rd_min_addr),//读sdram起始地址
	. rd_max_addr(rd_max_addr),//读sdram结束地址
	. rd_len(rd_len),////读突发长度
	. rd_load(rd_load),//读端口复位：复位读地址，清空读FIFO

	//用户控制接口
	.  sdr_rd_valid(sdr_rd_valid),//sdram读使能
	.  sdr_init_done(sdr_init_done),//sdram初始化完成标志

	//sdram控制器写端口
	.  sdr_wr_req(sdr_wr_req),//sdram写请求
	.	sdr_wr_ack(sdr_wr_ack),//sdram写响应
	.  sdr_wr_addr(sdr_wr_addr),//sdram写地址
	. 	sdr_din(sdr_din),//写入sdram的数据
	//sdram控制器读端口
	.  sdr_rd_req(sdr_rd_req),//sdram读请求
	.  sdr_rd_ack(sdr_rd_ack),//sdram读响应
	.  sdr_rd_addr(sdr_rd_addr),//sdram读地址
	.  sdr_dout(sdr_dout)//从sdram读出的数据
	);
	
	//sdram控制器模块
	sdr_controller SDR_CONTROLLER(
	. clk(ref_clk),
	. rst_n(rst_n),
	//sdram控制写端口
	. sdr_wr_req(sdr_wr_req),//sdram写请求
	. sdr_wr_ack(sdr_wr_ack),//sdram写响应
	. sdr_wr_addr(sdr_wr_addr),//sdram写地址
	. sdr_din(sdr_din),//写入sdram的数据
	. sdr_wr_burst(wr_len),//写入sdram的突发长度
	//sdram控制器读端口
	. sdr_rd_req(sdr_rd_req),//sdram读请求
	. sdr_rd_ack(sdr_rd_ack),//sdram读响应
	. sdr_rd_addr(sdr_rd_addr),//sdram读地址
	. sdr_dout(sdr_dout),//从sdram读出的数据
	. sdr_rd_burst(rd_len),//从sdram读出的突发长度
	//sdram芯片接口
	. sdr_cke(sdr_cke),//sdram 时钟有效
	. sdr_cs_n			(sdr_cs_n),				//sdram 片选
	. sdr_ras_n			(sdr_ras_n),			//sdram 行有效
	. sdr_cas_n			(sdr_cas_n),			//sdram 列有效
	. sdr_we_n			(sdr_we_n),				//sdram 写使能
	. sdr_a(sdr_a),//sdram 行/列地址
	. sdr_ba(sdr_ba),//sdram bank地址
	. sdr_dq(sdr_dq),//sdram 数据
	.sdr_init_done(sdr_init_done)
	);


endmodule 