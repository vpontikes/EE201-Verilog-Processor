module datamem(input logic clk,
               input logic[31:0] addr, // Note that not all of the address bits are valid, we don't have 4GB of memory!
               input logic write_enable,
               output logic[31:0] data,
               input logic[31:0] data_in);

    // Declare the memory array
    parameter int MEM_WORDS = 32;
    logic[31:0] memory[MEM_WORDS-1:0];

    // There's no reset for this module; the value will get updated as you write to them

    // Memory is specified by address, each memory slot can store one word
    // But, we have byte-addressable memory, so while each slot is one word, there are 
    //      4 possible addresses for each byte in a single memory slot

    logic[31:0] word_num;
    logic[1:0] byte_num;
    // logic[31:0] byte_bit_range;

    assign word_num = addr >> 2;        // Word number (memory slot) = addr div by 4
    // assign byte_num = addr & 32'h3;     // Byte number (byte inside mem slot) = addr mod 4
  
    always_ff @ ( posedge clk ) 
    begin
      // Store word
      if (write_enable == 1) begin
        memory[word_num] <= data_in;
      end 
      
      // Load word
      // else begin
      //   data <= memory[word_num];
      // end

    end
    // Remember that the address is a *byte* address, but the memory array stores *words*.

  assign data = memory[word_num];   // Use for testing

endmodule

