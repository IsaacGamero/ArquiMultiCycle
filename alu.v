// riscvmulti.v ALU module
module alu(input  [31:0] a, b,
           input  [2:0]  alucontrol,
           output [31:0] result,
           output zero);
  wire [31:0] condinvb, sum;
  wire        v; // overflow
  wire        isAddSub; // true when is add or subtract operation
  reg [31:0] result;

  assign condinvb = alucontrol[0] ? ~b : b;
  assign sum = a + condinvb + alucontrol[0];
  assign isAddSub = ~alucontrol[2] & ~alucontrol[1] |
                    ~alucontrol[1] &  alucontrol[0];
                    
  always @*
    case (alucontrol)
      3'b000:  result = sum; // add
      3'b001:  result = sum; // subtract
      3'b010:  result = a & b; // and
      3'b011:  result = a | b; // or
      3'b100:  result = a ^ b; // xor
      3'b101:  result = sum[31] ^ v; // slt
      3'b110:  result = a << b[4:0]; // sll
      3'b111:  result = a >> b[4:0]; // srl
      default: result = 32'bx;
    endcase

  assign zero = (result == 32'b0);
  assign v = ~(alucontrol[0] ^ a[31] ^ b[31]) & (a[31] ^ sum[31]) & isAddSub;
endmodule