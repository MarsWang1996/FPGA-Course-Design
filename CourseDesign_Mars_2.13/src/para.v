
//sdram初始化状态
`define I_NOP 	 		5'd0//等待上电200us
`define I_PRE 	 		5'd1//预充电状态
`define I_TRP  		5'd2//等待预充电完成 tRP
`define I_AUTO_REF 	5'd3//自动刷新
`define I_TRC 			5'd4//等待自动刷新完成 tRC
`define I_MRS 			5'd5//模式寄存器设置
`define I_TMRD  		5'd6//等待模式寄存器设置完成 tMRD
`define I_DONE  		5'd7//初始化完成
	//sdram工作状态
`define W_IDLE 		 5'd0//空闲状态
`define W_ACTIVE  	 5'd1//激活行
`define W_TRCD  		 5'd2//激活等待 tRCD
`define W_READ  		 5'd3//读操作
`define W_RD  			 5'd4//读数据(+读潜伏期)
`define W_WRITE   	 5'd5//写操作
`define W_WD  			 5'd6//写数据
`define W_BT          5'd7
`define W_PRE         5'd8
`define W_TRP         5'd9
`define W_AUTO_REF_PRE    5'd10//自动刷新状态的预充电
`define W_AUTO_REF_TRP    5'd11////自动刷新预充电等待
`define W_AUTO_REF1       5'd12//刷新1
`define W_TRC1           5'd13//等待刷新
`define W_AUTO_REF2       5'd14//刷新2
`define W_TRC2           5'd15//等待刷新

//延时参数
`define end_trp   cnt_clk == TRP_CLK-1//预充电有效周期结束
`define end_trc   cnt_clk == TRC_CLK-1 //自动刷新周期结束
`define end_tmrd  cnt_clk == TMRD_CLK - 1//模式寄存器设计周期结束
`define end_trcd   cnt_clk == TRCD_CLK - 1 //行选通周期结束
`define end_rdburst cnt_clk == sdr_rd_burst - 1 //读突发终止,全页写需要bt才能终止
`define end_tread  cnt_clk == sdr_rd_burst   //读突发结束(读突发时，由于cl=2，rd状态多一个clk，所以会有burst+1个clk
`define end_twrite cnt_clk == sdr_wr_burst - 2//写突发结束写突发时，write状态会发出一个data，wd状态会发出burst-1个data，所以会有burst-1个clk
`define end_tDPL   cnt_clk == TDPL_CLK - 1//数据到预充电
