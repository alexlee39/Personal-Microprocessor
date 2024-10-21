// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,// immed,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  input[7:0] impl1,impl2,
  input branchControl,
  // input[2:0] shiftImm,
  // input sc_en, sc_clr, sc_pari, 
  input sc_left, sc_pari,
  //Need implicit registers?
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
			   zero      // NOR (output)
);

/* ALU OPS:
  AND: 2 inputs(Reg,Reg)
  XOR: 2 inputs(Reg,Reg)
   ADD: 2 inputs(Reg, Imm)
   SET: 2 input(Reg, Imm)
   SHIFT: 2 inputs(Reg, Imm)
   Branch --> For instructions with implicit registers --> Add an input for it, ex: Add an input that takes the branch flag to see
   //if the instruction we have is the branch. If it is then we compare two implicit registers?(how?)
*/

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  zero = 'b0;
  pari = ^inB;
  case(alu_cmd)
  3'b010: //AND 
      rslt = inA & inB; 

	3'b110: //XOR
	  rslt =  inA ^ inB;

  3'b011: // ADD //TODO: change if add = Reg + Imm or add = Reg + Reg
    rslt = inA + inB;

  3'b101: //Set result(datA) to be inB(immediate)
    rslt = inB;

  3'b100: // SHIFT (Left and Right)
  case(sc_left) // Check if Shift left or Shift Right
    'b1: //Shift Left
    begin
      case(sc_pari)
      'b1:begin
        rslt[7:1] = inB[6:0];
        rslt[0]   = pari;
        sc_o      = inB[7];
      end
      'b0:  begin
        rslt[7:1] = inB[6:0];
        rslt[0]   = sc_i;
        sc_o      = inB[7];
      end
      endcase
    end
    'b0: //Shift Right
    begin 
      case(sc_pari)
      'b1: begin
        rslt[6:0] = inB[7:1];
        rslt[7] = pari;
        sc_o = inB[0];
      end
      'b0: begin
        rslt[6:0] = inB[7:1];
        rslt[7] = sc_i;
        sc_o = inB[0];
      end
      endcase
    end
  endcase
  3'b111: //Branch
  case(branchControl)
  'b0:
    zero = (impl1 !== impl2);
  'b1:
    zero = (impl1 ==  impl2);
  endcase

  default: rslt = inA; //Pass A, or do nothing
  endcase
end
   
endmodule