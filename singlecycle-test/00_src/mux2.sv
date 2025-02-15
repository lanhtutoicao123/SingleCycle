
module mux2(                                       /*----------------Already Checked-----------------*/
	input logic  [31:0] pc,
	input logic  [31:0] rs1_data,
	input logic         opa_sel,
	output logic [31:0] operand_a  
);
	assign operand_a = opa_sel ? rs1_data : pc;
endmodule
