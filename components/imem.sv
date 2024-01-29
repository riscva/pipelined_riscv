`default_nettype none

module imem(input  logic [31:0] a,
            output logic [31:0] rd);


    logic [31:0] RAM [63:0];

    initial begin
        $readmemh("riscvtest.mem", RAM);    // Vivado requires .mem files for memory initialisation
    end

    assign rd = RAM[{2'b0, a[31:2]}];   // word aligned



    logic       _unused_ok = &{1'b0,
                               a[1:0],         // This wire will always be 0 so it won't use
                               1'b0};        // simulation runtime. The "unused" wire supresses warnings


endmodule
