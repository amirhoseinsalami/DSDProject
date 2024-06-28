module mathUnit(input [511:0] A1,
		input [511:0] A2,
		input [1:0] instruction,
		output reg [1023:0] outputt,
		output reg[511:0] A3,
		output reg[511:0] A4);

integer i,k;


	always @(*) begin
		//mul
		if(instruction == 2'b01) begin
			for(i=0;i<16;i=i+1) begin
				outputt[i*64+:64]<=$signed(A1[i*32+:32]) + $signed(A2[i*32+:32]);			
			end
		A4[32 * i +: 32] <= outputt[64 * i +: 32];
                A3[32 * i +: 32] <= outputt[64 * i + 32 +: 32];
		end
		//sum
		if(instruction == 2'b10) begin
			for(k=0;k<16;k=k+1) begin
				outputt[k*64+:64]<=$signed(A1[k*32+:32]) + $signed(A2[k*32+:32]);
			end
		A4[32 * i +: 32] <= outputt[64 * i +: 32];
                A3[32 * i +: 32] <= outputt[64 * i + 32 +: 32];
		end
	end


endmodule
