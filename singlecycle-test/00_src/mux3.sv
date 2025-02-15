module mux3(                                                 /*----------- Already Checked----------------*/
	input logic  [31:0] rs2_data ,
	input logic  [31:0] imm_gen  ,
	input logic         opb_sel  ,
	output logic [31:0] operand_b
);
	assign operand_b = opb_sel ? imm_gen : rs2_data;
endmodule
