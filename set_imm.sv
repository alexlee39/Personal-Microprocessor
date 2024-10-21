module set_imm #(parameter D=9)(
  input       [2:0] imm,	   // target 2^6 values 
  output logic[7:0] immed);

  always_comb begin
  case(imm)
	'b000: immed = 0;// TODO    
    'b001: immed = 1;//
    'b010: immed = 30; //0b0011110
    'b011: immed = 5; //0b0000_0101
    'b100: immed = 'b11111000; 
    'b101: immed = 'b01010100;
    'b110: immed = 226;
    // 'b101: immed = '1;  // All 1's: 0b1111_1111
    // 'b110: immed = 'b01100001;
    'b111: immed = '1;
    default: immed = 0;
  endcase
  end
endmodule
