module decoder(input logic[31:0] instr,
               input logic[31:0] imm32,
               input logic[31:0] data2,
               output logic[3:0] alu_operation,
               output logic[31:0] alu_operand);

  // Decodes instruction to determine ALU operation 
  //    and determines if immediate is being used or not

  // Normally, find operation with bits 30, 14:12 of instruction
  // And find immediate with bit 5 of instruction 
  
  // If opcode = 0x03 (load), set ALU operation to ADD and use immediate
  logic load_check;
  assign load_check = instr[6:0] == 7'h03 ? 1 : 0;

  always_comb begin
    if (load_check) 
    begin
      alu_operation = 4'b0000;
      alu_operand = im_inst.imm32;
    end else 
    begin 
      alu_operation = {instr[30], instr[14:12]};
      alu_operand = instr[5] == 1 ? data2 : imm32;
    end
  end
    
endmodule
