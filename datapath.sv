`default_nettype none

module datapath(    input   logic           clk, reset,

                    // Fetch stage
                    output  logic [31:0]    PCF,        // to IM's address
                    input   logic           InstrF,     // from IM's read data

                    // Decode stage
                    output  logic [6:0]     opD,
                    output  logic [2:0]     funct3D,
                    output  logic           funct7b5D,
                    input   logic [2:0]     ImmSrcD,

                    // Execute stage
                    input   logic [2:0]     ALUControlE,
                    input   logic           ALUSrcAE, ALUSrcBE,
                    input   logic           ForwardAE, ForwardBE,
                    input   logic           PCSrcE,                 // from control unit
                    output  logic           ZeroE,

                    // Memory Stage
                    // input   logic           MemWriteM,  // not needed as the signal goes from controller to DM
                    output  logic [31:0]    ALUResultM, WriteDataM, // dmem's WD and A inputs
                    input   logic [31:0]    ReadDataM,  // dmem's RD output 

                    // Writeback stage
                    input   logic           RegWriteW,
                    input   logic [1:0]     ResultSrcW,
                    
                    
                    // Hazard Unit signals
                    input   logic           FlushE, FlushD,
                    input   logic           StallD, StallF,
                    output  logic [4:0]     Rs1D, Rs2D, Rs1E, Rs2E,
                    output  logic [4:0]     RdE, RdM, RdW
                    );


    // Fetch stage signals
    logic [31:0]    PCNextF, PCPlus4F;
    // Decode stage signals
    logic [31:0]    InstrD;
    logic [31:0]    PCD, PCPlus4D;
    logic [4:0]     RD1D, RD2D;
    logic [4:0]     RdD;
    logic [31:0]    ImmExtD;
    // Execute stage signals
    logic [4:0]     RD1E, RD2E;
    logic [31:0]    PCE, ImmExtE, PCTargetE;
    logic [31:0]    PCPlus4E;
    logic [31:0]    SrcAE, SrcBE;
    logic [31:0]    ALUResultE;
    logic [31:0]    WriteDataE;
    logic [31:0]    FwdAE;

    // Memory stage signals
    logic [31:0]    PCPlus4M;
    // Writeback stage signals
    logic [31:0]    ALUResultW, ReadDataW, PCPlus4W;
    logic [31:0]    ResultW;


    // Fetch stage pipeline and logic
    mux2    #(32) pcmux(PCPlus4F, PCTargetE, PCSrcE, PCNextF);
    flopenr #(32) pcreg(clk, reset, ~StallF, PCNextF, PCF);
    adder         pcadd(PCF, 32'h4, PCPlus4F);

    // Decode stage pipeline register and logic 
    flopenrc #(96)  regD(clk, reset, ~StallD, FlushD,
                        {InstrF, PCF, PCPlus4F},
                        {InstrD, PCD, PCPlus4D});
    
    assign opD          = InstrD[6:0];
    assign funct3D      = InstrD[14:12];
    assign funct7b5D    = InstrD[30];
    assign Rs1D         = InstrD[19:15];
    assign Rs2D         = InstrD[24:20];
    assign RdD          = InstrD[11:7];

    regfile             rf(clk, RegWriteW, Rs1D, Rs2D, RdW, ResultW, RD1D, RD2D);
    extend              ext(InstrD[31:7], ImmSrcD, ImmExtD);

    // Execute stage pipeline register and logic
    floprc  #(121)      regE(clk, reset, FlushE,
                        {RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D},
                        {RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E});

    mux3    #(32)       fwdaemux(RD1E, ResultW, ALUResultM, ForwardAE, FwdAE);
    mux3    #(32)       fwdbemux(RD2E, ResultW, ALUResultM, ForwardBE, WriteDataE);
    mux2    #(32)       srcamux(FwdAE, 32'b0, ALUSrcAE, SrcAE);
    mux2    #(32)       srcbmux(WriteDataE, ImmExtE, ALUSrcBE, SrcBE);

    alu     #(32)       alu(SrcAE, SrcBE, ALUControlE, ALUResultE, ZeroE);
    adder               branchadd(PCE, ImmExtE, PCTargetE);

    // Memory stage pipleine register
    flopr   #(101)      regM(clk, reset,
                            {ALUResultE, WriteDataE, RdE, PCPlus4E},
                            {ALUResultM, WriteDataM, RdM, PCPlus4M});

    // Writeback stage pipeline register and logic
    flopr   #(101)      regW(clk, reset,
                            {ALUResultM, ReadDataM, RdM, PCPlus4M},
                            {ALUResultW, ReadDataW, RdW, PCPlus4W});

    mux3    #(32)       resultmux(ALUResultW, ReadDataW, PCPlus4W, ResultSrcW, ResultW);
    


    logic       _unused_ok = &{1'b0,
                                     // This wire will always be 0 so it won't use
                               1'b0};        // simulation runtime. The "unused" wire supresses warnings

endmodule
