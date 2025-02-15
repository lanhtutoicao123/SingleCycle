
module singlecycle (
  input  logic        i_clk     ,
  input  logic        i_rst_n   ,
  output logic [31:0] o_io_ledr ,
  output logic [31:0] o_io_ledg ,
  input  logic [31:0] i_io_sw  ,
  output logic [ 6:0] o_io_hex0,
  output logic [ 6:0] o_io_hex1,
  output logic [ 6:0] o_io_hex2,
  output logic [ 6:0] o_io_hex3,
  output logic [ 6:0] o_io_hex4,
  output logic [ 6:0] o_io_hex5,
  output logic [ 6:0] o_io_hex6,
  output logic [ 6:0] o_io_hex7,
 // input logic  [ 3:0] i_io_btn,
  output logic [31:0] o_io_lcd,
  output reg   [31:0] o_pc_debug,
  output reg          o_insn_vld
 // output logic [31:0] REG  [31:0]                     /*----------THIS IF FOR OSERVATION-------------*/
);
  logic [31:0] pc_next  ; 
  logic [31:0] pc_four  ; 
  logic [31:0] pc       ; 
  logic [31:0] instr    ; 
  logic [31:0] rs1_data ;
  logic [31:0] rs2_data ;
  logic [31:0] operand_a;
  logic [31:0] operand_b;
  logic [31:0] alu_data ; 
  logic [31:0] ld_data  ; 
  logic [31:0] imm_gen  ;  
  logic [31:0] wb_data  ;
  logic [ 4:0] rs1_addr ; 
  logic [ 4:0] rs2_addr ; 
  logic [ 4:0] rd_addr  ; 
  logic [ 3:0] alu_op   ;
  logic [ 1:0] wb_sel   ;
  logic 	   pc_sel   ; 
  logic        rd_wren  ; 
  logic        br_un    ;
  logic        br_less  ; 
  logic        br_equal ; 
  logic        opa_sel  ; 
  logic        mem_wren  ;
  wire        o_insn_vld_reg;
  logic [ 3:0] i_io_btn;
  
  always_ff @(posedge i_clk) begin
		o_pc_debug <= pc;	
  end
	
  always_ff @(posedge i_clk) begin
		o_insn_vld <= o_insn_vld_reg;	
  end	
 
  programcounter PC (                           /*---------------Already Checked----------------*/
   .i_clk   (i_clk       ), 
   .i_rst   (i_rst_n       ),
   .pc_next (pc_next     ), 
   .pc      (pc          ) 
  );
  
  add4 AAD4 (                                   /*----------------Already Checked-----------------*/
   .pc_four (pc_four ), 
   .pc      (pc      )
  );
  
  mux1 MUX1 (                                   /*----------------Already Checked-----------------*/
   .alu_data (alu_data ), 
   .pc_four  (pc_four  ), 
   .pc_sel   (pc_sel   ), 
   .pc_next  (pc_next  )
  );
  
  instruction_memory INSTRUCTION_MEMORY (       /*----------------Already Checked-----------------*/
   .pc    (pc    ), 
   .instr (instr )
  );
  
  regfile REGFILE (                              /*-------------- Already Checked---------------*/
  // .REG        (REG          ),                  /*----------THIS IS FOR OSERVATION-------------*/
   .i_rd_data  (wb_data      ), 
   .i_rd_wren  (rd_wren      ), 
   .i_clk      (i_clk        ), 
   .i_rst      (i_rst_n        ), 
   .i_rs1_addr (instr[19:15] ), 
   .i_rs2_addr (instr[24:20] ),
   .i_rd_addr  (instr[11:7]  ), 
   .o_rs1_data (rs1_data     ), 
   .o_rs2_data (rs2_data     )
  );
  
  imm_gen IMM_GEN (                              /*--------------Already Checked---------------*/
   .instruction (instr  ), 
   .imm_out     (imm_gen)
  );
  
  brc BRC (                                      /*----------------Already Checked-----------------*/
   .rs1_data (rs1_data ), 
   .rs2_data (rs2_data ), 
   .br_unsigned(br_un    ), 
   .br_less  (br_less  ), 
   .br_equal (br_equal )
  );
  
  mux2 MUX2 (                                    /*----------------Already Checked-----------------*/
   .pc        (pc        ), 
   .rs1_data  (rs1_data  ), 
   .opa_sel   (opa_sel   ), 
   .operand_a (operand_a )
  );
  
  mux3 MUX3 (                                     /*----------------Already Checked-----------------*/
   .rs2_data  (rs2_data  ), 
   .imm_gen   (imm_gen   ), 
   .opb_sel   (opb_sel   ), 
   .operand_b (operand_b )
  );
  
  alu ALU ( 
   .i_operand_a (operand_a ), 
   .i_operand_b (operand_b ), 
   .i_alu_op    (alu_op    ), 
   .o_alu_data  (alu_data  )
  );
  
 lsu LSU(
	 .i_clk(i_clk),
  	 .i_rst_n(i_rst_n),
     .i_lsu_addr(alu_data),   
     .i_st_data(rs2_data),    
     .i_lsu_wren(mem_wren),
     .i_control(instr[14:12]),  
     .o_ld_data(ld_data),    
     .o_io_ledr(o_io_ledr),     
	 .o_io_ledg(o_io_ledg),     
 	 .o_io_hex0(o_io_hex0),     
     .o_io_hex1(o_io_hex1),      
     .o_io_hex2(o_io_hex2),     
     .o_io_hex3(o_io_hex3),     
 	 .o_io_hex4(o_io_hex4),     
     .o_io_hex5(o_io_hex5),     
     .o_io_hex6(o_io_hex6),     
     .o_io_hex7(o_io_hex7),    
 	 .o_io_lcd(o_io_lcd),      
  	 .i_io_sw(i_io_sw),    
 	 .i_io_btn (i_io_btn)
);
  
  mux4 MUX4 (                                            
   .pc_four  (pc_four  ), 
   .alu_data (alu_data ), 
   .ld_data  (ld_data  ), 
   .wb_sel   (wb_sel   ), 
   .wb_data  (wb_data  )
  );
  
  controller CONTROLLER (                          
   .instruction (instr    ), 
   .br_less     (br_less  ), 
   .br_equal    (br_equal ), 
   .rd_wren     (rd_wren  ), 
   .br_un       (br_un    ), 
   .opa_sel     (opa_sel  ), 
   .opb_sel     (opb_sel  ), 
   .alu_op      (alu_op   ), 
   .mem_wren    (mem_wren ), 
   .wb_sel      (wb_sel   ), 
   .pc_sel      (pc_sel   ),
	.o_insn_vld (o_insn_vld_reg)
  );

  assign rs1_addr = instr[19:15] ;
  assign rs2_addr = instr[24:20] ;
  assign rd_addr  = instr[11:7]  ;
  
endmodule





  
































