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

    // Checking load/alu immediates
    assert(imm32 == {fill, 5'b01100}) else $error("Immediate extension did not work: Expected -20 but got %b !", imm32);
    #100;

    instr = 32'h001xxxX3;
    #5;
    assert(imm32 == 32'h01) else $error("Immediate extension did not work: Expected 1 but got %h !", imm32);


    instr = 32'h800xxxX3;
    #5;
    assert(imm32 == 32'hfffff800) else $error("Immediate extension did not work: Expected fffff800 but got %h !", imm32);
    
    // Checking store immediates
    instr = 32'h0c322423;
    #5;
    assert(imm32 == 32'hc8) else $error("Immediate extension did not work: Expected c8 but got %h !", imm32);

    instr = 32'h1b222a23;
    #5;
    assert(imm32 == 32'h1b4) else $error("Immediate extension did not work: Expected 1b4 but got %h !", imm32);

    instr = 32'hfe344023;
    #5;
    assert(imm32 == 32'hffffffe0) else $error("Immediate extension did not work: Expected fe0 but got %h !", imm32);

    instr = 32'h7d523a23;
    #5;
    assert(imm32 == 32'h7d4) else $error("Immediate extension did not work: Expected 7d4 but got %h !", imm32);

    instr = 32'h00012023;
    #5;
    assert(imm32 == 32'h0) else $error("Immediate extension did not work: Expected 0 but got %h !", imm32);


    $display("Test complete!");
    $finish;
  end

endmodule

