module brc (   								 /*----------------Already Checked-----------------*/
  input  logic [31:0] rs1_data, rs2_data,
  input  logic        br_unsigned,
  output logic        br_less, br_equal
);

  addsub addsubcomp (
    .inA         (rs1_data   ),
    .inB         (rs2_data   ),
    .neg_sel     (1'b1       ),
    .unsigned_sel(br_unsigned),
    .result      (           ),
    .less_than   (br_less    ),
    .equal       (br_equal   )
  );

endmodule

module addsub (
  input  [31:0] inA         ,
  input  [31:0] inB         ,
  input         neg_sel     ,
  input         unsigned_sel,
  output [31:0] result      ,
  output        less_than   ,
  output        equal
);

  wire [32:0] extendedA, extendedB;
  assign extendedA = unsigned_sel ? {1'b0, inA} : {1'(inA[31]), inA};
  assign extendedB = unsigned_sel ? {1'b0, inB} : {1'(inB[31]), inB};

  wire [32:0] newB;
  assign newB = neg_sel ? (~extendedB + 1'b1) : extendedB;

  assign {less_than, result} = extendedA + newB;

  assign equal = (result == 32'd0);
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
