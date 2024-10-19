// Program counter
module pc(input logic clk,
          input logic reset,
          output logic[31:0] addr);

  // Make the program counter start at 0, and increment by 4 on every clock cycle
  always_ff @( posedge clk ) 
  begin
    if (reset == 1) begin
      addr <= '0;
    end
    else begin
      addr <= addr + 4;
    end
  end

endmodule

