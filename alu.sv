
module alu(input logic[31:0] operand1,
           input logic[31:0] operand2,
           input logic[3:0] operation, // This is {imm7[5], imm3}, other bits of imm7 are always 0 for RV32I
           output logic[31:0] result);

  // Complete this module to compute the correct result for the specified operations
  // Note that not all operations are specified; you can leave the output 0 or undefined in this case

  logic signed [31:0] op1_s;
  logic signed [31:0] op2_s;

  assign op1_s = operand1;
  assign op2_s = operand2;

  always_comb
    case(operation)
        4'b0000   : result = operand1 + operand2;     //add
        4'b0001   : result = operand1 << operand2;    //sll (shift left)
        4'b0010   : result = {31'h0, op1_s < op2_s};           //slt (set less than)
        4'b0011   : result = {31'h0, operand1 < operand2};     //sltu (set less than, unsigned)
        4'b0100   : result = operand1 ^ operand2;     //xor
        4'b0101   : result = operand1 >> operand2;    //srl (shift right)
        4'b0110   : result = operand1 | operand2;     //bitwise OR
        4'b0111   : result = operand1 & operand2;     //bitwise AND
        4'b1000   : result = op1_s - op2_s;           //sub (signed)
        4'b1101   : result = op1_s >>> op2_s;       //sra (shift right arithmetic, signed)      
      default : result = 32'b0;
  endcase

endmodule
