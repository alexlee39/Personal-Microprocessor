module prog1test_tb();

bit clk, reset;
wire done;
logic error[2];

top_level DUT(
  .clk,
  .reset,
  .done);


always begin
  #5 clk = 1;
  #5 clk = 0;
end

initial begin
    // DUT.dm1.core[1] = 8'b00001000;
    // DUT.rf1.core[1] = 1;
    // DUT.rf1.core[2] = 2;
    // DUT.dm1.core[9] = 3;
    // DUT.rf1.core[0] = 8'b00000000; 
    // DUT.rf1.core[1] = 8'b00000000;
    // DUT.rf1.core[3] = 8'b00000010; //reg3 = 2
    // DUT.rf1.core[2] = 8'b00000001;
    #10ns reset   = 1'b1;          // pulse request to DUT
    #10ns reset   = 1'b0;
    #10ns wait(done);
    $display("r0 contains");
    $displayb(DUT.rf1.core[0]);
    $display("r1 contains");
    $displayb(DUT.rf1.core[1]);
    $display("r3 contains");
    // $displayb(DUT.rf1.core[2]);
    $displayb(DUT.rf1.core[3]);
    // $displayb(DUT.rf1.core[4]);
    // $displayb(DUT.rf1.core[5]);
    // $displayb(DUT.rf1.core[6]);
    $display("r7 contains");
    $displayb(DUT.rf1.core[7]);

  $stop;
end    

endmodule