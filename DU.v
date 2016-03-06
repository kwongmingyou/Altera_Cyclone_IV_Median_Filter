module DU(
	output 		[7:0]		out, 
	output 		[18:0]	out_address, 
	input 					clk, 
	input						ldAddr, 
	input			[2:0]		selAddr, 
	input 					ldImage,  
	input 		[2:0] 	selImage, 
	input 					ldFilter, 
	input 		[1:0]		selFilter, 
	input                done 
); 

wire	[18:0]	address_a; 
wire	[18:0]	address_b; 
reg 	[18:0]	addr_a; 
reg	[18:0]	addr_b; 
wire				wren_a; 
wire				wren_b; 
wire				wr_en; 
wire 	[7:0]		q_a; 
wire	[7:0]		q_b; 
wire	[7:0]		data_a; 
wire	[7:0]		data_b; 

reg 	[7:0] 	in1;  
reg 	[7:0] 	in2; 
reg 	[7:0] 	in3;
reg 	[7:0] 	in4;  
reg 	[7:0] 	in5;  
reg 	[7:0] 	in6;  
reg 	[7:0] 	in7;  
reg 	[7:0] 	in8;  
reg 	[7:0] 	in9;

reg [10:0] column;
reg [9:0] row;
reg [1:0] extra_bits;

parameter LENGTH = 480, WIDTH = 640; 

initial begin 
in1 <= 8'd0; 
in2 <= 8'd0; 
in3 <= 8'd0; 
in4 <= 8'd0; 
in5 <= 8'd0; 
in6 <= 8'd0; 
in7 <= 8'd0; 
in8 <= 8'd0; 
in9 <= 8'd0; 
column <= 0;
row <= 0; 
end

// read_address
always@(posedge clk)
begin 
  if(done) begin 
    if(column == LENGTH - 1) 
	   begin column <= 0; row <= row + 1; end 
	 else column <= column + 1; 
  end
end

// read_address
always@(posedge clk) begin
  if(ldAddr) begin
  if(row > 0 && row < (WIDTH - 1) && column > 0 && column < (LENGTH - 1) ) begin
    case(selAddr)
    1: begin 	{extra_bits, addr_a} <= LENGTH * (row - 1) + column - 1 ; 	
	  			   {extra_bits, addr_b} <= LENGTH * (row - 1) + column; 	
		 end 
    2: begin 	{extra_bits, addr_a} <= LENGTH * (row - 1) + column + 1; 	
				   {extra_bits, addr_b} <= LENGTH * row + column - 1; 			
		 end
    3: begin 	{extra_bits, addr_a} <= LENGTH * row + column; 	
				   {extra_bits, addr_b} <= LENGTH * row + column + 1; 	
		 end
    4: begin 	{extra_bits, addr_a} <= LENGTH * (row + 1) + column - 1; 	
				   {extra_bits, addr_b} <= LENGTH * (row + 1) + column; 	
		 end
    5: begin 	{extra_bits, addr_a} <= LENGTH * (row + 1) + column + 1;
		 end
  endcase
  end
  else if ((row == 0) || (column == 0) || (column == (LENGTH-1)) || (row == (WIDTH-1) )) begin
    if(selAddr != 0)
    begin  {extra_bits, addr_a} <= LENGTH * row + column; 
			  {extra_bits, addr_b} <= LENGTH * row + column;
			  end
//		2,4: begin 	{extra_bits, addr_a} <= LENGTH * row + column + 1; 
//						{extra_bits, addr_b} <= LENGTH * row + column + 1;
//						end
//		3: begin 	{extra_bits, addr_a} <= LENGTH * row + {10'd0, column}; 
//						{extra_bits, addr_b} <= LENGTH * row + {10'd0, column};
//						end 
//		4: begin 	{extra_bits, addr_a} <= LENGTH * row + {10'd0, column} + 20'd1; 
//						{extra_bits, addr_b} <= LENGTH * row + {10'd0, column} + 20'd1;
//						end
//		5: begin 	{extra_bits, addr_a} <= LENGTH * row + {10'd0, column}; 
//						{extra_bits, addr_b} <= LENGTH * row + {10'd0, column};
//						end
		
	 
	 
  end 
  end //if(ldAddr)
  end //always

assign address_a = addr_a; 
assign address_b = addr_b; 
assign out_address = LENGTH * row + column;

// access memory
myRAM read_memory(
	.address_a		(address_a), 
	.address_b		(address_b), 
	.clock			(clk), 
	.data_a			(data_a), 
	.data_b			(data_b), 
	.wren_a			(wren_a), 
	.wren_b			(wren_b), 
	.q_a				(q_a), 
	.q_b				(q_b)
);

// store the data
always@(selImage)
begin 
  if(ldImage) 
  begin 
    case(selImage)
	 1: begin in1 <= q_a; in2 <= q_b; end 
	 2: begin in3 <= q_a; in4 <= q_b; end
	 3: begin in5 <= q_a; in6 <= q_b; end
	 4: begin in7 <= q_a; in8 <= q_b; end
	 5: begin in9 <= q_a; end
    endcase 
  end 
end

// median Filter
comparator_9 comp(	
	.out				(out), 
	.clk				(clk), 
	.ldFilter		(ldFilter), 
	.selFilter		(selFilter), 
	.in1				(in1), 
	.in2				(in2), 
	.in3				(in3), 
	.in4				(in4), 
	.in5				(in5), 
	.in6				(in6), 
	.in7				(in7), 
	.in8				(in8), 
	.in9				(in9)
);

endmodule 