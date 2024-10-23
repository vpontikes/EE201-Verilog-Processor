module processor(input logic clk,
                 input logic reset);

  // Instantiate your submodules here and connect them together to build a
  // processor that can execute ALU operations!

  // You'll need to write a little bit of logic for the "controller" (e.g.,
  // determining whether to use an immediate or register for the second
  // operand).  In future assignments it will get more complicated, and we'll
  // wrap it up into its own module.

  // Define variables
  logic[31:0] addr;
  logic[31:0] instr;
  logic write_enable_rf = 1;
  logic[31:0] data1;
  logic[31:0] data2;
  logic[31:0] rd_data;
  logic[31:0] imm32;
  logic[31:0] result;
  logic write_enable_store;
  logic[31:0] data;
//   logic[3:0] alu_operation;
//   logic[31:0] alu_operand; 

  // Instantiate and connect to program counter
  pc pc_inst(.clk(clk), 
            .reset(reset), 
            .addr(addr));

  // Instantiate and connect to program memory
  progmem pm_inst(.addr(pc_inst.addr),
                  .instr(instr));

  // If opcode = 0x23 (store), store write_enable = 1 
  assign write_enable_store = pm_inst.instr[6:0] == 7'h23 ? 1 : 0;

  // Instatiate and connect to reg file
  regfile rf_inst(.clk(clk),
                  .reset(reset),
                  .rs1(pm_inst.instr[19:15]),
                  .rs2(pm_inst.instr[24:20]),
                  .rd(pm_inst.instr[11:7]),
                  .write_enable(write_enable_rf),
                  .data1(data1),
                  .data2(data2),
                  .rd_data(alu_inst.result));
  
  // Instantiate and connect to imm extension
  immextend im_inst(.instr(pm_inst.instr),
                    .imm32(imm32));

  // Instantiate and connect to datamem
  datamem dm_inst(.clk(clk),
                  .addr(addr), 
                  .write_enable(write_enable_store),
                  .data(data),
                  .data_in(rf_inst.data2));

  // Instantiate and connect to decoder
//   decoder decode_inst(.instr(pm_inst.instr),
//                       .imm32(im_inst.imm32),
//                       .data2(rf_inst.data2),
//                       .alu_operation(alu_operation),
//                       .alu_operand(alu_operand));

  logic[3:0] operation;
  logic[31:0] opr2;
  
  // If opcode = 0x03 (load), set ALU operation to ADD and use immediate
  logic load_check;
  assign load_check = pm_inst.instr[6:0] == 7'h03 ? 1 : 0;

  always_comb begin
    if (load_check) 
    begin
      operation = 4'b0000;
      opr2 = im_inst.imm32;
    end else 
    begin 
      operation = {pm_inst.instr[30], pm_inst.instr[14:12]};
      opr2 = pm_inst.instr[5] == 1 ? rf_inst.data2 : im_inst.imm32;
    end
  end
  
  // Instatiate and connect to alu
  alu alu_inst(.operand1(rf_inst.data1),
               .operand2(opr2), //decode_inst.alu_operand
               .operation(operation), //decode_inst.alu_operation
               .result(result));

endmodule

