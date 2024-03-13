`default_nettype none

module dmem(input  logic        clk, we,
            input  logic [31:0] a, wd,
            input  logic [2:0]  Control,
            output logic [31:0] rd);


    logic [31:0] RAM[63:0];
    logic [31:0] memread;
    logic [1:0] size;   // 00: byte, 01: half, 10: word
    logic       u;      // whether output is unsigned

    assign {u,size} = Control;

    assign memread = RAM[{2'b0, a[31:2]}];   // word aligned. E.g. Address a = 8 is equivalent to dmem location 2.
                                        // (right shifted by 2). Memory is read asynchronously
                                        
    always_comb
        case(size)
            // load byte
            2'b00:      rd = u ? (rd = {{24{1'b0}}, memread[7:0]}) : (rd = {{24{memread[7]}}, memread[7:0]});
            // load half word
            2'b01:      rd = u ? (rd = {{16{1'b0}}, memread[15:0]}) : (rd = {{16{memread[15]}}, memread[15:0]});
            // default is load word
            default:    rd = memread;
        endcase                      


    always_ff @(posedge clk)
        if (we) RAM[{2'b0, a[31:2]}] <= wd;             



    logic       _unused_ok = &{1'b0,
                               a[1:0],         // This wire will always be 0 so it won't use
                               1'b0};        // simulation runtime. The "unused" wire supresses warnings
                               
endmodule
