`default_nettype none

module regfile(input  logic         clk,
               input  logic         we3,
               input  logic [4:0]   a1, a2, a3,
               input  logic [31:0]  wd3,
               output logic [31:0]  rd1, rd2);

    logic [31:0] rf[31:0];
    // Three ported register file
    // Read two ports combinationally (A1/RD1, A2/RD2)
    // Write third port on falling edge of clock (A3/WD3/WE3) to allow
    //   writing in first half and reading in second half of the cycle.
    // Register 0 hardwired to 0

    always_ff @(negedge clk)
        if (we3) rf[a3] <= wd3;

    assign rd1 = (a1 != 0) ? rf[a1] : 0;
    assign rd2 = (a2 != 0) ? rf[a2] : 0;

endmodule
