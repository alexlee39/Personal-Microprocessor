// sample top level design
module top_level(
  input        clk, reset, // req,  //What does req port do?
  output logic done);
  parameter D = 9,             // program counter width
    A = 3;             		  // ALU command bit width
  wire[D:0] prog_ctr, target; //Program counter = 2^10 
  wire[4:0] branch_addr; //Jump 
  wire[7:0]   datA,datB,		  // from RegFile
              muxB, muxMemToReg, //muxB = takes in Immediate, dataFile //muxMemToReg = takes in Memory from dataMem(lw) or alu OP
			  rslt,               // alu output, which want to write to datA
        memData, //Data read From DataMem (Loaded Word/Byte)
              immed,
        implicitReg1,
        implicitReg2;
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  absj,
        muxBranch; //relj;                     // from control to PC; relative jump enable
  wire  pari,
        zero,
		sc_clr,
		sc_en,
    sc_pari,
    sc_left,
    sc_o,
        MemWrite,
        RegWrite,
        MemtoReg,
        ALUSrc;		              // immediate switch
  wire[A-1:0] alu_cmd, alu_op;
  wire[8:0]   mach_code;          // machine code
  wire[2:0] rd_addrA, rd_addrB;    // address pointers to reg_file
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		//  .reljump_en (relj),
		 .absjump_en (muxBranch), //Originally was absj
		 .target , //Originally was target
		 .prog_ctr          );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (branch_addr), //branch address that leads to a LUT 
         .target          );   

// contains machine code
  instr_ROM #(.D(D))
   ir1(.prog_ctr,
      .mach_code);

// control decoder
  Control ctl1(.instr(alu_cmd),
  .Branch  (absj)  , 
  .MemWrite , 
  .ALUSrc   , 
  .RegWrite   ,     
  .MemtoReg,
  .ALUOp(alu_op));

  //Example Operation lw r4 r3
  //lw = alu_cmd
  //r4 = rd_addrB
  //r3 = rd_addrA 
  //Do we need to fix this?
  assign rd_addrA = mach_code[2:0]; 
  assign rd_addrB = mach_code[5:3]; 
  assign branch_addr = mach_code[5:1]; //Branch has 6 bits of different branch addresses, PC_LUT? 
  assign alu_cmd  = mach_code[8:6];

  assign muxBranch = zero && absj ? 1 : 0; //AND gate that decides if we take the branch Mux

  assign muxB = ALUSrc? immed : datB; // ALU SRC True(=1): muxB = imm, else if ALUSrc = 0 --> muxB = datB
  assign muxMemToReg = MemtoReg ? memData : rslt; //If MemToReg = 1, muxMemToReg = readData(Value from DataMem), otherwise its the result of ALUOp(rslt)
  assign muxBranchType = mach_code[0];
  // assign muxBranch = takeBranch ? absj : 0; //If zeroQ(ie. 2 implicit registers aren't equal) turn on absolute branching, else no branching
  //muxBranch condition is an AND of   

  reg_file #(.pw(2))
   rf1(.dat_in(muxMemToReg),	   // loads, most ops
              .clk         ,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (rd_addrB),      // in place operation
              .datA_out(datA),
              .datB_out(datB),
              .implicitReg1,
              .implicitReg2   ); 

  set_imm set1(
    .imm(rd_addrA),
    .immed    );

  shift_imm shift1(
    .imm(rd_addrA),
    .sc_en, 
    .sc_clr, 
    .sc_pari, 
    .sc_left    );

  //how to specific implicit registers?
  alu alu1(.alu_cmd(alu_op), //TODO: add in ports from ALU file
         .inA    (datA),
		 .inB    (muxB),
		 .sc_i   (sc_in),   // output from sc register
     .impl1 (implicitReg1),
     .impl2 (implicitReg2),
     .branchControl(muxBranchType),
    // .immed,
    //  .sc_en,
    //  .sc_clr,
     .sc_pari,
     .sc_left,
		 .rslt   ,
		 .sc_o   , // input to sc register
		 .pari,
     .zero  );  

  dat_mem dm1(.dat_in(datB)  ,  // from reg_file
             .clk           ,
			 .wr_en  (MemWrite), // stores
			 .addr   (datA), //Address where to write/read
             .dat_out(memData));  //Read byte

// registered flags from ALU
  always_ff @(posedge clk) begin
  //   pariQ <= pari;
	// zeroQ <= zero;
  if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
    else 
      sc_in <= 'b0;
  end


  //Shifting Flags to ALU from shift_imm
  // always_comb begin
  //   if(sc_clr)
	//   sc_in <= 'b0;
  //   else if(sc_en)
  //     sc_in <= sc_o;
  //   else if(sc_pari)
  //     sc_in <= pari;
  //   else 
  //     sc_in <= 'b0;
  // end

  assign done = prog_ctr == 450;
 
endmodule