`default_nettype none

module riscv(       input  logic         clk, reset,
                    output logic [31:0]  PCF,
                    input  logic [31:0]  InstrF,
                    output logic         MemWriteM,
                    output logic [31:0]  ALUResultM, WriteDataM,
                    input  logic [31:0]  ReadDataM);


    controller c(clk, reset,
                 opD, funct3D, funct7b5D, ImmSrcD,
                 FlushE, ZeroE, PCSrcE, ALUControlE, ALUSrcAE, ALUSrcBE, ResultSrcEb0,
                 MemWriteM, RegWriteM, 
                 RegWriteW, ResultSrcW);

    datapath dp(clk, reset, PCF, InstrF,
                opD, funct3D, funct7b5D, ImmSrcD,
                ALUControlE, ALUSrcAE, ALUSrcBE, ForwardAE, ForwardBE, PCSrcE, ZeroE,
                ALUResultM, WriteDataM,ReadDataM,
                RegWriteW,ResultSrcW,
                FlushE, FlushD, StallD, StallF, Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW);

    hazard hu(  Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
                PCSrcE, ResultSrcEb0, RegWriteM, RegWriteW,
                ForwardAE, ForwardBE,
                StallF, StallD, FlushD, FlushE);

    

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
