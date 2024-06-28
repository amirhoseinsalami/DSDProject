module memory(input clk,
		input reset,
		input WE,
		input [511:0] in,
		input [8:0] address,
		output reg [511:0] out);
integer i,k;
reg signed [31:0] memory [0:511];

always @(negedge reset or negedge clk)
begin 
	if(!reset) begin
		for(i=0;i<512;i=i+1) begin
			memory[i]<=32'b0;
		end
	end
	else if (WE) begin
		for(k=0;k<16;k=k+1) begin
			memory[(i+address)%512]<=$signed(in[31*i+:32]);
		end
	end
end

always @(posedge clk) 
begin
	out=512'b0;
	for(i=0;i<16;i=i+1) begin
		out[32*i+:32]=$signed(memory[(i+address)%512]);
	end
end

endmodule
