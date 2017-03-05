module comparator_9(
	output	[7:0]		out, 
	input					clk, 
	input					ldFilter, 
	input		[1:0]		selFilter, 
	input		[7:0]		in1, 
	input		[7:0]		in2, 
	input		[7:0]		in3, 
	input		[7:0]		in4, 
	input		[7:0]		in5, 
	input		[7:0]		in6, 
	input		[7:0]		in7, 
	input		[7:0]		in8, 
	input		[7:0]		in9
); 

wire	[7:0] max11, max12, max13, max21, max22, max23, max3; 
wire 	[7:0] med11, med12, med13, med21, med22, med23, med3; 
wire	[7:0]	min11, min12, min13, min21, min22, min23, min3; 
wire			en1, en2, en3; 

// enable of comparator
assign en1 = (ldFilter == 1) && (selFilter == 1); 
assign en2 = (ldFilter == 1) && (selFilter == 2); 
assign en3 = (ldFilter == 1) && (selFilter == 3); 

comparator comp11(.max (max11), .med (med11), .min (min11), .clk (clk), .en (en1), .in_1 (in1), .in_2 (in2), .in_3 (in3)); 
comparator comp12(.max (max12), .med (med12), .min (min12), .clk (clk), .en (en1), .in_1 (in4), .in_2 (in5), .in_3 (in6));
comparator comp13(.max (max13), .med (med13), .min (min13), .clk (clk), .en (en1), .in_1 (in7), .in_2 (in8), .in_3 (in9));
comparator comp21(.max (max21), .med (med21), .min (min21), .clk (clk), .en (en2), .in_1 (max11), .in_2 (max12), .in_3 (max13));
comparator comp22(.max (max22), .med (med22), .min (min22), .clk (clk), .en (en2), .in_1 (med11), .in_2 (med12), .in_3 (med13));
comparator comp23(.max (max23), .med (med23), .min (min23), .clk (clk), .en (en2), .in_1 (min11), .in_2 (min12), .in_3 (min13));
comparator comp3(.max (max3), .med (med3), .min (min3), .clk (clk), .en (en3), .in_1 (min21), .in_2 (med22), .in_3 (max23));

assign out = med3; 

endmodule

module comparator(
	output reg	[7:0]	max, 
	output reg	[7:0]	med, 
	output reg	[7:0]	min,
	input					clk, 
	input					en, 
	input			[7:0]	in_1, 
	input			[7:0]	in_2, 
	input			[7:0]	in_3
);

always@(posedge clk)
begin
	if(en)
	begin
	  if((in_1 >= in_2) && (in_1 >= in_3) && (in_2 >= in_3)) begin max <= in_1; med <= in_2; min <= in_3; end 
	  else if((in_1 >= in_2) && (in_1 >= in_3) && (in_3 >= in_2)) begin max <= in_1; med <= in_3; min <= in_2; end
	  else if((in_2 >= in_1) && (in_2 >= in_3) && (in_1 >= in_3)) begin max <= in_2; med <= in_1; min <= in_3; end
	  else if((in_2 >= in_1) && (in_2 >= in_3) && (in_3 >= in_1)) begin max <= in_2; med <= in_3; min <= in_1; end
	  else if((in_3 >= in_1) && (in_3 >= in_2) && (in_1 >= in_2)) begin max <= in_3; med <= in_1; min <= in_2; end
	  else if((in_3 >= in_1) && (in_3 >= in_2) && (in_2 >= in_1)) begin max <= in_3; med <= in_2; min <= in_1; end
	end
end

endmodule