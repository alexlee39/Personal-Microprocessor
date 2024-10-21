// cache memory/register file
// default address pointer width = 2, for 8 registers [2:0]
module reg_file #(parameter pw=2)(
  input[7:0] dat_in, //This is the details we are writing to the register --> rslt...
  input      clk,
  input      wr_en,           // write enable
  input[pw:0] wr_addr,		  // write address pointer
              rd_addrA,		  // read address pointers
			  rd_addrB,
  output logic[7:0] datA_out, // read data
                    datB_out, // read data
					implicitReg1, //Implicit registers for Branch
					implicitReg2 //Implicit registers for Branch
					);

  logic[7:0] core[2**3];    // 2-dim array  8 wide  8 deep

// reads are combinational
  assign datA_out = core[rd_addrA]; //2nd input reg
  assign datB_out = core[rd_addrB]; //1st input reg
  assign implicitReg1 = core['b000]; //Implicit Register 1: r0
  assign implicitReg2 = core['b011]; //Implicit Register 2: r3
// writes are sequential (clocked)
  always_ff @(posedge clk)
    if(wr_en)				   // anything but stores or no ops
      core[wr_addr] <= dat_in; 

endmodule