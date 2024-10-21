module shift_imm(
  input       [2:0] imm,	   // target 2^6 values 
  output logic sc_en, sc_clr,sc_pari, sc_left
  );

  always_comb begin
    sc_en = 0;
    sc_clr = 0;
    sc_pari = 0;
    sc_left = 1;
    case(imm)
	'b000: sc_en = 1;  
    'b001:
    begin
     sc_en = 1;  
     sc_left = 0;
    end
    'b010: sc_clr = 1;
    'b011: 
    begin
    sc_clr = 1;
    sc_left = 0;
    end
    'b100: sc_pari = 1;
    'b101:
    begin
     sc_pari = 1; 
     sc_left = 0;
    end
    default: sc_en = 0;
  endcase
  end
endmodule
