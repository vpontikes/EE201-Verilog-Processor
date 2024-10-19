module immextend(input logic[31:0] instr,
                 output logic[31:0] imm32);

  // Complete this module to extend the 12-bit immediate for an ALU operation
  // (such as addi) to 32 bits.  Make sure to use sign-extension so that
  // negative numbers stay negative when extended to 32 bits!

  // Need to edit this to add in extend for load/store!!
  logic[19:0] extend;
  logic sign_bit;
  
  assign sign_bit = instr[31];
  // assign extend = (sign_bit == 1) ? 20'b11111111111111111111 : 20'b00000000000000000000;

  // Use always_comb block so immediate is updated everytime a new value of instruction is passed
  // Always_comb block doesn't allow for constant selects inside, so warnings will come up but this works
  always_comb begin
    if (sign_bit == 1) begin
      extend = 20'b11111111111111111111;
    end else begin
      extend = 20'b00000000000000000000;
    end

    if (instr[6:0] == 7'h23) begin
      imm32 = {extend, instr[31:25], instr[11:7]};
    end else begin
      imm32 = {extend, instr[31:20]};
    end
  end
  
  // assign imm32 = (instr[6:0] == 7'h23) ? {extend, instr[31:25], instr[11:7]} : {extend, instr[31:20]};
  

endmodule
