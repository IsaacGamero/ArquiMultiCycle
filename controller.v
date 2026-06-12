// riscvmulti.v controller module
module controller(input  clk,
                  input  reset,  
                  input  [6:0] op,
                  input  [2:0] funct3,
                  input  funct7b5,
                  input  Zero,
                  output [1:0] ImmSrc,
                  output [1:0] ALUSrcA, ALUSrcB,
                  output [1:0] ResultSrc, 
                  output AdrSrc,
                  output [2:0] ALUControl,
                  output IRWrite, PCWrite, 
                  output RegWrite, MemWrite);

  wire [1:0] ALUOp;
  wire       Branch, PCUpdate;
  
  // Main FSM
  mainfsm fsm(clk, reset, op,
              ALUSrcA, ALUSrcB, ResultSrc, AdrSrc, 
              IRWrite, PCUpdate, RegWrite, MemWrite, 
              ALUOp, Branch);
  
  // ALU Decoder
  aludec  ad(op[5], funct3, funct7b5, ALUOp, ALUControl);
  
  // Instruction Decoder
  instrdec id(op, ImmSrc);
  
  // Branch logic
  assign PCWrite = (Branch & Zero) | PCUpdate;
endmodule