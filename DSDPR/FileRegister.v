module Register(input clk,
		input reset,
		input WE,
		input [1:0] regselect,//00:A1,01:A2,10:A3,11:A4
		input [511:0] inputData,
		output reg [511:0] outputData);

reg [511:0] A1,A2,A3,A4;

always @(negedge reset or negedge clk)
begin
	if(WE) begin
		case (regselect)
			2'b00 : A1 <=inputData;
			2'b01 : A2 <=inputData;
			2'b10 : A3 <=inputData;
			2'b11 : A4 <=inputData;
		endcase
	end
end

always @ (*)
begin
	case (regselect)
		2'b00 : outputData<=A1;
		2'b01 : outputData<=A2;
		2'b10 : outputData<=A3;
		2'b11 : outputData<=A4;
		default : outputData = 512'b0;
	endcase
end
endmodule
