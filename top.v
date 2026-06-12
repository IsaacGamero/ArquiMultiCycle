// riscvmulti.v top module
// Connects the processor and memory
module top(input  clk, reset, 
           output [31:0] WriteData, DataAdr, 
           output MemWrite);
  wire [31:0] ReadData;
  
  // instantiate processor and memories
  riscvmulti rvmulti(clk, reset, MemWrite, DataAdr, 
                     WriteData, ReadData);
  mem mem(clk, MemWrite, DataAdr, WriteData, ReadData);
endmodule