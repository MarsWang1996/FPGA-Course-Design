module multi_5bits_pipelining(rd_data, clk, rst_n, mul_out);
    
	input	[15:0] 	rd_data;
	input        	clk;
	input        	rst_n;
	output[9:0]  	mul_out;
 
	reg   [4:0]  	mul_a,mul_b;
	
   reg   [9:0]  	mul_out_1;
	reg   [9:0]  	mul_out_2;
	reg   [9:0]  	mul_out;

   reg   [9:0]		stored0;
   reg  	[9:0]  	stored1;
   reg  	[9:0]  	stored2;
   reg  	[9:0]		stored3;
	reg   [9:0]		stored4;
	
   reg  	[9:0]		add01;
   reg	[9:0]  	add23;
   reg  	[9:0]  	add4;
	
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
			begin
				mul_out <= 0;
				stored0 <= 0;
				stored1 <= 0;
				stored2 <= 0;
				stored3 <= 0;
				stored4 <= 0;
				add01 <= 0;
				add23 <= 0;
				add4 <= 0;
			end
        else 
			begin
				mul_a <= rd_data[9:5];
				mul_b <= rd_data[4:0];
				stored0 <= mul_b[0]? {5'b0, mul_a} : 10'b0;
				stored1 <= mul_b[1]? {4'b0, mul_a, 1'b0} : 10'b0;
				stored2 <= mul_b[2]? {3'b0, mul_a, 2'b0} : 10'b0;
				stored3 <= mul_b[3]? {2'b0, mul_a, 3'b0} : 10'b0;
				stored4 <= mul_b[4]? {1'b0, mul_a, 4'b0} : 10'b0;

				add01 <= stored1 + stored0;
				add23 <= stored3 + stored2;
				add4  <= stored4;

				mul_out_1 <= add01 + add23;
				mul_out_2 <= add4;
				
				mul_out <= mul_out_1 + mul_out_2;
			end
    end
endmodule
