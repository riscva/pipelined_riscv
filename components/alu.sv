`default_nettype none

module alu #(parameter N = 8)
            (input  logic [N-1:0]   a, b,
             input  logic [2:0]     ALUControl,
             output logic [N-1:0]   ALUResult,
             output logic           Zero
             );

    logic [N-1:0] condinvb, sum;
    logic         z, v;
    logic         isAddSub;

    assign condinvb = ALUControl[0] ? ~b : b;
    assign sum = a + condinvb + ALUControl[0];
    assign isAddSub = ~ALUControl[2] & ~ALUControl[1] | ~ALUControl[1] & ALUControl[0];

    always_comb
        case(ALUControl)
            3'b000:     ALUResult = sum;                // add
            3'b001:     ALUResult = sum;                // subtract
            3'b010:     ALUResult = a & b;              // and
            3'b011:     ALUResult = a | b;              // or
            3'b100:     ALUResult = a ^ b;              // xor
            3'b101:     ALUResult = sum[N-1] ^ v;       // slt
            3'b110:     ALUResult = a << b[4:0];        // sll
            3'b111:     ALUResult = a >> b[4:0];        // srl
            default:    ALUResult = 32'bx;
        endcase

    assign  Zero = (ALUResult == '0);
    //assign  Negative = ALUResult[N-1];
    //assign  Carry = (~ALUControl[1]) & Cout;
    assign  v = (isAddSub) & (sum[N-1] ^ a[N-1]) & ~(ALUControl[0] ^ a[N-1] ^ b[N-1]);

endmodule
