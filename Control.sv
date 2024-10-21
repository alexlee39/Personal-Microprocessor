// control decoder
module Control #(parameter opwidth = 3, mcodebits = 3)(
  input [mcodebits-1:0] instr,    // up to 8 Instructions
  output logic Branch, 
     MemtoReg, MemWrite, ALUSrc, RegWrite,
  output logic[opwidth-1:0] ALUOp);	   // for up to 8 ALU operations

/*
  000: lw
  001: sw
  010: AND
  011: ADD
  100: SHIFT
  101: SET
  110: XOR
  111: BRANCH
*/
always_comb begin
// defaults
  // RegDst 	=   'b0;   // 1: not in place  just leave 0
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	=	'b0;   // 1: immediate  0: second reg file output
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  ALUOp	    =   'b010; // default ALU Op is AND Operation
case(instr)    // override defaults with exceptions
  'b000:  begin	// load operation --> 
               MemtoReg = 'b1; 
			 end
  'b001:  begin  // store operation 
            MemWrite = 'b1;      // write to data mem
            RegWrite = 'b0;      // can't be writing to reg file as well
  end
  'b010: ALUOp = 'b010;// AND operation
  'b011: ALUOp = 'b011; // ADD Operation
  'b100: ALUOp = 'b100; // Shift Operation
  'b101: begin //Set Operation
    ALUOp = 'b101; 
    ALUSrc = 'b1;
  end
  'b110: ALUOp = 'b110; //XOR Operation
  'b111: begin //Branch Operation 
          Branch = 'b1; 
          ALUOp = 'b111;
          RegWrite = 'b0;
  end
endcase

end
	
endmodule