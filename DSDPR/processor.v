module processor(
		input clk,
		input reset,
		input [1:0] operation, // 00: Load, 01: Store, 10: Sum, 11: Product
    		input [8:0] addr,
   		inout [511:0] data

);
reg WE;



reg [1:0] regselect;//00:A1,01:A2,10:A3,11:A4
reg [511:0] inputData;
wire [511:0] outputData;


reg [511:0] in;
reg [8:0] address;
reg [511:0] out;

wire [511:0] A1;
wire [511:0] A2;
reg [1:0] instruction;
reg [1023:0] outputt;
reg [511:0] A3;
reg [511:0] A4;





FileRegister FR(
	.clk(clk),
	.reset(reset),
	.WE(WE),
	.regselect(regselect),
	.inputData(inputData),
	.outputData(outputData)
);

memory mem(
	.clk(clk),
	.reset(reset),
	.WE(WE),
	.in(in),
	.address(address),
	.out(out)
);

mathUnit MU(
	.A1(A1),
	.A2(A2),
	.instruction(instruction),
	.outputt(outputt)
);




assign A1 = (regselect == 2'b00) ? outputData : 512'b0;
assign A2 = (regselect == 2'b01) ? outputData : 512'b0;



always @(negedge clk or negedge reset) begin
        if (!reset) begin
            regselect <= 2'b00;
            inputData <= 512'b0;
            WE <= 1'b0;
            instruction<= 2'b00;
        end else begin
            case (operation)
                2'b00: begin // Load
                    regselect <= addr[1:0];
                    inputData <= data;
                    WE <= 1'b1;
                end
                2'b01: begin // Store
                    regselect <= addr[1:0];
                    inputData <= outputData;
                    WE <= 1'b0;
                end
                2'b10: begin // Sum
                    regselect <= 2'b00;
                    instruction <= 2'b10;
                    WE <= 1'b1;
                    inputData <= A3;
                    regselect <= 2'b10; // Write result to A3
                    inputData <= A4;
                    regselect <= 2'b11; // Write result to A4
                end
                2'b11: begin // mul
                    regselect <= 2'b00;
                    instruction <= 2'b01;
                    WE <= 1'b1;
                    inputData <= A3;
                    regselect <= 2'b10; // Write result to A3
		    inputData <= A4;
                    regselect <= 2'b11; // Write result to A4
                end
            endcase
        end
    end
endmodule
