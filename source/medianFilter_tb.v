`timescale 1ns/1ns 
module medianFilter_tb; 

reg clk; 
reg rst; 
wire [7:0] out; 
wire [18:0] out_address; 

medianFilter medFilter(.clk(clk),.rst(rst), .out_address(out_address), .out(out)); 


initial begin 
  clk = 0; 
  rst = 0; 
 // $monitor("time:", $time, "clk=%b, rst=%b, out=%h", clk, rst, out,);
end
	
	always #5 clk = ~clk; 

initial begin 
  #2 rst = 1; 
  #27648010 $stop; 
end 

endmodule 