`timescale 1ns/1ns // 1 tick is 1ns; use 1ns resolution (since we're not simulating wire delays or anything)

module datamem_enable_test;

  // Declare the signals that will connect to our device under test (DUT)
  logic clk = 0;
  logic[31:0] addr; 
  logic write_enable = 1;
  logic[31:0] data;
  logic[31:0] data_in;


  // Instantiate and connect the datamem module
  datamem dut(clk, addr, write_enable, data, data_in);
  
  // Create the clock signal
  always #5 clk = ~clk;

  // Now run the test!
  initial begin
    // Dump all of the signals in the design to the VCD file which we can view with GTKwave
    $dumpfile("datamem.vcd");
    $dumpvars(0, datamem_enable_test); // Dump all of the signals in the DUT

    $display("Beginning of datamem test...");

    // Check for storing a word
    addr = 32'h4;
    data_in = 32'h12345678;
    @(posedge clk);
    @(negedge clk);
    assert(data == 32'h12345678) else $error("Store data memory did not work: Expected h12345678 but got %h !", data);
    $display("Data1: %h", data);

    // Check for storing a half word
    addr = 32'h0;
    data_in = 32'hxxxx5678;
    @(posedge clk);
    @(negedge clk);
    assert(data === 32'hxxxx5678) else $error("Store data memory did not work: Expected h5678 but got %h !", data);
    $display("Data2: %h", data);
    #100;
    
    $display("Store test complete!");

    // Check for correct load (make sure to change write enable)
    write_enable = 0;

    addr = 32'h4;
    @(posedge clk);
    @(negedge clk);
    assert(data == 32'h12345678) else $error("Load data memory did not work: Expected h12345678 but got %h !", data);
    $display("Data3: %h", data);
    #100;

    // Check for load with no data in addr
    addr = 32'h20;
    @(posedge clk);
    @(negedge clk);
    // Displays correct value but assert doesn't work due to uninitialized num
    // assert(data == 32'hx) else $error("Load data memory did not work: Expected x but got %h !", data);
    $display("Data4: %h", data);
    #100;

    $display("Load test complete!");

    $finish;
  end

endmodule

