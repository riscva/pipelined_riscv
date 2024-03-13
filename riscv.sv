`default_nettype none

module riscv(       input  logic         clk, reset,
                    output logic [31:0]  PCF,
                    input  logic [31:0]  InstrF,
                    output logic         MemWriteM,
                    output logic [31:0]  ALUResultM, WriteDataM,
                    output logic [2:0]   MemControlM,
                    input  logic [31:0]  ReadDataM);


    controller c( .* );

    datapath dp( .* );

    hazard hu( .* );


    // Connecting wires //

    logic [4:0]     RdE, RdM, RdW;
    logic [6:0]     opD;
    logic [2:0]     funct3D;
    logic           funct7b5D;
    logic [2:0]     ImmSrcD;
    logic           ZeroE;          
    logic           PCSrcE;         
    logic [2:0]     ALUControlE;
    logic           ALUSrcAE, ALUSrcBE;
    logic           ResultSrcEb0;
    logic           RegWriteM;
    logic           RegWriteW;
    logic [1:0]     ResultSrcW;
    logic [1:0]     ForwardAE, ForwardBE;
    logic           FlushE, FlushD;
    logic           StallD, StallF;
    logic [4:0]     Rs1D, Rs2D, Rs1E, Rs2E;
    

    logic       _unused_ok = &{1'b0,
                                        // This wire will always be 0 so it won't use
                               1'b0};        // simulation runtime. The "unused" wire supresses warnings


endmodule
