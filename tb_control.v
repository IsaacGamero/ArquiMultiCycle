`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2026 13:08:45
// Design Name: 
// Module Name: tb_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_control();
  reg clk, reset;
  reg [6:0] op;
  reg [2:0] funct3;
  reg funct7b5;
  reg Zero;

  wire [1:0] ImmSrc;
  wire [1:0] ALUSrcA, ALUSrcB;
  wire [1:0] ResultSrc;
  wire AdrSrc;
  wire [2:0] ALUControl;
  wire IRWrite, PCWrite;
  wire RegWrite, MemWrite;
  
  controller dut(.clk(clk), .reset(reset), .op(op), .funct3(funct3),
  .funct7b5(funct7b5), .Zero(Zero), .ImmSrc(ImmSrc), .ALUSrcA(ALUSrcA),
  .ALUSrcB(ALUSrcB), .ResultSrc(ResultSrc), .AdrSrc(AdrSrc), .ALUControl(ALUControl),
  .IRWrite(IRWrite), .PCWrite(PCWrite),.RegWrite(RegWrite), .MemWrite(MemWrite));
  
  always #5 clk=~clk;
  
  initial begin
      clk = 0; reset = 1;
      #10;
      reset = 0;
      
      //SUB
      op = 7'b0110011;
      funct3 = 3'b000;
      funct7b5 = 1;
      Zero = 0;
      #10; // FETCH
      #10; // DECODE
      #10; // EXECUTER
      #10; // ALUWB
      #10; // FETCH
      
      //XORI
      reset = 1;
      #10;
      reset = 0;
      op = 7'b0010011;
      funct3 = 3'b100;
      funct7b5 = 0;
      Zero = 0;
      #10; // FETCH
      #10; // DECODE
      #10; // EXECUTEI
      #10; // ALUWB
      #10; // FETCH
      
      // LW 
      reset = 1;
      #10;
      reset = 0;
      op = 7'b0000011;
      funct3 = 3'b010;
      funct7b5 = 0;
      Zero = 0;
      #10; // FETCH
      #10; // DECODE
      #10; // MEMADR
      #10; // MEMREAD
      #10; // MEMWB
      #10; // FETCH
      
      // SW
      reset = 1;
      #10;
      reset = 0;
      op = 7'b0100011;
      funct3 = 3'b010;
      funct7b5 = 0;
      Zero = 0;
      #10; // FETCH
      #10; // DECODE
      #10; // MEMADR
      #10; // MEMWRITE
      #10; // FETCH siguiente
      
      
      // JAL
      reset = 1;
      #10;
      reset = 0;
      op = 7'b1101111;
      funct3 = 3'b000;
      funct7b5 = 0;
      Zero = 0;
      #10; // FETCH
      #10; // DECODE
      #10; // JAL
      #10; // FETCH
      
      // BEQ tomado
      reset = 1;
      #10;
      reset = 0;
      op = 7'b1100011;
      funct3 = 3'b000;
      funct7b5 = 0;
      Zero = 1;
      #10; // FETCH
      #10; // DECODE
      #10; // BEQ
      #10; // FETCH
      
      // BEQ no tomado
      reset = 1;
      #10;
      reset = 0;
      op = 7'b1100011;
      funct3 = 3'b000;
      funct7b5 = 0;
      Zero = 0;
      #10; // FETCH
      #10; // DECODE
      #10; // BEQ
      #10; // FETCH
      
      #20
      
      $finish;
  	end
  	
  initial begin
	$dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  
endmodule
