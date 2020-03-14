module sdr_test(
	input 					clk_50m,
	input 					rst_n,
	input 		[9:0]		SW,
	output reg				wr_en,         
	output reg	[15:0] 	wr_data,
	output reg	 			rd_en,         
	input 					sdr_init_done      
	);   
	reg 				sdr_init_done_d0;
	reg 				sdr_init_done_d1;
	reg	[11:0]	wr_cnt;

	always @ (posedge clk_50m or negedge rst_n)
	begin
		if(!rst_n)
			begin
				sdr_init_done_d0 <= 1'b0;
				sdr_init_done_d1 <= 1'b0;
			end
		else
			begin
				sdr_init_done_d0 <= sdr_init_done;
				sdr_init_done_d1 <= sdr_init_done_d0;
			end
	end	

	always @ (posedge clk_50m or negedge rst_n)
	begin
		if(!rst_n)
			begin
				wr_cnt <= 12'b0;
			end
		else if(sdr_init_done_d1 && wr_cnt <= 12'd2049)
			begin
				wr_cnt <= wr_cnt + 1'b1;
			end
		else
			wr_cnt <= wr_cnt;
	end	

	always @ (posedge clk_50m or negedge rst_n)
	begin
		if(!rst_n)
			begin
				wr_en <= 1'd0;
				wr_data <= 15'd0;
			end
		else if(wr_cnt >= 12'd1 && wr_cnt <= 12'd2049)
			begin
				wr_en <= 1'd1;		
				wr_data <= {6'b0,SW};
			end
		else
			begin
				wr_en <= 1'd0;
				wr_data <= 15'd0;
			end
	end
	
	always @ (posedge clk_50m or negedge rst_n)
	begin
		if(!rst_n)
			begin
				rd_en <= 1'b0;
			end
		else if(wr_cnt > 12'd2049)
			rd_en <= 1'b1;         
	end

endmodule 