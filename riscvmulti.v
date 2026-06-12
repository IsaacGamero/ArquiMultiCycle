// riscvmulti.v processor wrapper
module riscvmulti(input  clk, reset,
                  output MemWrite,
                  output [31:0] Adr, WriteData,
                  input  [31:0] ReadData);
  
  wire        RegWrite, jump;
  wire [1:0]  ResultSrc, ImmSrc;
  wire [2:0]  ALUControl;
  wire 	      PCWrite;
  wire 	      IRWrite;
  wire [1:0]  ALUSrcA;
  wire [1:0]  ALUSrcB;
  wire		  AdrSrc;
  wire        Zero;
  wire [6:0]  op;
  wire [2:0]  funct3;
  wire        funct7b5;
  
  controller c(clk, reset, op, funct3, funct7b5, Zero, 
               ImmSrc, ALUSrcA, ALUSrcB,
               ResultSrc, AdrSrc, ALUControl,
               IRWrite, PCWrite, RegWrite, MemWrite);
  
  datapath   dp(clk, reset, 
                ImmSrc, ALUSrcA, ALUSrcB,
                ResultSrc, AdrSrc, IRWrite, PCWrite, 
                RegWrite, MemWrite, ALUControl, op, funct3, 
                funct7b5, Zero, Adr, ReadData, WriteData);
endmodule