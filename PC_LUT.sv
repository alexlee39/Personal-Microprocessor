module PC_LUT #(parameter D=9)(
  input       [4:0] addr,	   // target 2^6 values 
  output logic[D:0] target);

//Supports Absolute Branching
  always_comb case(addr)
	'b00000: target = 0;// TODO
	'b00001: target = 6;
	'b00010: target = 10;
	'b00011: target = 23;
	'b00100: target = 24;
	'b00101: target = 39;
	'b00110: target = 55;
	'b00111: target = 69;
	'b01000: target = 85;
	'b01001: target = 103;
	'b01010: target = 118;
	'b01011: target = 136;
	'b01100: target = 145;
	'b01101: target = 159;
	'b01110: target = 166;
	'b01111: target = 184;
	'b10000: target = 210;
	'b10001: target = 238;
	'b10010: target = 268;
	'b10011: target = 301;
	'b10100: target = 317;
	'b10101: target = 335;
	'b10110: target = 152;
	'b10111: target = 274;
	'b11000: target = 287;
	// 'b11110: target = 
	'b11111: target = 297;
	// 'b11001: target = 268;


    // 0: target = -5;   // go back 5 spaces
	// 1: target = 20;   // go ahead 20 spaces
	// 2: target = '1;   // go back 1 space   1111_1111_1111
	default: target = 'b0;  // hold PC  
  endcase

endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
