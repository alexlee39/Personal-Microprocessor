module milestone2_quicktest_tb();

bit clk, reset;
wire done;
logic error[2];

top_level dut(
  .clk,
  .reset,
  .done);


always begin
  #5 clk = 1;
  #5 clk = 0;
end

initial begin
  //To write to reg: 
  //dut.rf1.core[0] = 8'b11110000; //Writes to reg0: 11110000
  dut.dm1.core[0] = 8'b00000000; //Writes 11110000, 30: 8'b00011110
  dut.dm1.core[1] = 8'b00011110;
  
  // dut.dm1.core[3] =	8'b11000011;
  // dut.dm1.core[4] = 8'b01010101;
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[0] = (8'b00000000 & 8'b00011110) != dut.dm1.core[2];
  // #10 error[1] = (8'b11000011 & 8'b01010101) != dut.dm1.core[5];
  #10 $display(error[0],,,error[1]);

  //Test Program 1:
  
  $stop;
end    

endmodule