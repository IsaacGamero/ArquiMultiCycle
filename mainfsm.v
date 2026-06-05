// riscvmulti.v main FSM module
module mainfsm(input  clk,
               input  reset,
               input  [6:0] op,
               output [1:0] ALUSrcA, ALUSrcB,
               output [1:0] ResultSrc,
               output AdrSrc,  
               output IRWrite, PCUpdate,
               output RegWrite, MemWrite,
               output [1:0] ALUOp,
               output Branch);
  
  //COMPLETAR
  parameter FETCH    = 4'b0000;
  parameter DECODE   = 4'b0001;
  parameter MEMADR   = 4'b0010;
  parameter MEMREAD  = 4'b0011;
  parameter MEMWB    = 4'b0100;
  parameter MEMWRITE = 4'b0101;
  parameter EXECUTER = 4'b0110;
  parameter ALUWB    = 4'b0111;
  parameter EXECUTEI = 4'b1000;
  parameter JAL      = 4'b1001;
  parameter BEQ      = 4'b1010;
  parameter UNKNOWN  = 4'b1100;
   
  reg [3:0] state, nextstate;
  reg [14:0] controls;
  
  // state register
  always @(posedge clk or posedge reset)
    if (reset) state <= FETCH;
    else state <= nextstate;
  
  // next state logic
  // COMPLETAR
  always @*
    case(state)
      FETCH:                     nextstate = DECODE;
      DECODE: casez(op)
                7'b0000011:      nextstate = MEMADR; // lw
                7'b0100011:      nextstate = MEMADR; // sw
                7'b0110011:      nextstate = EXECUTER; //R-type
                7'b0010011:      nextstate = EXECUTEI; //I-type ALU
                7'b1101111:      nextstate = JAL; // jal
                7'b1100011:      nextstate = BEQ; // beq
                default:         nextstate = UNKNOWN;
              endcase
      MEMADR: casez(op)
              7'b0000011:      nextstate = MEMREAD; // lw
              7'b0100011:      nextstate = MEMWRITE; // sw
              default:         nextstate = UNKNOWN;
              endcase
      MEMREAD:  nextstate = MEMWB;
      MEMWB:    nextstate = FETCH;
      MEMWRITE: nextstate = FETCH;
      EXECUTER: nextstate = ALUWB;
      EXECUTEI: nextstate = ALUWB;
      JAL:      nextstate = ALUWB;
      ALUWB:    nextstate = FETCH;
      BEQ:      nextstate = FETCH;
      default:  nextstate = FETCH;
    endcase
    
  // state-dependent output logic
  // COMPLETAR
  always @*
    case(state)
      FETCH: 	controls = 15'b00_10_10_0_1100_00_0;
      DECODE:   controls = 15'b0_01_01_00_0_0_0_0_0_00_0;
      MEMADR:   controls = 15'b0_10_01_00_0_0_0_0_0_00_0;
      MEMREAD:  controls = 15'b0_00_00_01_1_0_0_0_0_00_0;
      MEMWB:    controls = 15'b0_00_00_01_0_0_0_1_0_00_0;
      MEMWRITE: controls = 15'b0_00_00_00_1_0_0_0_1_00_0;
      EXECUTER: controls = 15'b0_10_00_00_0_0_0_0_0_10_0;
      EXECUTEI: controls = 15'b0_10_01_00_0_0_0_0_0_10_0;
      ALUWB:    controls = 15'b0_00_00_10_0_0_0_1_0_00_0;
      JAL:      controls = 15'b0_01_01_00_0_0_1_0_0_00_0;
      BEQ:      controls = 15'b0_10_00_10_0_0_0_0_0_01_1;
      default: 	controls = 15'bxx_xx_xx_x_xxxx_xx_x;
    endcase

  assign {ALUSrcA, ALUSrcB, ResultSrc, AdrSrc, IRWrite, PCUpdate, 
  RegWrite, MemWrite, ALUOp, Branch} = controls;
endmodule