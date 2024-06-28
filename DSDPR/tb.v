module tb;
    reg clk;
    reg reset;
    reg [1:0] operation; // 00: Load, 01: Store, 10: Sum, 11: Product
    reg [8:0] addr;
    wire [511:0] data;
    reg [511:0] data_reg;
    reg mem_read;
    reg mem_write;

    tb tb (
        .clk(clk),
        .reset(reset),
        .operation(operation),
        .add(addr),
        .data(data)
    );

    assign data = (mem_read) ? data_reg : 512'bz;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        reset = 1;
        mem_read = 0;
        mem_write = 0;
        operation = 2'b00;
        addr = 9'b0;
        data_reg = 512'b0;
        #20;
        reset = 0;

       
        mem_read = 0;

        // Test Sum operation
        // Sum A1 and A2 (both initialized to the same value), result should be in A3 and A4
        operation = 2'b10;
        #20;

        // Test Product operation
        // Multiply A1 and A2, result should be in A3 and A4
        operation = 2'b11;
        #40;

        // Edge case: Load/store at the highest address (boundary condition)
        addr = 9'b111111111; // Address 511
        // Load data into A2
        data_reg = 512'h11223344556677889900AABBCCDDEEFF00112233445566778899AABBCCDDEEFF;
        mem_read = 1;
        operation = 2'b00;
        #20;
        mem_read = 0;

        // Store data from A2 to address 511
        operation = 2'b01;
        #20;

        // Verify stored data (load it back into a dummy register)
        mem_read = 1;
        operation = 2'b00;
        #20;
        mem_read = 0;

        // Finish the simulation
        $finish;
    end

    initial begin
        $monitor("Time: %0d, operation: %b, address: %b, data: %h", $time, operation, addr, data);
    end

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

endmodule
