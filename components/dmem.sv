`default_nettype none

module dmem(input  logic        clk, we,
            input  logic [31:0] a, wd,
            output logic [31:0] rd);


    logic [31:0] RAM[63:0];

    logic       _unused_ok = &{1'b0,
                               a[1:0],         // This wire will always be 0 so it won't use
                               1'b0};        // simulation runtime. The "unused" wire supresses warnings

    assign rd = RAM[{2'b0, a[31:2]}];   // word aligned. E.g. Address a = 8 is equivalent to dmem location 2.
                                        // (right shifted by 2). Memory is read asynchronously


    always_ff @(posedge clk)
        if (we) RAM[{2'b0, a[31:2]}] <= wd;             

endmodule
