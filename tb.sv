module testbench();

    logic           clk;
    logic           reset;
    logic [31:0]    WriteDataM, DataAdrM;
    logic           MemWriteM;

    // instantiate device to be tested
    top dut (clk, reset,WriteDataM, DataAdrM, MemWriteM);

    // initialize testbench
    initial
        begin
            reset <= 1; # 22; reset <= 0;
        end

    // generate clock to sequence tests
    always
        begin
            clk <= 1; #5; clk <= 0; #5;
        end

    // check results
    always @(negedge clk)
        begin
            if (MemWriteM) begin
                if (DataAdrM === 100 & WriteDataM === 25) begin
                    $display("Simulation succeeded");
                    $stop;
                end else if (DataAdrM !== 96) begin
                    $display("Simulation failed");
                    $stop;
                end
            end
        end

endmodule
