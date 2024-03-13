`default_nettype none

module top(input  logic         clk, reset,
           output logic [31:0]  WriteDataM, DataAdrM,
           output logic         MemWriteM);


    logic [31:0] PCF, InstrF, ReadDataM;
    logic [2:0]  MemControlM;

    // instantiate processor and memories
    riscv rv( .ALUResultM(DataAdrM), .* );

    imem im( .a(PCF), .rd(InstrF) );
    dmem dm( .clk(clk), .we(MemWriteM), .a(DataAdrM), .wd(WriteDataM), .Control(MemControlM), .rd(ReadDataM) );

endmodule 
