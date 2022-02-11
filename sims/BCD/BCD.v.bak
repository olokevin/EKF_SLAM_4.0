module BCD(A,B,Sum,Cout);
	input [3:0]A,B;
	output [3:0]Sum; 
	output Cout;
//	reg [3:0]Sum;
//	reg Cout?
	wire [4:0]Temp;
	
	assign Temp = A + B;
	assign {Cout , Sum} = (Temp > 9 )? Temp +6 : Temp;
	
/*	always@(A or B)
		begin
		{Cout , Sum} = A + B;
		if({Cout , Sum} > 9 )
			{Cout , Sum} = {Cout , Sum} + 6;
		end
*/
	
endmodule

