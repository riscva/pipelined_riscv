`default_nettype none

module controller(  input   logic            clk, reset,

                    // Decode stage control signals
                    input   logic [6:0]     opD,
                    input   logic [2:0]     funct3D,
                    input   logic           funct7b5D,
                    output  logic [2:0]     ImmSrcD,

                    // Execute stage control signals
                    input   logic           FlushE,         // from hazard unit
                    input   logic           ZeroE,          // from the ALU
                    output  logic           PCSrcE,         // for datapath and hazard unit
                    output  logic [2:0]     ALUControlE,
                    output  logic           ALUSrcAE, ALUSrcBE,
                    output  logic           ResultSrcEb0,   // for hazard unit

                    // Memory stage control signals
                    output  logic           MemWriteM,
                    output  logic           RegWriteM,      // for hazard unit
                    output  logic [2:0]     MemControlM,

                    // Writeback stage control signals
                    output  logic           RegWriteW,      // for datapath and hazard unit
                    output  logic [1:0]     ResultSrcW
                    );


    // Pipelined Internal control signals
    logic       RegWriteD, RegWriteE;
    logic [1:0] ResultSrcD, ResultSrcE, ResultSrcM;
    logic       MemWriteD, MemWriteE;
    logic       JumpD, JumpE;
    logic       BranchD, BranchE;
    logic [1:0] ALUOpD;
    logic [2:0] ALUControlD;
    logic [2:0] MemControlD, MemControlE;
    logic       ALUSrcAD, ALUSrcBD;


    maindec md(opD, ResultSrcD, MemWriteD, BranchD,
                ALUSrcAD, ALUSrcBD, RegWriteD, JumpD, ImmSrcD, ALUOpD);

    aludec ad (opD[5], funct3D, funct7b5D, ALUOpD, ALUControlD);

    assign MemControlD = funct3D;

    // Execute stage pipeline control register
    floprc #(14)    controlRegE(clk, reset, FlushE,
                                {RegWriteD, ResultSrcD, MemWriteD, JumpD, BranchD, ALUControlD, ALUSrcAD, ALUSrcBD, MemControlD},
                                {RegWriteE, ResultSrcE, MemWriteE, JumpE, BranchE, ALUControlE, ALUSrcAE, ALUSrcBE, MemControlE});

    assign PCSrcE = BranchE & ZeroE | JumpE;
    assign ResultSrcEb0 = ResultSrcE[0];

    // Memory stage pipeline control register
    flopr #(7)      controlRegM(clk, reset,
                                {RegWriteE, ResultSrcE, MemWriteE, MemControlE},
                                {RegWriteM, ResultSrcM, MemWriteM, MemControlM});

    // Writeback stage pipeline control register
    flopr #(3)      controlRegW(clk, reset,
                                {RegWriteM, ResultSrcM},
                                {RegWriteW, ResultSrcW});

endmodule
