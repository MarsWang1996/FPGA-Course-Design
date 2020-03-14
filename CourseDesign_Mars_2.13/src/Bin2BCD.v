/*二进制转十进制BCD码*/
module Bin2BCD(clk,bin,rst_n,one, ten, hun, tho);

	input  [9:0] 	bin;
	input        	clk,rst_n;
	output [3:0] 	one, ten, hun, tho;

	wire   [3:0] 	one, ten, hun, tho;
	reg    [3:0] 	one_num, ten_num, hun_num, tho_num;
	reg    [3:0] 	count;
	reg    [23:0]	shift_reg=23'd0;

	always @ ( posedge clk or negedge rst_n )
		begin
			if(!rst_n) 
					count<=0;
			else if (count==12)
					count<=0;
			else
				count<=count+1;
		end

	always @ (posedge clk or negedge rst_n )
		begin
			if (!rst_n)
						shift_reg=0;
			else if (count==0)
						shift_reg={14'b00000000000000,bin};
			else if ( count<=10)                
					begin
							if(shift_reg[13:10]>=5)           
								 begin
										if(shift_reg[17:14]>=5)   
											begin   
												if(shift_reg[21:18]>=5) 
													begin
														shift_reg[21:18]=shift_reg[21:18]+2'b11;
														shift_reg[17:14]=shift_reg[17:14]+2'b11;      
														shift_reg[13:10]=shift_reg[13:10]+2'b11;
														shift_reg=shift_reg<<1;
													end
												else
													begin
														shift_reg[21:18]=shift_reg[21:18];
														shift_reg[17:14]=shift_reg[17:14]+2'b11;      
														shift_reg[13:10]=shift_reg[13:10]+2'b11;
														shift_reg=shift_reg<<1;
													end
											end
										else       
											begin   
												if(shift_reg[21:18]>=5) 
													begin
														shift_reg[21:18]=shift_reg[21:18]+2'b11;
														shift_reg[17:14]=shift_reg[17:14];      
														shift_reg[13:10]=shift_reg[13:10]+2'b11;
														shift_reg=shift_reg<<1;
													end
												else
													begin
														shift_reg[21:18]=shift_reg[21:18];
														shift_reg[17:14]=shift_reg[17:14];      
														shift_reg[13:10]=shift_reg[13:10]+2'b11;
														shift_reg=shift_reg<<1;
													end
											end
								end              
							else
								begin
										if(shift_reg[17:14]>=5)   
											begin   
												if(shift_reg[21:18]>=5) 
													begin
														shift_reg[21:18]=shift_reg[21:18]+2'b11;
														shift_reg[17:14]=shift_reg[17:14]+2'b11;
														shift_reg[13:10]=shift_reg[13:10];      
														shift_reg=shift_reg<<1;
													end
												else
													begin
														shift_reg[21:18]=shift_reg[21:18];
														shift_reg[17:14]=shift_reg[17:14]+2'b11;
														shift_reg[13:10]=shift_reg[13:10];      
														shift_reg=shift_reg<<1;
													end
											end
										else       
											begin   
												if(shift_reg[21:18]>=5) 
													begin
														shift_reg[21:18]=shift_reg[21:18]+2'b11;
														shift_reg[17:14]=shift_reg[17:14];
														shift_reg[13:10]=shift_reg[13:10];      
														shift_reg=shift_reg<<1;
													end
												else
													begin
														shift_reg[21:18]=shift_reg[21:18];
														shift_reg[17:14]=shift_reg[17:14];
														shift_reg[13:10]=shift_reg[13:10];     
														shift_reg=shift_reg<<1;
													end
											end
								end                
				end
		end

	always @ ( posedge clk or negedge rst_n )
		begin
			if (!rst_n)
				begin
						one_num<=0;
						ten_num<=0;
						hun_num<=0;
						tho_num<=0; 
				end
			else if (count==11)  
				begin
						one_num<=shift_reg[13:10];
						ten_num<=shift_reg[17:14];
						hun_num<=shift_reg[21:18];
						tho_num<={2'b00, shift_reg[23:22]}; 
				end
		end
	
	assign one = one_num;
	assign ten = ten_num;	
	assign hun = hun_num;
	assign tho = tho_num;

endmodule
