// riscvmulti.v datapath module
module datapath(input  clk, reset,
                input  [2:0]  ImmSrc,
                input  [1:0]  ALUSrcA, ALUSrcB, 
                input  [1:0]  ResultSrc, 
				input  AdrSrc,
                input  IRWrite, PCWrite,
                input  RegWrite, MemWrite,
                input  [2:0]  alucontrol,
                output [6:0]  op,
                output [2:0]  funct3,
                output funct7b5,
                output Zero,
                output [31:0] Adr,
                input  [31:0] ReadData,
                output [31:0] WriteData);
  
  wire [31:0] PC, OldPC, Instr, immext, ALUResult;
  wire [31:0] SrcA, SrcB, RD1, RD2, A;
  wire [31:0] Result, Data, ALUOut;
  
  // next PC logic
  flopenr #(32) pcreg(.clk(clk), .reset(reset), .en(PCWrite), .d(Result), .q(PC));
  flopenr #(32) oldpcreg(.clk(clk), .reset(reset), .en(IRWrite), .d(PC), .q(OldPC));
  
  // memory logic
  mux2    #(32) adrmux(.d0(PC), .d1(Result), .s(AdrSrc), .y(Adr));
  flopenr #(32) ir(.clk(clk), .reset(reset), .en(IRWrite), .d(ReadData), .q(Instr));
  flopr   #(32) datareg(.clk(clk), .reset(reset), .d(ReadData), .q(Data));
 
  // register file logic
  regfile       rf(.clk(clk), .we3(RegWrite), .a1(Instr[19:15]), .a2(Instr[24:20]), 
                   .a3(Instr[11:7]), .wd3(Result), .rd1(RD1), .rd2(RD2));
  extend        ext(.instr(Instr[31:7]), .immsrc(ImmSrc), .immext(immext));
  flopr  #(32)  srcareg(.clk(clk), .reset(reset), .d(RD1), .q(A));
  flopr  #(32)  wdreg(.clk(clk), .reset(reset), .d(RD2), .q(WriteData));

  // ALU logic
  mux3   #(32)  srcamux(.d0(PC), .d1(OldPC), .d2(A), .s(ALUSrcA), .y(SrcA));
  mux3   #(32)  srcbmux(.d0(WriteData), .d1(immext), .d2(32'd4), .s(ALUSrcB), .y(SrcB));
  alu           alu_inst(.a(SrcA), .b(SrcB), .alucontrol(alucontrol), .result(ALUResult), .zero(Zero));
  flopr  #(32)  aluoutreg(.clk(clk), .reset(reset), .d(ALUResult), .q(ALUOut));
  mux4   #(32)  resmux(.d0(ALUOut), .d1(Data), .d2(ALUResult), .d3(imnext),.s(ResultSrc), .y(Result));
  
  // outputs to control unit
  assign op       = Instr[6:0];
  assign funct3   = Instr[14:12];
  assign funct7b5 = Instr[30];
endmodule