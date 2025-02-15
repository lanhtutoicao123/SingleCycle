module regfile (                                              /*----------- Already Checked----------------*/
    input logic  [31:0] i_rd_data ,
    input logic  [ 4:0] i_rd_addr ,
    input logic         i_rd_wren ,
    input logic         i_clk     ,
    input logic         i_rst     ,
    input logic  [ 4:0] i_rs1_addr,
    input logic  [ 4:0] i_rs2_addr,
    output logic [31:0] o_rs1_data,
    output logic [31:0] o_rs2_data
    //output logic [31:0] REG  [31:0] 
);


    reg [31:0] registerfile [31:0];

    always @(posedge i_clk or negedge i_rst ) begin
        if (~i_rst) begin
            for (int i = 0; i < 32; i++) begin
                registerfile[i]     <= 32'b0   ;
            end
                   /*Place_Holder*/                         
        end else if(i_rd_wren && (i_rd_addr != 32'b0)) begin
            registerfile[i_rd_addr] <= i_rd_data;
        end
    end
    
    assign    o_rs1_data = registerfile[i_rs1_addr];
    assign    o_rs2_data = registerfile[i_rs2_addr];
    
   // assign REG = registerfile;
     
endmodule

