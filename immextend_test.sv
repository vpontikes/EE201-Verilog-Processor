`timescale 1ns/1ns // 1 tick is 1ns; use 1ns resolution (since we're not simulating wire delays or anything)

module immextend_enable_test;

  // Declare the signals that will connect to our device under test (DUT)
  logic[31:0] instr = {12'b111111101100, 20'b0};
  logic[31:0] imm32;
  logic[26:0] fill = '1;

  // Instantiate and connect the immextend module
  immextend dut(.instr(instr),
                .imm32(imm32));

  // Now run the test!
  initial begin
    // Dump all of the signals in the design to the VCD file which we can view with GTKwave
    $dumpfile("immextend.vcd");
    $dumpvars(0, immextend_enable_test); // Dump all of the signals in the DUT

    $display("Beginning of immextend test...");
    #5;
    
    // Check for correct extension
    assert(imm32 == {fill, 5'b01100}) else $error("Immediate extension did not work: Expected -20 but got %b !", imm32);
    #1000;

    $display("Test complete!");
    $finish;
  end

endmodule

