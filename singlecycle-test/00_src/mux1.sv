module mux1(                                                /*----------------Already Checked-----------------*/
	input logic  [31:0] alu_data,
	input logic  [31:0] pc_four ,
	input logic         pc_sel  ,
	output logic [31:0] pc_next
);
	assign pc_next = pc_sel ? alu_data : pc_four;
endmodule
