module medianFilter(
	output	[7:0]		out, 
	output 	[18:0]	out_address, 
	input					clk, 
	input 				rst
); 

wire 			ldAddr; 
wire			ldImage; 
wire 			ldFilter; 
wire 			done; 
wire	[2:0]	selAddr; 
wire 	[1:0]	selFilter; 
wire 	[2:0]	selImage; 

DU du(
	.out					(out), 
	.clk					(clk), 
	.out_address		(out_address), 
	.ldAddr				(ldAddr), 
	.selAddr				(selAddr), 
	.ldImage				(ldImage), 
	.selImage			(selImage), 
	.ldFilter			(ldFilter), 
	.selFilter			(selFilter), 
	.done             (done)
); 

CU	cu(
	.ldAddr				(ldAddr), 
	.selAddr				(selAddr), 
	.ldImage				(ldImage), 
	.selImage			(selImage), 
	.ldFilter			(ldFilter), 
	.selFilter			(selFilter), 
	.done					(done), 
	.clk					(clk), 
	.rst					(rst)
); 

endmodule 
