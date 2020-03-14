module sdr_fifo_ctrl(
	input ref_clk,//sdram控制器时钟
	input rst_n,//复位
	
	//用户写接口
	input clk_write,//写FIFO:写时钟
	input wrf_wrreq,//写FIFO:写使能
	input [15:0] wrf_din,//写FIFO:写数据
	input [24:0] wr_min_addr,//写sdram起始地址
	input [24:0] wr_max_addr,//写sdram结束地址
	input [10:0] wr_len,////写突发长度
	input wr_load,//写端口复位：复位读地址，清空写FIFO
	
	//用户读接口
	input clk_read,//读FIFO:读时钟
	input rdf_rdreq,//读FIFO:读使能
	output[15:0]rdf_dout,//读FIFO:读数据
	input [24:0]rd_min_addr,//读sdram起始地址
	input [24:0]rd_max_addr,//读sdram结束地址
	input [10:0]rd_len,////读突发长度
	input rd_load,//读端口复位：复位读地址，清空读FIFO

	//用户控制接口
	input  sdr_rd_valid,//sdram读使能
	input  sdr_init_done,//sdram初始化完成标志

	//sdram控制器写端口
	output reg 	 		sdr_wr_req,//sdram写请求
	input			 		sdr_wr_ack,//sdram写响应
	output reg [24:0] sdr_wr_addr,//sdram写地址
	output 	  [15:0] sdr_din,//写入sdram的数据
	//sdram控制器读端口
	output reg sdr_rd_req,//sdram读请求
	input		  sdr_rd_ack,//sdram读响应
	output reg  [24:0]sdr_rd_addr,//sdram读地址
	input 		[15:0]sdr_dout//从sdram读出的数据
	);
	
	reg 	wr_ack_r1;//sdarm写响应寄存器
	reg 	wr_ack_r2;
	reg 	rd_ack_r1;//sdarm读响应寄存器
	reg 	rd_ack_r2;
	reg 	wr_load_r1;//sdarm写端口复位寄存器
	reg 	wr_load_r2;
	reg 	rd_load_r1;//sdarm读端口复位寄存器
	reg 	rd_load_r2;//sdarm写响应寄存器
	reg   sdr_rd_valid_r1;//sdram读使能端口寄存器
	reg   sdr_rd_valid_r2;
	
	wire wr_done_flag;//sdr_wr_ack下降沿标志位
	wire rd_done_flag;//sdr_rd_ack下降沿标志位
	wire wr_load_flag;//wr_load上升沿标志位
	wire rd_load_flag;//rd_load上升沿标志位
	wire [10:0] wrf_use;//写FIFO数据量
	wire [10:0] rdf_use;//读FIFO数据量
	
	
	//检测下降沿
	assign wr_done_flag = (~wr_ack_r1)&(wr_ack_r2);
	assign rd_done_flag = (~rd_ack_r1) & (rd_ack_r2);
	
	//检测上升沿
	assign wr_load_flag = (wr_load_r1) & (~wr_load_r2);
	assign rd_load_flag = (rd_load_r1) & (~rd_load_r2);
	
	//寄存sdram写响应信号，用于捕获sdr_wr_ack下降沿
	always @(posedge ref_clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				wr_ack_r1 <= 1'd0;
				wr_ack_r2 <= 1'd0;
			end
		else
			begin
				wr_ack_r1 <= sdr_wr_ack;
				wr_ack_r2 <= wr_ack_r1;
			end
	end
	//寄存sdram读响应信号，用于捕获sdr_rd_ack下降沿
	always @(posedge ref_clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				rd_ack_r1 <= 1'd0;
				rd_ack_r2 <= 1'd0;
			end
		else
			begin
				rd_ack_r1 <= sdr_rd_ack;
				rd_ack_r2 <= rd_ack_r1;
			end
	end

	//同步写复位端口信号，用于捕获wr_load上升沿
	always @(posedge ref_clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				wr_load_r1 <= 1'd0;
				wr_load_r2 <= 1'd0;
			end
		else
			begin
				wr_load_r1 <= wr_load;
				wr_load_r2 <= wr_load_r1;
			end
	end
	//同步读复位端口信号，用于捕获rd_load上升沿
	always @(posedge ref_clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				rd_load_r1 <= 1'd0;
				rd_load_r2 <= 1'd0;
			end
		else
			begin
				rd_load_r1 <= rd_load;
				rd_load_r2 <= rd_ack_r1;
			end
	end
	//同步sdram读使能信号
	always @(posedge ref_clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				sdr_rd_valid_r1 <= 1'd0;
				sdr_rd_valid_r2 <= 1'd0;
			end
		else
			begin
				sdr_rd_valid_r1 <= sdr_rd_valid;
				sdr_rd_valid_r2 <= sdr_rd_valid_r1;
			end
	end
	//sdram写地址产生模块
	always @(posedge ref_clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				sdr_wr_addr <= 25'd0;
			end
		else if(wr_load_flag)
			sdr_wr_addr <= wr_min_addr;
		else if(wr_done_flag)
			begin
				if(sdr_wr_addr < wr_max_addr - wr_len)
					sdr_wr_addr <= sdr_wr_addr + wr_len;
				else
					sdr_wr_addr <= wr_min_addr;
			end
	end
	//sdram读地址产生模块
	always @(posedge ref_clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				sdr_rd_addr <= 25'd0;
			end
		else if(rd_load_flag)
			sdr_rd_addr <= rd_min_addr;
		else if(rd_done_flag)
			begin
				if(sdr_rd_addr < rd_max_addr - rd_len)
					sdr_rd_addr <= sdr_rd_addr + rd_len;
				else
					sdr_rd_addr <= rd_min_addr;
			end
	end
	//读写请求信号产生模块
	always @(posedge ref_clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				sdr_rd_req <= 1'd0;
				sdr_wr_req <= 1'b0;
			end
		else if(sdr_init_done) //当初始化完成后
			begin
				if(wrf_use >= wr_len)//写FIFO中的数据量大于写突发长度时，写请求打开
					begin
						sdr_wr_req <= 1'b1;
						sdr_rd_req <= 1'b0;
					end
				else if((rdf_use < rd_len)&& sdr_rd_valid_r2)//读fifo中的数据量小于突发长度，读请求打开
					begin
						sdr_wr_req <= 1'b0;
						sdr_rd_req <= 1'b1;
					end
				else
					begin
						sdr_rd_req <= 1'd0;
						sdr_wr_req <= 1'b0;
					end
			end
		else
			begin
				sdr_rd_req <= 1'd0;
				sdr_wr_req <= 1'b0;
			end
	end
	
	
	//写FIFO
	wr_fifo WR_FIFO(
	//用户接口
	. wrclk		(clk_write),		//写时钟
	. wrreq		(wrf_wrreq),		//写请求
	. data		(wrf_din),			//写数据
	//sdram接口
	. rdclk		(ref_clk),			//读时钟
	. rdreq		(sdr_wr_ack),		//读请求，提前一个clk打开
	. q			(sdr_din),			//读数据向sdram中写入的数据
	
	. wrusedw(wrf_use),				//写FIFO中的数据量
	. aclr(~rst_n | wr_load_flag));//异步清零信号
	
	//读FIFO
	rd_fifo RD_FIFO(
	//用户接口
	.wrclk(ref_clk),//写时钟
	.wrreq(sdr_rd_ack),//写请求
	.data(sdr_dout),//写数据
	//sdram接口
	.rdclk(clk_read),//读时钟
	.rdreq(rdf_rdreq),//读请求
	.q(rdf_dout),//读数据
	
	.rdusedw(rdf_use),//FIFO中的数据量
	.aclr(~rst_n | rd_load_flag));//异步清零信号
	endmodule 