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
	output logic        pc_sel     ,
	output logic        o_insn_vld 
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
							7'b0000000: begin alu_op = 4'b0000; o_insn_vld = 1'b1; end
							7'b0100000: begin alu_op = 4'b0001; o_insn_vld = 1'b1; end
							default: o_insn_vld = 1'b0;
						endcase
					end
					3'b001: begin alu_op = 4'b0111; o_insn_vld = 1'b1; end
					3'b010: begin alu_op = 4'b0010; o_insn_vld = 1'b1; end
					3'b011: begin alu_op = 4'b0011; o_insn_vld = 1'b1; end
					3'b100: begin alu_op = 4'b0100; o_insn_vld = 1'b1; end
					3'b101: begin
						case(func7)
							7'b0000000: begin alu_op = 4'b1000; o_insn_vld = 1'b1; end
							7'b0100000: begin alu_op = 4'b1001; o_insn_vld = 1'b1; end
						endcase
					end
					3'b110: begin alu_op = 4'b0101; o_insn_vld = 1'b1; end
					3'b111: begin alu_op = 4'b0110; o_insn_vld = 1'b1; end
					default: o_insn_vld = 1'b0;
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
					3'b000: begin alu_op = 4'b0000; o_insn_vld = 1'b1; end
					3'b010: begin alu_op = 4'b0010; o_insn_vld = 1'b1; end
					3'b011: begin alu_op = 4'b0011; o_insn_vld = 1'b1; end
					3'b100: begin alu_op = 4'b0100; o_insn_vld = 1'b1; end
					3'b110: begin alu_op = 4'b0101; o_insn_vld = 1'b1; end
					3'b111: begin alu_op = 4'b0110; o_insn_vld = 1'b1; end
					3'b001: begin alu_op = 4'b0111; o_insn_vld = 1'b1; end
					3'b101: begin
						case(func7)
							7'b0000000: begin alu_op = 4'b1000; o_insn_vld = 1'b1; end
							7'b0100000: begin alu_op = 4'b1001; o_insn_vld = 1'b1; end
							default: o_insn_vld = 1'b0;
						endcase
					end
				default: o_insn_vld = 1'b0;
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
				o_insn_vld = 1'b1; 
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
				o_insn_vld = 1'b1; 
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
						o_insn_vld = 1'b1; 
					end
					3'b001: begin
						br_un  = 1'b0;
						pc_sel = ~br_equal;
						o_insn_vld = 1'b1; 
					end
					3'b100: begin
						br_un  = 1'b1;
						pc_sel = br_less;
						o_insn_vld = 1'b1; 
					end
					3'b101: begin
						br_un  = 1'b1;
						pc_sel = ~br_less;
						o_insn_vld = 1'b1; 
					end
					3'b110: begin
						br_un  = 1'b0;
						pc_sel = br_less;
						o_insn_vld = 1'b1; 
					end
					3'b111: begin
						br_un  = 1'b0;
						pc_sel = ~br_less;
						o_insn_vld = 1'b1; 
					end
					default: o_insn_vld = 1'b0;
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
				o_insn_vld = 1'b1; 
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
				o_insn_vld = 1'b1; 
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
				o_insn_vld = 1'b1;
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
				o_insn_vld = 1'b1; 
			end
			default: o_insn_vld = 1'b0;
		endcase	
	end
endmodule
