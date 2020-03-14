module Function_select(clk, rst_n, key_read, key_add, key_multi, add_enable, multi_enable);

	input        key_read, key_add, key_multi;
	input        clk;
	input        rst_n;
	output       add_enable, multi_enable;
	
	reg          add_enable, multi_enable;
	
	parameter 	[2:0] 	IDLE=0,ST_ADD=1,ST_MULT=2;
	reg			[2:0] 	currentstate, nextstate;
	reg			[3:0] 	Key1_count, Key2_count, Key3_count;
	reg			     		IDLE_flag, ST_ADD_flag, ST_MULT_flag;
	reg 			[2:0]		control;
	
	always @(posedge clk or negedge rst_n)
	begin 
		if(!rst_n)
			begin
				Key1_count <= 4'd0;
				Key2_count <= 4'd0;
				Key3_count <= 4'd0;
			end 			 
		else 
			begin
				if(~key_read) 
					begin
						Key1_count <= Key1_count + 1'b1;
					end
				else 
					begin
						Key1_count <= 1'b0;
					end
				
				if(Key1_count > 4'd15)
					begin
						Key1_count <= 4'd0;
					end
				 
			if(~key_add) 
					begin
						Key2_count <= Key2_count + 1'b1;
					end
				else 
					begin
						Key2_count <= 1'b0;
					end
				if(Key2_count > 4'd15)
					begin
						Key2_count <= 4'd0;
					end
					
				if(~key_multi) 
					begin
						Key3_count <= Key3_count + 1'b1;
					end
				else 
					begin
						Key3_count <= 1'b0;
					end
					
				if(Key3_count > 4'd15)
					begin
						Key3_count <= 4'd0;
					end
			end
	end
		
	always @(posedge clk or negedge rst_n)
	begin 
	  if(!rst_n)
		begin
			IDLE_flag <= 1'b0;
			ST_ADD_flag <= 1'b0;
			ST_MULT_flag <= 1'b0;	
		end			 
	  else 
		begin
			if(Key1_count > 4'd10 && Key1_count < 4'd15) 
				begin
					IDLE_flag <= 1'b1;
					ST_ADD_flag <= 1'b0;
					ST_MULT_flag <= 1'b0;					
				end
				
			if(Key2_count > 4'd10 && Key2_count < 4'd15) 
				begin
					IDLE_flag <= 1'b0;
					ST_ADD_flag <= 1'b1;
					ST_MULT_flag <= 1'b0;					
				end
				
			if(Key3_count > 4'd10 && Key3_count < 4'd15) 
				begin
					IDLE_flag <= 1'b0;
					ST_ADD_flag <= 1'b0;
					ST_MULT_flag <= 1'b1;	
				end	
			
			control <= {ST_MULT_flag, ST_ADD_flag, IDLE_flag};
		end
	end		

	always @(control or currentstate)
	begin
		nextstate = IDLE;
		case(currentstate)
			IDLE  : if (control == 3'b100)                         
						nextstate = ST_MULT;       
					else if(control == 3'b010)
						nextstate = ST_ADD;
					else
						nextstate = IDLE;
			ST_ADD: if (control == 3'b100)                         
						nextstate = ST_MULT;       
					else if(control == 3'b001)
						nextstate = IDLE;
					else
						nextstate = ST_ADD; 
			ST_MULT:if (control == 3'b001)                         
						nextstate = IDLE;       
					else if(control == 3'b010)
						nextstate = ST_ADD;
					else
						nextstate = ST_MULT; 
			default:  nextstate = IDLE;						
		endcase
	end
		
	always @ (posedge clk or negedge rst_n)
		 begin
			if(!rst_n)
			  currentstate <= IDLE;
			else
			  currentstate <= nextstate;
		 end
		 
	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				add_enable <= 0;
				multi_enable <= 0;						
			end
		else
			case(currentstate)
				IDLE    : begin
							add_enable <= 0;
							multi_enable <= 0;						
						  end
				ST_ADD  : begin
							add_enable <= 1;
							multi_enable <= 0;						
						  end  
				ST_MULT : begin
							add_enable <= 0;
							multi_enable <= 1;						
						  end                        
			endcase
	end	

endmodule
	
