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
    assign byte_num = addr & 32'h3;     // Byte number (byte inside mem slot) = addr mod 4
    
    /*
    // Case statement for assigning where data should go inside a memory word
    always_comb begin
        case (byte_num)
            2'b00   : byte_bit_range = [7:0];      // Byte 0 = [0:7]
            2'b01   : byte_bit_range = ;      // Byte 1 = [8:15]
            2'b10   : byte_bit_range = ;      // Byte 2 = [16:23]
            2'b11   : byte_bit_range = ;      // Byte 3 = [24:31]
            default : byte_bit_range = 32'b0;
        endcase
    end
    */

    always_ff @ ( posedge clk ) 
    begin
      // Store byte
      if (write_enable == 1 && data_in[31:8] === 24'hx) begin
        $display("BYTE STORE!!!**********");
        // Write data_in (rs2) to addr (specified by rs1 + offset)
        memory[word_num][byte_num << 3] <= data_in[7:0];     // Byte num * 8 to get starting bit
      end
      // Store half word
      else if (write_enable == 1 && data_in[31:16] === 16'hx) begin
        $display("HALFWORD STORE!!!**********");
        $display("Byte num %b", byte_num<<3);
        $display("DATA INSIDE: %h", data_in[15:0]);
        memory[word_num][byte_num << 3] <= data_in[15:0];
      end
      // Store word
      else begin
        $display("WORD STORE!!!**********");
        memory[word_num] <= data_in;
      end

      // $display("Mem Word 8: %h", memory[word_num + 2]);
      // $display("Mem Word 4: %h", memory[word_num + 1]);
      // $display("Mem Word 0: %h", memory[word_num]);
      // $display("Mem Word -4: %h", memory[word_num - 1]);
      // $display("Mem Word -8: %h", memory[word_num - 2]);
      // Load byte
      
      // Load half word

      // Load word
      
      // Load byte unsigned

      // Load half word unsigned

/*
      else begin
        // Write data inside addr (specified by rs1 + offset) to rd (data output)
        data <= memory[word_num][byte_num << 3];
      end
      */

    end
    // Remember that the address is a *byte* address, but the memory array stores *words*.

  assign data = memory[word_num];   // Use for testing

endmodule

