module CU(
	output reg				ldAddr, 
	output reg	[2:0]		selAddr, 
	output reg				ldImage, 
	output reg	[2:0]		selImage, 
	output reg				ldFilter, 
	output reg 	[1:0]		selFilter, 
	output reg				done,
	input						clk, 
	input						rst
); 

reg	[3:0]	state; 

parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, S4 = 4'b0100, 
  S5 = 4'b0101, S6 = 4'b0110, S7 = 4'b0111, S8 = 4'b1000; 
parameter LENGTH = 640, WIDTH = 480; 

always@(negedge clk or negedge rst)
begin 
	if(!rst)	begin 
	  state <= 0;
	  ldAddr <= 0;			selAddr <= 0; 
	  ldImage <= 0;		selImage <= 0; 
	  ldFilter <= 0;		selFilter <= 0;  
	  done <= 0;  
	end
	else
	begin
		  ldAddr <= 0;			selAddr <= 0; 
		  ldImage <= 0;		selImage <= 0; 
		  ldFilter <= 0;		selFilter <= 0;  
		  done <= 0; 
		  case(state)
		  S0: 	begin state <= S1; 	ldAddr <= 1; 	selAddr <= 1; 		end 
		  S1: 	begin state <= S2; 	ldAddr <= 1; 	selAddr <= 2;  ldImage <= 1; 	selImage <= 1; end
		  S2: 	begin state <= S3; 	ldAddr <= 1; 	selAddr <= 3;  ldImage <= 1; 	selImage <= 2; end
		  S3: 	begin state <= S4; 	ldAddr <= 1; 	selAddr <= 4;  ldImage <= 1; 	selImage <= 3; end
		  S4: 	begin state <= S5; 	ldAddr <= 1; 	selAddr <= 5;  ldImage <= 1; 	selImage <= 4; end
		  S5: 	begin state <= S6;   ldImage <= 1; 	selImage <= 5; end		  
		  S6: 	begin state <= S7; 	ldFilter <= 1; 	selFilter <= 1; 	end 
		  S7: 	begin state <= S8; 	ldFilter <= 1; 	selFilter <= 2; 	end
		  S8: 	begin state <= S0; 	ldFilter <= 1; 	selFilter <= 3;   done <= 1; 	end
		  //S9: 	begin state <= S0; 	done <= 1; end
        default: begin state <= S0; end
        endcase
	end
end
endmodule 