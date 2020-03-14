module sdr_ctrl_top(
	input				sys_clk,
	input				sys_rst_n,
	input	[9:0]		SW,
	input 			KEY,
	input 			key_add,
	input 			key_multi,
	//sdram芯片接口
	output 			sdr_clk,//sdram 芯片时钟
	output			sdr_cke,//sdram 时钟有效
	output			sdr_cs_n,//sdram 片选
	output 			sdr_ras_n,//sdram 行有效
	output 			sdr_cas_n,//sdram 列有效
	output		 	sdr_we_n,//sdram 写使能
	output [12:0]	sdr_a,//sdram 行/列地址
	output [1:0] 	sdr_ba,//sdram bank地址
	output [1:0] 	sdr_dqm,//sdram 数据掩码
	inout  [15:0] 	sdr_dq,//sdram 数据
	output [9:0] 	LEDR,
	output [6:0] 	HEX5,
	output [6:0] 	HEX4,
	output [6:0] 	HEX3,
	output [6:0] 	HEX2,
	output [6:0] 	HEX1,
	output [6:0] 	HEX0
	);
	
	wire	clk_50m;//sdram 读写测试时钟
	wire 	clk_100m;//sdram 控制器时钟
	wire 	clk_100m_shift;//相位偏移时钟
	wire 	locked;//PLL输出有效标志	
	//PLL
	pll PLL (
	. areset		(1'b0),
	. inclk0		(sys_clk),				//50M
	. c0			(clk_50m),				//50M
	. c1			(clk_100m),				//100M
	. c2			(clk_100m_shift),		//100M -75deg sdram时钟
	. locked		(locked)
	);				//pll稳定后，locked=1
	
	wire			rst_n;//复位信号
	assign		rst_n = locked & sys_rst_n;//locked输出稳定之后，其他模块才开始工作,低电平有效	
	//sdram读写
	wire 			wr_en;        //sdram 写使能
	wire [15:0]	wr_data;//sdram 写数据
	wire 			rd_en;        //sdram 读使能	
	//sdram测试模块
	sdr_test SDR_TEST(
	. clk_50m			(clk_50m),			//时钟
	. rst_n				(KEY),				//复位，低有效
	. SW(SW),
	. wr_en				(wr_en),				//sdram 写使能
	. wr_data			(wr_data),			//sdram 写数据
	. rd_en				(rd_en),    		//sdram 读使能
	
	. sdr_init_done	(sdr_init_done)	 //sdram 初始化完成标志
	);
		
	wire [15:0]	rd_data;//sdram 读数据
	wire 			sdr_init_done;//sdram 初始化完成
	wire			sdr_rd_valid;//用户端口
	assign 		sdr_rd_valid = 1'b1;	
	//sdram控制顶层模块，封装成fifo接口sdram控制器地址组成{sdr_ba,sdr_row,sdr_col}25bit
	sdr_top SDR_TOP(
	. ref_clk			(clk_100m),				//sdram控制器参考时钟
	. out_clk			(clk_100m_shift),		//用于输出的相位偏移时钟
	. rst_n				(rst_n),					//复位
	//用户写接口
	. wr_clk				(clk_50m),				//写FIFO:写时钟
	. wr_en				(wr_en),					//写FIFO:写使能
	. wr_data			(wr_data),				//写FIFO:写数据
	. wr_min_addr		(25'd0),					//写sdram起始地址
	. wr_max_addr		(25'd2048),				//写sdram结束地址
	. wr_len				(11'd8),				//写突发长度
	. wr_load			(~rst_n),				//写端口复位：复位写地址，清空写FIFO
	//用户读接口
	. rd_clk				(clk_50m),				//读FIFO:读时钟
	. rd_en				(rd_en),					//读FIFO:读使能
	. rd_data			(rd_data),				//读FIFO:读数据
	. rd_min_addr		(25'd0),					//读sdram起始地址
	. rd_max_addr		(25'd2048),				//读sdram结束地址
	. rd_len				(11'd4),				//读突发长度
	. rd_load			(~rst_n),				//读端口复位：复位读地址，清空读FIFO
	//用户控制接口
	. sdr_rd_valid		(sdr_rd_valid),					//sdram读使能
	. sdr_init_done	(sdr_init_done),		//sdram初始化完成标志
	//sdram芯片接口
	. sdr_clk			(sdr_clk),				//sdram 芯片时钟
	. sdr_cke			(sdr_cke),				//sdram 时钟有效
	. sdr_cs_n			(sdr_cs_n),				//sdram 片选
	. sdr_ras_n			(sdr_ras_n),			//sdram 行有效
	. sdr_cas_n			(sdr_cas_n),			//sdram 列有效
	. sdr_we_n			(sdr_we_n),				//sdram 写使能
	. sdr_a				(sdr_a),					//sdram 行/列地址
	. sdr_ba				(sdr_ba),				//sdram bank地址
	. sdr_dqm			(sdr_dqm),				//sdram 数据掩码
	. sdr_dq				(sdr_dq)					//sdram 数据
	);
	
	wire	[4:0]	Addent_1, Addent_2;	
	wire 	[5:0]	Sum;
	Adder ADDER(
	.rd_data			(rd_data), 
	.clk				(clk_50m), 
	.rst_n			(rst_n), 
	.Addent_1		(Addent_1), 
	.Addent_2		(Addent_2), 
	.Sum				(Sum)
	);	

    wire	[9:0]	mul_out;	
    multi_5bits_pipelining Multi_5bits(
	.rd_data			(rd_data), 
	.clk				(clk_50m), 
	.rst_n			(rst_n), 
	.mul_out			(mul_out)	
	);
	
	wire	add_enable, multi_enable;		
	Function_select FUNCTION_SELECT(
	.clk				(clk_50m), 
	.rst_n			(rst_n),  
	.key_read		(KEY),
	.key_add			(key_add), 
	.key_multi		(key_multi), 
	.add_enable		(add_enable), 
	.multi_enable	(multi_enable)
	);	
	
	Seg_num SEG_NUM(
	.clk				(clk_50m), 
	.rst_n			(rst_n), 
	.add_enable		(add_enable), 
	.multi_enable	(multi_enable), 
	.Addent_1		(Addent_1), 
	.Addent_2		(Addent_2), 
	.Sum				(Sum), 
	.mul_out			(mul_out), 
	.HEX0				(HEX0), 
	.HEX1				(HEX1), 
	.HEX2				(HEX2), 
	.HEX3				(HEX3), 
	.HEX4				(HEX4), 
	.HEX5				(HEX5)
	);
	
	assign LEDR = rd_data[9:0];
		
endmodule 