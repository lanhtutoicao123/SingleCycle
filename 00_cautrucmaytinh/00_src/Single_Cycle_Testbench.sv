`timescale 1ns / 1ps
module Single_Cycle_Testbench(
    input  logic [16:0]  SW, 
    input  logic [ 3:0]  KEY,	 
    output logic [16:0]  LEDR,    
    output logic [ 7:0]  LEDG,    
    output logic [ 6:0]  HEX0,    
    output logic [ 6:0]  HEX1,
    output logic [ 6:0]  HEX2,
    output logic [ 6:0]  HEX3,
    output logic [ 6:0]  HEX4,
    output logic [ 6:0]  HEX5,
    output logic [ 6:0]  HEX6,
    output logic [ 6:0]  HEX7,
	  output logic [ 7:0]  LCD_DATA,
	  output logic         LCD_ON,
	  output logic         LCD_RW,
	  output logic         LCD_EN,
	  output logic         LCD_RS,
	  output logic [31:0]  REG [31:0]                 /*----------THIS IF FOR OSERVATION-------------*/
);
	int  		   count     =    0;
	logic 	   clock_div = 1'b0;
	logic                i_clk;
  logic                i_rst;
  
  initial begin
    i_clk = 1                ;
		forever #5 i_clk = ~i_clk;
  end 
  
  initial begin
    i_rst = 0;
    #20;
    i_rst = 1;
    #200000;
    $stop;
  end  
    
	always_ff @(posedge i_clk) begin
		count++;
		if( count == 2) begin
			count <= 0;
			clock_div <= ~clock_div;
		end
	end
	
	
	processor processor_ver_1 (
    .i_clk           (clock_div),
    .i_rst           (i_rst),
    .i_switch        (SW),  
	  .i_io_button     (KEY),
    .o_io_ledr       (LEDR),       
    .o_io_ledg       (LEDG),       
    .o_io_hex_0      (HEX0),       
    .o_io_hex_1      (HEX1),
    .o_io_hex_2      (HEX2),
    .o_io_hex_3      (HEX3),
    .o_io_hex_4      (HEX4),
    .o_io_hex_5      (HEX5),
    .o_io_hex_6      (HEX6),
    .o_io_hex_7      (HEX7),
	  .o_io_lcd        ({LCD_ON, LCD_EN, LCD_RS, LCD_RW, LCD_DATA}),
	  .REG             (REG)                             /*----------THIS IF FOR OSERVATION-------------*/
);
endmodule



module processor (
  input  logic        i_clk     ,
  input  logic        i_rst     ,
  output logic [16:0] o_io_ledr ,
  output logic [ 7:0] o_io_ledg ,
  input  logic [16:0] i_switch  ,
  output logic [ 6:0] o_io_hex_0,
  output logic [ 6:0] o_io_hex_1,
  output logic [ 6:0] o_io_hex_2,
  output logic [ 6:0] o_io_hex_3,
  output logic [ 6:0] o_io_hex_4,
  output logic [ 6:0] o_io_hex_5,
  output logic [ 6:0] o_io_hex_6,
  output logic [ 6:0] o_io_hex_7,
  input logic  [ 3:0] i_io_button,
  output logic [11:0] o_io_lcd,
  output logic [31:0] REG  [31:0]                     /*----------THIS IF FOR OSERVATION-------------*/
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
  logic 			    pc_sel   ; 
  logic        rd_wren  ; 
  logic        br_un    ;
  logic        br_less  ; 
  logic        br_equal ; 
  logic        opa_sel  ; 
  logic        mem_wren  ;
 
  programcounter PC (                           /*---------------Already Checked----------------*/
   .i_clk   (i_clk       ), 
   .i_rst   (i_rst       ),
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
   .REG        (REG          ),                  /*----------THIS IS FOR OSERVATION-------------*/
   .i_rd_data  (wb_data      ), 
   .i_rd_wren  (rd_wren      ), 
   .i_clk      (i_clk        ), 
   .i_rst      (i_rst        ), 
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
   .i_rs1_data (rs1_data ), 
   .i_rs2_data (rs2_data ), 
   .i_br_un    (br_un    ), 
   .o_br_less  (br_less  ), 
   .o_br_equal (br_equal )
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
  
  data_memory DATA_MEMORY ( 
   .i_lsu_addr(alu_data  ), 
   .i_st_data  (rs2_data ), 
   .i_lsu_wren  (mem_wren), 
   .i_clk  (i_clk        ), 
   .i_rst  (i_rst),
   .o_ld_data(ld_data      ),
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
   .o_io_hex_7(o_io_hex_7),
	.i_io_button(i_io_button),
	.o_io_lcd(o_io_lcd),
  	.funct3(instr[14:12])
  );
  
  mux4 MUX4 (                                             /*----------------Already Checked-----------------*/
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
				wb_sel   = 2'b10;
				pc_sel   = 1'b0;
			end
			7'b1100011: begin
				rd_wren  = 1'b0;
				opa_sel  = 1'b0;
				opb_sel  = 1'b1;
				alu_op   = 4'b0000;
				mem_wren = 1'b0;
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
				wb_sel   = 2'b00;
				pc_sel   = 1'b1;
			end
		endcase	
	end
endmodule

module mux2(                                       /*----------------Already Checked-----------------*/
	input logic  [31:0] pc,
	input logic  [31:0] rs1_data,
	input logic         opa_sel,
	output logic [31:0] operand_a  
);
	assign operand_a = opa_sel ? rs1_data : pc;
endmodule

module mux4(                                        /*----------------Already Checked-----------------*/
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

module brc(                                       /*----------------Already Checked-----------------*/
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

module programcounter(                               /*----------------Already Checked-----------------*/
  input logic         i_clk  , 
  input logic         i_rst  ,
  input logic  [31:0] pc_next, 
  output logic [31:0] pc
  
);
    always_ff @(posedge i_clk or negedge i_rst) begin
    	if (~i_rst) begin
  	     pc = 0;
	     end else begin
        pc = pc_next;  	   
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
        OP_ADD : o_alu_data      = func_add(i_operand_a, i_operand_b);   
        OP_SUB : o_alu_data      = func_sub(i_operand_a, i_operand_b);  
        OP_SLT : o_alu_data      = func_slt(i_operand_a, i_operand_b);   
        OP_SLTU: o_alu_data      = func_sltu(i_operand_a, i_operand_b); 
        OP_XOR : o_alu_data      = i_operand_a ^ i_operand_b;            
        OP_OR  : o_alu_data      = i_operand_a | i_operand_b;             
        OP_AND : o_alu_data      = i_operand_a & i_operand_b;           
        OP_SLL : o_alu_data      = func_sll(i_operand_a, i_operand_b);   
        OP_SRL : o_alu_data      = func_srl(i_operand_a, i_operand_b);  
        OP_SRA : o_alu_data      = func_sra(i_operand_a, i_operand_b);  
        OP_OUTPUT_B: o_alu_data  = i_operand_b;
        default: o_alu_data      = ZERO; 
    endcase
end

endmodule

module data_memory (
  input logic         i_clk     , 
  input logic         i_rst     ,
  input logic  [31:0] i_lsu_addr,
  input logic  [31:0] i_st_data ,
  input logic         i_lsu_wren,
  input logic  [16:0] i_io_sw   ,
  input logic  [ 3:0] i_io_button,
  input logic  [ 2:0] funct3,
  
  output reg [31:0] o_ld_data ,
  output reg [16:0] o_io_ledr ,
  output reg [ 7:0] o_io_ledg ,
  output reg [ 6:0] o_io_hex_0,
  output reg [ 6:0] o_io_hex_1,
  output reg [ 6:0] o_io_hex_2,
  output reg [ 6:0] o_io_hex_3,
  output reg [ 6:0] o_io_hex_4,
  output reg [ 6:0] o_io_hex_5,
  output reg [ 6:0] o_io_hex_6,
  output reg [ 6:0] o_io_hex_7,
  output reg [11:0] o_io_lcd  
      
); 

	reg [7:0] Red_Led       [15:0];
	reg [7:0] Green_Led     [15:0];
	reg [7:0] Seven_Segment [ 7:0];
	reg [7:0] Lcd_Control   [15:0];
	reg [7:0] Switches      [15:0];
	reg [7:0] Buttons       [15:0];

   assign Switches[0]     = i_io_sw[ 7:0];
	assign Switches[1]     = i_io_sw[15:8];
	assign Switches[2][0]  = i_io_sw[  16];
	assign Buttons[0]      = i_io_button[0];
	assign Buttons[4]      = i_io_button[1];
	assign Buttons[8]      = i_io_button[2];
	assign Buttons[12]     = i_io_button[3];


 	assign o_io_ledr  = {Red_Led[2][0],Red_Led[1],Red_Led[0]};
	assign o_io_ledg  = Green_Led[0];
	assign o_io_hex_0 = Seven_Segment[0]; 
	assign o_io_hex_1 = Seven_Segment[1];
	assign o_io_hex_2 = Seven_Segment[2];
	assign o_io_hex_3 = Seven_Segment[3];
	assign o_io_hex_4 = Seven_Segment[4];
	assign o_io_hex_5 = Seven_Segment[5];
	assign o_io_hex_6 = Seven_Segment[6];
	assign o_io_hex_7 = Seven_Segment[7];
	assign o_io_lcd   = {Lcd_Control[3][7],Lcd_Control[1][2:0],Lcd_Control[0]};

  
	reg [31:0] connection_timmer_1;
	reg [31:0] connection_timmer_2;
	reg [6:0]  connection_timmer_3[7:0] ;
	
	bin2bcd bin2bcd(
	.in(connection_timmer_1),
	.bcd(connection_timmer_2)
	);
	
	SevenSegmentControl SevenSegmentControl(
	.val(connection_timmer_2),
	.HEX0(connection_timmer_3[0]),
	.HEX1(connection_timmer_3[1]),
	.HEX2(connection_timmer_3[2]),
	.HEX3(connection_timmer_3[3]),
	.HEX4(connection_timmer_3[4]),
	.HEX5(connection_timmer_3[5]),
	.HEX6(connection_timmer_3[6]),
	.HEX7(connection_timmer_3[7])
	);
	
	always_ff @(posedge i_clk or negedge i_rst) begin
	   if(~i_rst) begin
	   Seven_Segment[0]  <=  7'b0;
      Seven_Segment[1]  <=  7'b0;
      Seven_Segment[2]  <=  7'b0;
      Seven_Segment[3]  <=  7'b0;
      Seven_Segment[4]  <=  7'b0;
      Seven_Segment[5]  <=  7'b0;
      Seven_Segment[6]  <=  7'b0;
      Seven_Segment[7]  <=  7'b0;
      {Red_Led[2][0],Red_Led[1],Red_Led[0]}  <= 17'b0;
      Green_Led[0]  <=  8'b0;
      {Lcd_Control[3][7],Lcd_Control[1][2:0],Lcd_Control[0]}   <= 12'b0;
	   end else if(i_lsu_wren) begin
	       if((32'h00007000 <= i_lsu_addr) && (i_lsu_addr <= 32'h0000700F )) begin  // Write for Red Led
						case(funct3) 
							3'b010: begin  //Store word
								Red_Led[i_lsu_addr    - 32'h00007000]    = i_st_data[ 7: 0];
								Red_Led[i_lsu_addr +1 - 32'h00007000]    = i_st_data[15: 8];
								Red_Led[i_lsu_addr +2 - 32'h00007000]    = i_st_data[23:16];
								Red_Led[i_lsu_addr +3 - 32'h00007000]    = i_st_data[31:24];
							end
							3'b001: begin //Stor half
								Red_Led[i_lsu_addr    - 32'h00007000]    = i_st_data[ 7: 0];
								Red_Led[i_lsu_addr +1 - 32'h00007000]    = i_st_data[15: 8];
							end
							3'b000: begin
								Red_Led[i_lsu_addr    - 32'h00007000]    = i_st_data[ 7: 0];
							end
					  endcase
				 end
         if((32'h00007010 <= i_lsu_addr) && (i_lsu_addr <= 32'h0000701F )) begin
						case(funct3) 
							3'b010: begin  //Store word
								Green_Led[i_lsu_addr    - 32'h00007010]    = i_st_data[ 7: 0];
								Green_Led[i_lsu_addr +1 - 32'h00007010]    = i_st_data[15: 8];
								Green_Led[i_lsu_addr +2 - 32'h00007010]    = i_st_data[23:16];
								Green_Led[i_lsu_addr +3 - 32'h00007010]    = i_st_data[31:24];
							end
							3'b001: begin  //Store half
								Green_Led[i_lsu_addr    - 32'h00007010]    = i_st_data[ 7: 0];
								Green_Led[i_lsu_addr +1 - 32'h00007010]    = i_st_data[15: 8];
							end
							3'b000: begin  //Store byte
								Green_Led[i_lsu_addr    - 32'h00007010]    = i_st_data[ 7: 0];
							end
					  endcase
				end
				if((32'h00007020 <= i_lsu_addr) && (i_lsu_addr <= 32'h00007027 )) begin
					case(funct3) 
							3'b010: begin  //Store byte
								Seven_Segment[i_lsu_addr    - 32'h00007020]    = i_st_data[ 7: 0];
								Seven_Segment[i_lsu_addr +1 - 32'h00007020]    = i_st_data[15: 8];
								Seven_Segment[i_lsu_addr +2 - 32'h00007020]    = i_st_data[23:16];
								Seven_Segment[i_lsu_addr +3 - 32'h00007020]    = i_st_data[31:24];
							end
							3'b001: begin
								Seven_Segment[i_lsu_addr    - 32'h00007020]    = i_st_data[ 7: 0];
								Seven_Segment[i_lsu_addr +1 - 32'h00007020]    = i_st_data[15: 8];
							end
							3'b000: begin
								Seven_Segment[i_lsu_addr    - 32'h00007020]    = i_st_data[ 7: 0];
							end
					  endcase
				end
				if((32'h00007030 <= i_lsu_addr) && (i_lsu_addr <= 32'h0000703F )) begin
					case(funct3) 
							3'b010: begin  //Store byte
								Lcd_Control[i_lsu_addr    - 32'h00007030]    = i_st_data[ 7: 0];
								Lcd_Control[i_lsu_addr +1 - 32'h00007030]    = i_st_data[15: 8];
								Lcd_Control[i_lsu_addr +2 - 32'h00007030]    = i_st_data[23:16];
								Lcd_Control[i_lsu_addr +3 - 32'h00007030]    = i_st_data[31:24];
							end
							3'b001: begin
								Lcd_Control[i_lsu_addr    - 32'h00007030]    = i_st_data[ 7: 0];
								Lcd_Control[i_lsu_addr +1 - 32'h00007030]    = i_st_data[15: 8];
							end
							3'b000: begin
								Lcd_Control[i_lsu_addr    - 32'h00007030]    = i_st_data[ 7: 0];
							end
					 endcase
				end
        if(i_lsu_addr == 32'h00007040) begin
			     case(funct3) 
							3'b010: begin  //Store byte
								connection_timmer_1 = i_st_data;
							end
							3'b001: begin
								connection_timmer_1 = {16'b0, i_st_data[15:0]};
							end
							3'b000: begin
								connection_timmer_1 = {24'b0, i_st_data[7:0]};
							end
					 endcase
					   Seven_Segment[0] = connection_timmer_3[0];
					   Seven_Segment[1] = connection_timmer_3[1];
					   Seven_Segment[2] = connection_timmer_3[2];
					   Seven_Segment[3] = connection_timmer_3[3];
					   Seven_Segment[4] = connection_timmer_3[4];
					   Seven_Segment[5] = connection_timmer_3[5];
					   Seven_Segment[6] = connection_timmer_3[6];
					   Seven_Segment[7] = connection_timmer_3[7];
				end
	   end
	end	
	   always_ff @(negedge i_clk) begin		
	        if((32'h00007800 <= i_lsu_addr) && (i_lsu_addr <= 32'h0000780F )) begin
					case (funct3)
                3'b000: begin    // Load byte (Signed)
                    o_ld_data = {{24{Switches[i_lsu_addr - 32'h00007800][7]}}, Switches[i_lsu_addr - 32'h00007800][7:0]};
                end
                3'b001: begin    // Load halfword (Signed)
                    o_ld_data = {{16{Switches[i_lsu_addr - 32'h00007800 + 1][7]}}, Switches[i_lsu_addr - 32'h00007800 + 1][7:0], Switches[i_lsu_addr - 32'h00007800][7:0]};
                end
                3'b010: begin    // Load word
                    o_ld_data = {Switches[i_lsu_addr - 32'h00007800 + 3][7:0], Switches[i_lsu_addr - 32'h00007800 + 2][7:0], Switches[i_lsu_addr - 32'h00007800 + 1][7:0], Switches[i_lsu_addr - 32'h00007800][7:0]};
                end    
                3'b100: begin    // Load byte (Unsigned)
                    o_ld_data = {24'b0, Switches[i_lsu_addr - 32'h00007800][7:0]};
                end
                3'b101: begin    // Load halfword (Unsigned)
                    o_ld_data = {16'b0, Switches[i_lsu_addr - 32'h00007800 + 1][7:0], Switches[i_lsu_addr - 32'h00007800][7:0]};
                end
                default: o_ld_data = 0;
            endcase
			end
	end

endmodule
	

module instruction_memory(  //CHECKED                      /*----------------Already Checked-----------------*/
	input logic  [31:0] pc,
	output logic [31:0] instr
);
    reg [31:0] instruction_memory [2047:0]; 
    logic [31:0] temp;    
    // Initialize the ROM with the program instruction
    initial begin
         $readmemh("code.mem", instruction_memory);  
	 end
    //
    always @(pc) begin
      temp  = pc[31:2];
      instr = instruction_memory[temp];
    end
endmodule

module mux1(                                                /*----------------Already Checked-----------------*/
	input logic  [31:0] alu_data,
	input logic  [31:0] pc_four ,
	input logic         pc_sel  ,
	output logic [31:0] pc_next
);
	assign pc_next = pc_sel ? alu_data : pc_four;
endmodule

module imm_gen(                                             /*----------------Already Checked-----------------*/
    input logic  [31:0] instruction,                        /*----Check: I, Load, S, B, U, J, AUIPC, JALR-----*/
    output logic [31:0] imm_out
);
    always_comb begin
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

module add4(                                                 /*----------- Already Checked----------------*/
	input  logic [31:0] pc,
	output logic [31:0] pc_four
);
	assign	pc_four = pc + 4;
endmodule

module mux3(                                                 /*----------- Already Checked----------------*/
	input logic  [31:0] rs2_data ,
	input logic  [31:0] imm_gen  ,
	input logic         opb_sel  ,
	output logic [31:0] operand_b
);
	assign operand_b = opb_sel ? imm_gen : rs2_data;
endmodule

module regfile (                                              /*----------- Already Checked----------------*/
    input logic  [31:0] i_rd_data ,
    input logic  [ 4:0] i_rd_addr ,
    input logic         i_rd_wren ,
    input logic         i_clk     ,
    input logic         i_rst     ,
    input logic  [ 4:0] i_rs1_addr,
    input logic  [ 4:0] i_rs2_addr,
    output logic [31:0] o_rs1_data,
    output logic [31:0] o_rs2_data,
    output logic [31:0] REG  [31:0] 
);

    reg [31:0] registerfile [31:0];

    always @(posedge i_clk or negedge i_rst ) begin
        if (~i_rst) begin
            for (int i = 0; i < 32; i++) begin
                registerfile[i]     <= 32'b0   ;
            end
                   /*Place_Holder*/                         /*----------Having some thing for DMEM_DEPT---------------*/
        end else if(i_rd_wren && (i_rd_addr != 32'b0)) begin
            registerfile[i_rd_addr] <= i_rd_data;
        end
    end
    
    assign    o_rs1_data = registerfile[i_rs1_addr];
    assign    o_rs2_data = registerfile[i_rs2_addr];
    
    assign REG = registerfile;
     
endmodule

module bin2bcd #(parameter W = 32 ) // Input width
(
  input      [      W-1:0] in , // Binary input
  output reg [W+(W-4)/3:0] bcd  // BCD output
);

  integer i, j;

  always @(*) begin
    // Initialize the BCD output with zeros
    for (i = 0; i <= W + (W-4)/3; i = i + 1)
      bcd[i] = 0;

    // Copy the binary input to the BCD output
    bcd[W-1:0] = in;

    // Convert the binary input to BCD representation
    for (i = 0; i <= W - 4; i = i + 1) begin
      for (j = 0; j <= i/3; j = j + 1) begin
        if (bcd[W - i + 4*j -: 4] > 4) begin
          // If the binary value is greater than 4, add 3 to it
          bcd[W-i+4*j-:4] = bcd[W - i + 4*j -: 4] + 4'd3;
        end
      end
    end
  end
endmodule

module SevenSegmentControl (
  input  wire [31:0] val,
  output wire [ 6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
);

// Define a 7-segment display lookup table for hexadecimal digits
// Each element corresponds to the 7 segments (a, b, c, d, e, f, g)
  wire [6:0] seven_segment[16];

  generate
    assign seven_segment[0] = 7'b1000000;  // 0
    assign seven_segment[1] = 7'b1111001;  // 1
    assign seven_segment[2] = 7'b0100100;  // 2
    assign seven_segment[3] = 7'b0110000;  // 3
    assign seven_segment[4] = 7'b0011001;  // 4
    assign seven_segment[5] = 7'b0010010;  // 5
    assign seven_segment[6] = 7'b0000010;  // 6
    assign seven_segment[7] = 7'b1111000;  // 7
    assign seven_segment[8] = 7'b0000000;  // 8
    assign seven_segment[9] = 7'b0010000;  // 9
    assign seven_segment[10] = 7'b0001000; // A
    assign seven_segment[11] = 7'b0000011; // B
    assign seven_segment[12] = 7'b1000110; // C
    assign seven_segment[13] = 7'b0100001; // D
    assign seven_segment[14] = 7'b0000110; // E
    assign seven_segment[15] = 7'b0001110; // F
  endgenerate

  wire [3:0] val0, val1, val2, val3, val4, val5, val6, val7;
  assign {val7, val6, val5, val4, val3, val2, val1, val0} = val;

// Map val values to 7-segment displays
  assign HEX0 = seven_segment[val0];
  assign HEX1 = seven_segment[val1];
  assign HEX2 = seven_segment[val2];
  assign HEX3 = seven_segment[val3];
  assign HEX4 = seven_segment[val4];
  assign HEX5 = seven_segment[val5];
  assign HEX6 = seven_segment[val6];
  assign HEX7 = seven_segment[val7];

endmodule


















