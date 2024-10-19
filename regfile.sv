module regfile(input logic clk,
               input logic reset,
               input logic[4:0] rs1,
               input logic[4:0] rs2,
               input logic[4:0] rd,
               input logic write_enable,
               output logic[31:0] data1,
               output logic[31:0] data2,
               input logic[31:0] rd_data);

    // This line declares an array of 32 32-bit registers
    logic[31:0] registers[31:0]; // Technically don't need x0 but this is simpler and it'll get optimized out

    // Complete the module so that rs1 and rs2 select which register appears on data1 and data2,
    // and rd_data is written into register rd on the rising edge of the clock, if write_enable is true
    // All registers should be 0 after reset.

    always_ff @ ( posedge clk ) 
    begin
      if (reset == 1) begin
        for (int i = 0; i < 32; i++) begin
            registers[i] <= 32'h0;
        end
      end
      else if (write_enable == 1 & rd != 5'b00000) begin
        registers[rd] <= rd_data;
      end
    end

    assign data1 = registers[rs1];
    assign data2 = registers[rs2];

endmodule

