module processor(
    input  logic CLOCK_50,
    input  logic [17:0] SW,      
    output logic [16:0] LEDR,    
    output logic [7:0]  LEDG,    
    output logic [6:0]  HEX0,    
    output logic [6:0]  HEX1,
    output logic [6:0]  HEX2,
    output logic [6:0]  HEX3,
    output logic [6:0]  HEX4,
    output logic [6:0]  HEX5,
    output logic [6:0]  HEX6,
    output logic [6:0]  HEX7
);
	int   count     =    0;
	logic clock_div = 1'b0;
	
	always_ff @(posedge CLOCK_50) begin
		count++;
		if( count == 1000) begin
			count <= 0;
			clock_div <= ~clock_div;
		end
	end
	
	processor_1 u_processor (
    .i_clk        (clock_div),
    .i_switch     (SW),          
    .o_io_ledr    (LEDR),       
    .o_io_ledg    (LEDG),       
    .o_io_hex_0   (HEX0),       
    .o_io_hex_1   (HEX1),
    .o_io_hex_2   (HEX2),
    .o_io_hex_3   (HEX3),
    .o_io_hex_4   (HEX4),
    .o_io_hex_5   (HEX5),
    .o_io_hex_6   (HEX6),
    .o_io_hex_7   (HEX7)
);
endmodule


module processor_1 (
  input  logic        i_clk     ,
  output logic [16:0] o_io_ledr ,
  output logic [ 7:0] o_io_ledg ,
  input  logic [17:0] i_switch  ,
  output logic [ 6:0] o_io_hex_0,
  output logic [ 6:0] o_io_hex_1,
  output logic [ 6:0] o_io_hex_2,
  output logic [ 6:0] o_io_hex_3,
  output logic [ 6:0] o_io_hex_4,
  output logic [ 6:0] o_io_hex_5,
  output logic [ 6:0] o_io_hex_6,
  output logic [ 6:0] o_io_hex_7
);
  logic [31:0] pc_next, pc_four, pc, instr, rs1_data, rs2_data, operand_a, operand_b, alu_data, ld_data, imm_gen, wb_data;
  logic [4:0]  rs1_addr, rs2_addr, rd_addr; 
  logic [3:0]  alu_op;
  logic [1:0]  wb_sel;
  logic 			pc_sel, rd_wren, br_un, br_less, br_equal, opa_sel, mem_wren,mem_rden, stall_signal;
  logic [31:0] register [31:0];
  
  programcounter PC (
   .i_clk   (i_clk       ), 
   .reset   (i_switch[17]),
   .i_stall (stall_signal), 
   .pc_next (pc_next     ), 
   .pc      (pc          ) 
  );
  
  add4 AAD4 ( 
   .pc_four (pc_four ), 
   .pc      (pc      )
  );
  
  mux1 MUX1 ( 
   .alu_data (alu_data ), 
   .pc_four  (pc_four  ), 
   .pc_sel   (pc_sel   ), 
   .pc_next  (pc_next  )
  );
  
  instruction_memory INSTRUCTION_MEMORY ( 
   .pc    (pc    ), 
   .instr (instr )
  );
  
  regfile REGFILE ( 
   .register   (register     ), 
   .i_rd_data  (wb_data      ), 
   .i_rd_addr  (instr[11:7]  ), 
   .i_rd_wren  (rd_wren      ), 
   .i_clk      (i_clk        ), 
   .reset      (i_switch[17] ), 
   .i_rs1_addr (instr[19:15] ), 
   .i_rs2_addr (instr[24:20] ), 
   .o_rs1_data (rs1_data     ), 
   .o_rs2_data (rs2_data     )
  );
  
  imm_gen IMM_GEN ( 
   .instruction (instr  ), 
   .imm_out     (imm_gen)
  );
  
  brc BRC ( 
   .i_rs1_data (rs1_data ), 
   .i_rs2_data (rs2_data ), 
   .i_br_un    (br_un    ), 
   .o_br_less  (br_less  ), 
   .o_br_equal (br_equal )
  );
  
  mux2 MUX2 ( 
   .pc        (pc        ), 
   .rs1_data  (rs1_data  ), 
   .opa_sel   (opa_sel   ), 
   .operand_a (operand_a )
  );
  
  mux3 MUX3 ( 
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
  
  data_memory DATA_MEMORY ( 
   .i_lsu_addr(alu_data  ), 
   .i_st_data  (rs2_data ), 
   .i_lsu_wren  (mem_wren), 
   .i_lsu_rden  (mem_rden),
   .i_clk  (i_clk        ), 
   .i_rst  (i_switch[17]),
   .o_ld_data(ld_data      ),
   .o_stall(stall_signal ),
   .o_io_ledr(o_io_ledr  ),
   .o_io_ledg(o_io_ledg  ),
   .i_io_sw(i_switch[16:0]),
   .o_io_hex_0(o_io_hex_0),
   .o_io_hex_1(o_io_hex_1),
   .o_io_hex_2(o_io_hex_2),
   .o_io_hex_3(o_io_hex_3),
   .o_io_hex_4(o_io_hex_4),
   .o_io_hex_5(o_io_hex_5),
   .o_io_hex_6(o_io_hex_6),
   .o_io_hex_7(o_io_hex_7)
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
   .mem_rden    (mem_rden ),
   .wb_sel      (wb_sel   ), 
   .pc_sel      (pc_sel   )
  );
  
  assign rs1_addr = instr[19:15] ;
  assign rs2_addr = instr[24:20] ;
  assign rd_addr  = instr[11:7]  ;
  
endmodule

module controller (
	input  logic [31:0] instruction,
	input  logic        br_less    ,
	input  logic        br_equal   ,
	output logic        rd_wren    ,
	output logic        br_un      ,
	output logic        opa_sel    ,
	output logic        opb_sel    ,
	output logic [ 3:0] alu_op     , 
	output logic        mem_wren   ,
	output logic        mem_rden   ,
	output logic [ 1:0] wb_sel     ,
	output logic        pc_sel
); 
	logic [2:0] func3;
	logic [6:0] func7;
	logic [6:0] opcode;
	
	always @(instruction,br_equal,br_less) begin
		func3  = instruction [14:12];
		func7  = instruction [31:25];
		opcode = instruction [ 6: 0];
		
		case(opcode)
			7'b0110011: begin
				rd_wren  = 1'b1;
				br_un    = 1'b0;
				opa_sel  = 1'b1;
				opb_sel  = 1'b0;
				mem_wren = 1'b0;
				mem_rden = 1'b0;
				wb_sel   = 2'b01;
				pc_sel   = 1'b0;
				case(func3)
					3'b000: begin
						case(func7)
							7'b0000000: alu_op = 4'b0000;
							7'b0100000: alu_op = 4'b0001;
						endcase
					end
					3'b001: alu_op = 4'b0111;
					3'b010: alu_op = 4'b0010;
					3'b011: alu_op = 4'b0011;
					3'b100: alu_op = 4'b0100;
					3'b101: begin
						case(func7)
							7'b0000000: alu_op = 4'b1000;
							7'b0100000: alu_op = 4'b1001;
						endcase
					end
					3'b110: alu_op = 4'b0101;
					3'b111: alu_op = 4'b0110;
				endcase
			end
			7'b0010011: begin
				rd_wren  = 1'b1;
				br_un    = 1'b0;
				opa_sel  = 1'b1;
				opb_sel  = 1'b1;
				mem_wren = 1'b0;
				mem_rden = 1'b0;
				wb_sel   = 2'b01;
				pc_sel   = 1'b0;
				case(func3)
					3'b000: alu_op = 4'b0000;
					3'b010: alu_op = 4'b0010;
					3'b011: alu_op = 4'b0011;
					3'b100: alu_op = 4'b0100;
					3'b111: alu_op = 4'b0110;
					3'b001: alu_op = 4'b0111;
					3'b101: begin
						case(func7)
							7'b0000000: alu_op = 4'b1000;
							7'b0100000: alu_op = 4'b1001;
						endcase
					end
				endcase	
			end
			7'b0100011: begin
				rd_wren  = 1'b0;
				br_un    = 1'b0;
				opa_sel  = 1'b1;
				opb_sel  = 1'b1;
				alu_op   = 4'b0000;
				mem_wren = 1'b1;
				mem_rden = 1'b0;
				wb_sel   = 2'b00;
				pc_sel   = 1'b0;
			end
			7'b0000011: begin
				rd_wren  = 1'b1;
				br_un    = 1'b0;
				opa_sel  = 1'b1;
				opb_sel  = 1'b1;
				alu_op   = 4'b0000;
				mem_wren = 1'b0;
				mem_rden = 1'b1;
				wb_sel   = 2'b10;
				pc_sel   = 1'b0;
			end
			7'b1100011: begin
				rd_wren  = 1'b0;
				opa_sel  = 1'b0;
				opb_sel  = 1'b1;
				alu_op   = 4'b0000;
				mem_wren = 1'b0;
				mem_rden = 1'b0;
				wb_sel   = 2'b00;
				case(func3)
					3'b000: begin
						br_un  = 1'b0;
						pc_sel = br_equal;
					end
					3'b001: begin
						br_un  = 1'b0;
						pc_sel = ~br_equal;
					end
					3'b100: begin
						br_un  = 1'b1;
						pc_sel = br_less;
					end
					3'b101: begin
						br_un  = 1'b1;
						pc_sel = ~br_less;
					end
					3'b110: begin
						br_un  = 1'b0;
						pc_sel = br_less;
					end
					3'b111: begin
						br_un  = 1'b0;
						pc_sel = ~br_less;
					end
				endcase
			end
			7'b0110111: begin
				rd_wren  = 1'b1;
				br_un    = 1'b0;
				opa_sel  = 1'b0;
				opb_sel  = 1'b1;
				alu_op   = 4'b1010;
				mem_wren = 1'b0;
				mem_rden = 1'b0;
				wb_sel   = 2'b01;
				pc_sel   = 1'b0;
			end
			7'b0010111: begin
				rd_wren  = 1'b1;
				br_un    = 1'b0;
				opa_sel  = 1'b0;
				opb_sel  = 1'b1;
				alu_op   = 4'b0000;
				mem_wren = 1'b0;
				mem_rden = 1'b0;
				wb_sel   = 2'b01;
				pc_sel   = 1'b0;
			end
			7'b1101111: begin
				rd_wren  = 1'b1;
				br_un    = 1'b0;
				opa_sel  = 1'b0;
				opb_sel  = 1'b1;
				alu_op   = 4'b0000;
				mem_wren = 1'b0;
				mem_rden = 1'b0;
				wb_sel   = 2'b00;
				pc_sel   = 1'b1;
			end
			7'b1100111: begin
				rd_wren  = 1'b1;
				br_un    = 1'b0;
				opa_sel  = 1'b1;
				opb_sel  = 1'b1;
				alu_op   = 4'b0000;
				mem_wren = 1'b0;
				mem_rden = 1'b0;
				wb_sel   = 2'b00;
				pc_sel   = 1'b1;
			end
		endcase	
	end
endmodule

module mux2(    
	input logic  [31:0] pc,
	input logic  [31:0] rs1_data,
	input logic         opa_sel,
	output logic [31:0] operand_a  
);
	assign operand_a = opa_sel ? rs1_data : pc;
endmodule

module mux4(
	input logic  [31:0] pc_four ,
	input logic  [31:0] alu_data,
	input logic  [31:0] ld_data ,
	input logic  [ 1:0] wb_sel ,
	output logic [31:0] wb_data 
);
	always @(wb_sel,ld_data,alu_data,pc_four) begin
		case (wb_sel)
			2'b00: wb_data = pc_four;
			2'b01: wb_data = alu_data;
			2'b10: wb_data = ld_data;
			default: 
			  wb_data = 32'b0; 
		endcase
	end
endmodule

module brc(
    input logic [31:0] i_rs1_data,
    input logic [31:0] i_rs2_data,
    input logic        i_br_un   ,
    output logic       o_br_less ,
    output logic       o_br_equal
);
    always @(i_br_un,i_rs1_data,i_rs2_data) begin
        if (i_br_un == 0) begin
            o_br_less  = (i_rs1_data < i_rs2_data)  ? 1 : 0;
            o_br_equal = (i_rs1_data == i_rs2_data) ? 1 : 0;
        end 
        else begin
            o_br_less  = ($signed(i_rs1_data) <  $signed(i_rs2_data)) ? 1 : 0;
            o_br_equal = ($signed(i_rs1_data) == $signed(i_rs2_data)) ? 1 : 0;
        end
    end
endmodule

module programcounter(
  input logic         i_clk  , 
  input logic         reset  ,
  input logic         i_stall, 
  input logic  [31:0] pc_next, 
  output logic [31:0] pc
  
);
    always_ff @(posedge i_clk) begin
    	if (0) begin
  	     pc = 0;
	     end 
	   else begin
	   if(i_stall) begin   
    	   pc = pc;
  	 end else begin
        pc = pc_next;  	   
	  end
  end
end
endmodule
  
module alu(
    input logic [31:0] i_operand_a, 
    input logic [31:0] i_operand_b, 
    input logic [3:0] i_alu_op, 
    output logic [31:0] o_alu_data
);

localparam [31:0] ONE = 32'h0000_0001;
localparam [31:0] ZERO = 32'h0000_0000;

localparam [3:0] OP_ADD  = 4'b0000; 
localparam [3:0] OP_SUB  = 4'b0001; 
localparam [3:0] OP_SLT  = 4'b0010; 
localparam [3:0] OP_SLTU = 4'b0011; 
localparam [3:0] OP_XOR  = 4'b0100; 
localparam [3:0] OP_OR   = 4'b0101; 
localparam [3:0] OP_AND  = 4'b0110; 
localparam [3:0] OP_SLL  = 4'b0111; 
localparam [3:0] OP_SRL  = 4'b1000; 
localparam [3:0] OP_SRA  = 4'b1001; 
localparam [3:0] OP_OUTPUT_B = 4'b1010; 


function logic [31:0] func_add (logic [31:0] i_a, logic [31:0] i_b);
    return i_a + i_b;
endfunction


function logic [31:0] func_sub (logic [31:0] i_a, logic [31:0] i_b);
    return i_a + (~i_b + 1);
endfunction


function logic [31:0] func_slt (logic [31:0] i_a, logic [31:0] i_b);
    return ($signed(i_a) < $signed(i_b)) ? ONE : ZERO;
endfunction


function logic [31:0] func_sltu (logic [31:0] i_a, logic [31:0] i_b);
    return (i_a < i_b) ? ONE : ZERO;
endfunction


function logic [31:0] func_sll (logic [31:0] i_a, logic [31:0] i_b);
    return i_a << i_b;
endfunction


function logic [31:0] func_srl (logic [31:0] i_a, logic [31:0] i_b);
    return i_a >> i_b;
endfunction


function logic [31:0] func_sra (logic [31:0] i_a, logic [31:0] i_b);
    return i_a >>> i_b;
endfunction

        
always @(i_operand_a,i_operand_b,i_alu_op) begin
    case (i_alu_op)
        OP_ADD: o_alu_data = func_add(i_operand_a, i_operand_b);   
        OP_SUB: o_alu_data = func_sub(i_operand_a, i_operand_b);  
        OP_SLT: o_alu_data = func_slt(i_operand_a, i_operand_b);   
        OP_SLTU: o_alu_data = func_sltu(i_operand_a, i_operand_b); 
        OP_XOR: o_alu_data = i_operand_a ^ i_operand_b;            
        OP_OR: o_alu_data = i_operand_a | i_operand_b;             
        OP_AND: o_alu_data = i_operand_a & i_operand_b;           
        OP_SLL: o_alu_data = func_sll(i_operand_a, i_operand_b);   
        OP_SRL: o_alu_data = func_srl(i_operand_a, i_operand_b);  
        OP_SRA: o_alu_data = func_sra(i_operand_a, i_operand_b);  
        OP_OUTPUT_B: o_alu_data = i_operand_b;
        default: o_alu_data = ZERO; 
    endcase
end

endmodule

module data_memory (
  input logic         i_clk     , 
  input logic         i_rst     ,
  
  input logic  [31:0] i_lsu_addr,
  input logic  [31:0] i_st_data ,
  input logic         i_lsu_wren,
  input logic         i_lsu_rden,
  input logic  [16:0] i_io_sw   ,
  output logic [31:0] o_ld_data ,
  output logic [16:0] o_io_ledr ,
  output logic [ 7:0] o_io_ledg ,
  output logic [ 6:0] o_io_hex_0,
  output logic [ 6:0] o_io_hex_1,
  output logic [ 6:0] o_io_hex_2,
  output logic [ 6:0] o_io_hex_3,
  output logic [ 6:0] o_io_hex_4,
  output logic [ 6:0] o_io_hex_5,
  output logic [ 6:0] o_io_hex_6,
  output logic [ 6:0] o_io_hex_7,

  output logic        o_stall
);     
  
  logic [17:0]   i_ADDR   ;
  logic [31:0]   i_WDATA  ;
  logic [ 3:0]   i_BMASK  ;
  logic          i_WREN   ;
  logic          i_RDEN   ;
  logic [31:0]   o_RDATA  ;
  logic          o_ACK    ; 

  logic [17:0]   SRAM_ADDR;
 // wire  [15:0]   SRAM_DQ  ;
  logic          SRAM_CE_N;
  logic          SRAM_WE_N;
  logic          SRAM_LB_N;
  logic          SRAM_UB_N;
  logic          SRAM_OE_N;
  
  
  sram_IS61WV25616_controller_32b_3lr SRAM (
  .i_clk    (i_clk)    ,
  .i_reset  (i_rst)    ,
  
  .i_ADDR   (i_ADDR)   ,
  .i_WDATA  (i_WDATA)  ,
  .i_BMASK  (i_BMASK)  ,
  .i_WREN   (i_WREN)   ,
  .i_RDEN   (i_RDEN)   ,
  .o_RDATA  (o_RDATA)  ,
  .o_ACK    (o_ACK)    ,
  
  .SRAM_ADDR(SRAM_ADDR),
 // .SRAM_DQ  (SRAM_DQ  ),
  .SRAM_CE_N(SRAM_CE_N),
  .SRAM_WE_N(SRAM_WE_N),
  .SRAM_LB_N(SRAM_LB_N),
  .SRAM_UB_N(SRAM_UB_N),
  .SRAM_OE_N(SRAM_OE_N)
);
	
	assign	 i_ADDR      = i_lsu_addr;
	assign	 i_WDATA     = i_st_data ;
	assign	 i_BMASK     = 4'b1111   ;
	 

	always_ff @(negedge i_clk) begin
		if(o_ACK == 1'b0) begin
			if(i_lsu_wren == 1'b1) begin
				i_WREN = 1'b1;
				o_stall = 1'b1;
			end
			if(i_lsu_rden == 1'b1) begin
				i_RDEN = 1'b1;
				o_stall = 1'b1;
			end
		end else begin
			o_stall = 1'b0;
			if(i_lsu_wren == 1'b1) begin
				i_WREN = 1'b0;
				if(i_lsu_addr == 32'h00007000) begin
				    o_io_ledr = i_st_data[16:0];
				end
				if(i_lsu_addr == 32'h00007010) begin
				    o_io_ledg = i_st_data[07:0];
				end
				if(i_lsu_addr == 32'h00007020) begin
				    o_io_hex_0 = i_st_data[6:0];
				    o_io_hex_1 = i_st_data[14:8];
				    o_io_hex_2 = i_st_data[22:6];
				    o_io_hex_3 = i_st_data[30:24];
				end
				if(i_lsu_addr == 32'h00007024) begin
				    o_io_hex_4 = i_st_data[6:0];
				    o_io_hex_5 = i_st_data[14:8];
				    o_io_hex_6 = i_st_data[22:6];
				    o_io_hex_7 = i_st_data[30:24];
				end
			end
			if(i_lsu_rden == 1'b1) begin
				i_RDEN = 1'b0;
				if(i_lsu_addr == 32'h00007800) begin
					o_ld_data = i_io_sw;
				end
				if((i_lsu_rden <= 32'h00003FFF) && (32'h00002000 <= i_lsu_rden)) begin
					o_ld_data = o_RDATA;
				end
			end
		end
	end
endmodule
	
module sram_IS61WV25616_controller_32b_3lr (
  input  logic [17:0]   i_ADDR   ,
  input  logic [31:0]   i_WDATA  ,
  input  logic [ 3:0]   i_BMASK  ,
  input  logic          i_WREN   ,
  input  logic          i_RDEN   ,
  output logic [31:0]   o_RDATA  ,
  output logic          o_ACK    ,

  output logic [17:0]   SRAM_ADDR,
//  inout  logic [15:0]   SRAM_DQ  ,
  output logic          SRAM_CE_N,
  output logic          SRAM_WE_N,
  output logic          SRAM_LB_N,
  output logic          SRAM_UB_N,
  input  logic          SRAM_OE_N,

  input  logic          i_clk,
  input  logic          i_reset
);
   logic [15:0]   SRAM_DQ  ;
  typedef enum logic [2:0] {
      StIdle
    , StWrite
    , StWriteAck
    , StRead0
    , StRead1
    , StReadAck
  } sram_state_e;

  sram_state_e sram_state_d;
  sram_state_e sram_state_q;

  logic [17:0] addr_d ;
  logic [17:0] addr_q ;
  logic [31:0] wdata_d;
  logic [31:0] wdata_q;
  logic [31:0] rdata_d;
  logic [31:0] rdata_q;
  logic [ 3:0] bmask_d;
  logic [ 3:0] bmask_q;

  always_comb begin : proc_detect_state
    case (sram_state_q)
      StIdle, StWriteAck, StReadAck: begin
        if (i_WREN ~^ i_RDEN) begin
          sram_state_d = StIdle;
          addr_d       = addr_q;
          wdata_d      = wdata_q;
          rdata_d      = rdata_q;
          bmask_d      = bmask_q;
        end
        else begin
          sram_state_d = i_WREN ? StWrite : StRead0;
          addr_d       = i_ADDR & 18'h3FFFE;
          wdata_d      = i_WREN ? i_WDATA : wdata_q;
          rdata_d      = rdata_q;
          bmask_d      = i_BMASK;
        end
      end
      StWrite: begin
         sram_state_d = StWriteAck;
        addr_d       = addr_q | 18'h1;
        wdata_d      = wdata_q;
        rdata_d      = rdata_q;
        bmask_d      = bmask_q;
      end
      StRead0: begin
        sram_state_d = StRead1;
        addr_d       = addr_q | 18'h1;
        wdata_d      = wdata_q;
        rdata_d      = {rdata_q[31:16], SRAM_DQ};
        bmask_d      = bmask_q;
      end
      StRead1: begin
        sram_state_d = StReadAck;
        addr_d       = addr_q;
        wdata_d      = wdata_q;
        rdata_d      = {SRAM_DQ, rdata_q[15:0]};
        bmask_d      = bmask_q;
      end
      default: begin
        sram_state_d = StIdle;
        addr_d       = '0;
        wdata_d      = '0;
        rdata_d      = '0;
        bmask_d      = '0;
      end
    endcase

  end

  always_ff @(posedge i_clk) begin
    if (!i_reset) begin
      sram_state_q <= StIdle;
    end
    else begin
      sram_state_q <= sram_state_d;
    end
  end

  always_ff @(posedge i_clk) begin
    if (!i_reset) begin
      addr_q  <= '0;
      wdata_q <= '0;
      rdata_q <= '0;
      bmask_q <= 4'b0000;
    end
    else begin
      addr_q  <= addr_d;
      wdata_q <= wdata_d;
      rdata_q <= rdata_d;
      bmask_q <= bmask_d;
    end
  end

  always_comb begin : proc_output
    SRAM_ADDR = addr_q;
    SRAM_DQ   = 'z;
    SRAM_WE_N = 1'b1;
    SRAM_CE_N = 1'b1;
    case (sram_state_q)
      StWrite, StRead0: begin
        {SRAM_UB_N, SRAM_LB_N} = ~bmask_q[1:0];
      end
      StWriteAck, StRead1, StReadAck: begin
        {SRAM_UB_N, SRAM_LB_N} = ~bmask_q[3:2];
      end
      default: begin
        {SRAM_UB_N, SRAM_LB_N} = ~bmask_q[1:0];
      end
    endcase

    if (sram_state_q == StWrite) begin
      SRAM_DQ   = wdata_q[15:0];
      SRAM_WE_N = 1'b0;
    end
    if (sram_state_q == StWriteAck) begin
      SRAM_DQ   = wdata_q[31:16];
      SRAM_WE_N = 1'b0;
    end

    if (sram_state_q != StIdle) begin
      SRAM_CE_N = 1'b0;
    end
  end

  assign o_RDATA = rdata_q;
  assign o_ACK  = (sram_state_q == StWriteAck) || (sram_state_q == StReadAck);

endmodule : sram_IS61WV25616_controller_32b_3lr



module instruction_memory(  //CHECKED
	input logic  [31:0] pc,
	output logic [31:0] instr
);
    reg [31:0] instruction_memory [63:0]; 
    logic [31:0] temp;    
    // Initialize the ROM with the program instruction
    initial begin
         $readmemh("code.txt", instruction_memory);  
	 end
    //
    always @(pc) begin
      temp  = pc[31:2];
      instr = instruction_memory[temp];
    end
endmodule

module mux1( 
	input logic  [31:0] alu_data,
	input logic  [31:0] pc_four ,
	input logic         pc_sel  ,
	output logic [31:0] pc_next
);
	assign pc_next = pc_sel ? alu_data : pc_four;
endmodule

module imm_gen(
    input logic [31:0] instruction,
    output logic [31:0] imm_out
);
    always @(instruction) begin
        case (instruction[6:0]) 
            7'b0010011: begin  // I-type instructions
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
            end
            7'b0000011: begin  // Load instructions
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
            end
            7'b0100011: begin  // S-type instructions
                imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            7'b1100011: begin  // B-type instructions
                imm_out = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            7'b0110111: begin  // U-type instructions
                imm_out = {instruction[31:12], 12'b0};
            end
            7'b1101111: begin  // J-type instructions
                imm_out = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            7'b0010111: begin  // AUIPC instructions
                imm_out = {instruction[31:12], 12'b0};
            end
            7'b1100111: begin  // JALR instructions
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
            end
            default: imm_out = 32'b0;  // Default case to handle unexpected values
        endcase
    end
endmodule

module add4(
	input  logic [31:0] pc,
	output logic [31:0] pc_four
);
	assign	pc_four = pc + 4;
endmodule

module mux3(
	input logic  [31:0] rs2_data ,
	input logic  [31:0] imm_gen  ,
	input logic         opb_sel  ,
	output logic [31:0] operand_b
);
	assign operand_b = opb_sel ? imm_gen : rs2_data;
endmodule

module regfile (
    input logic  [31:0] i_rd_data ,
    input logic  [ 4:0] i_rd_addr ,
    input logic         i_rd_wren ,
    input logic         i_clk     ,
    input logic         reset     ,
    input logic  [ 4:0] i_rs1_addr,
    input logic  [ 4:0] i_rs2_addr,
    output logic [31:0] o_rs1_data,
    output logic [31:0] o_rs2_data,
    output logic [31:0] register    [31:0] // Output to access all register values
);

    reg [31:0] registerfile [31:0];

    always @(posedge i_clk) begin
        if (0) begin
            for (int i = 0; i < 32; i++) begin
                registerfile[i] <= 0;
            end
        end else if(i_rd_wren && (i_rd_addr != 0)) begin
            registerfile[i_rd_addr] = i_rd_data;
        end
    end
    
    assign    o_rs1_data = registerfile[i_rs1_addr];
    assign    o_rs2_data = registerfile[i_rs2_addr];
    
    assign register = registerfile;
     
endmodule






