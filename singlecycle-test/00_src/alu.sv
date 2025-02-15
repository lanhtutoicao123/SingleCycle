// Arithmetic Logic Unit
module alu(
    input logic  [31:0] i_operand_a,
    input logic  [31:0] i_operand_b,
    input logic  [ 3:0] i_alu_op,
    output logic [31:0] o_alu_data
);

// Define constant values
localparam [31:0] ONE = 32'h0000_0001;
localparam [31:0] ZERO = 32'h0000_0000;
localparam logic [31:0] COMP_ONE = 32'b1000_0000_0000_0000_0000_0000_0000_0000;

// Declaring inputs


// Declaring output
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

// ALU operation process
always @(*) begin
    case (i_alu_op)
        OP_ADD: o_alu_data = func_add(i_operand_a, i_operand_b);   // Add operation
        OP_SUB: o_alu_data = func_sub(i_operand_a, i_operand_b);   // Subtract operation
        OP_SLT: o_alu_data = func_slt(i_operand_a, i_operand_b);   // Signed comparison
        OP_SLTU: o_alu_data = func_sltu(i_operand_a, i_operand_b); // Unsigned comparison
        OP_XOR: o_alu_data = i_operand_a ^ i_operand_b;            // XOR operation
        OP_OR: o_alu_data = i_operand_a | i_operand_b;             // OR operation
        OP_AND: o_alu_data = i_operand_a & i_operand_b;            // AND operation
        OP_SLL: o_alu_data = func_sll(i_operand_a, i_operand_b[4:0]);   // Shift left operation
        OP_SRL: o_alu_data = func_srl(i_operand_a, i_operand_b[4:0]);   // Shift right operation
        OP_SRA: o_alu_data = func_sra(i_operand_a, i_operand_b[4:0]);   // Arithmetic shift right
        OP_OUTPUT_B: o_alu_data = i_operand_b;
        default: o_alu_data = ZERO; // Default case
    endcase
end

// Function definitions go here...

// Function to perform addition
function [31:0] func_add;
    input [31:0] i_a, i_b;
    begin
        func_add = i_a + i_b;
    end
endfunction

// Function to perform subtraction (two's complement)
function [31:0] func_sub;
    input [31:0] i_a, i_b;
    begin
        func_sub = i_a + (~i_b + ONE);
    end
endfunction

    // Function to perform signed Set Less Than (SLT)
    function [31:0] func_slt;
        input [31:0] i_a;
        input [31:0] i_b;

        reg [32:0] temp;

        begin
            
            // Calculate the difference between a and b
            temp = {1'b0, i_a} + ~{1'b0, i_b} + 32'b1;

            if(i_a[31] ^ i_b[31] == 1'b0) func_slt = {31'b0,temp[31]};

            else func_slt = {31'b0,i_a[31]};
        end
    endfunction

    // Function to perform unsigned Set Less Than (SLTU)
    function [31:0] func_sltu;
        input [31:0] i_a;
        input [31:0] i_b;

        reg [32:0] temp;

        begin
            // Subtract b from a and check if the result is negative
            temp = {1'b0, i_a} + ~{1'b0, i_b} + 32'b1;
            
            // If the result is negative (MSB is 1), a < b
            func_sltu = {31'b0,temp[32]};
        end
    endfunction

// Function to perform Shift Left Logical (SLL)
function [31:0] func_sll;
    input [31:0] i_a;    // The value to be shifted
    input [4:0] i_b;     // The amount of shift (max 31)

    reg [31:0] shift1_out;
    reg [31:0] shift2_out;
    reg [31:0] shift3_out;
    reg [31:0] shift4_out;

    begin

        shift1_out = 32'b0;
        shift2_out = 32'b0;
        shift3_out = 32'b0;
        shift4_out = 32'b0;

        // Stage 1: Shift 1 bit if i_b[0] is 1
        shift1_out = i_b[0] ? {i_a[30:0], 1'b0} : i_a;
        
        // Stage 2: Shift 2 bits if i_b[1] is 1
        shift2_out = i_b[1] ? {shift1_out[29:0], 2'b0} : shift1_out;
        
        // Stage 3: Shift 4 bits if i_b[2] is 1
        shift3_out = i_b[2] ? {shift2_out[27:0], 4'b0} : shift2_out;
        
        // Stage 4: Shift 8 bits if i_b[3] is 1
        shift4_out = i_b[3] ? {shift3_out[23:0], 8'b0} : shift3_out;
        
        // Final stage: Shift 16 bits if i_b[4] is 1
        func_sll = i_b[4] ? {shift4_out[15:0], 16'b0} : shift4_out;
    end
endfunction

// Function to perform Logical Shift Right (SRL)
function [31:0] func_srl;
    input [31:0] i_a;  // Input value to be shifted
    input [4:0] i_b;   // Shift amount (0 to 31)

    reg [31:0] result; // Intermediate result at each stage

    begin
        result = i_a;  // Start with the initial input value

        // Apply shifts in stages based on each bit in i_b
        if (i_b[0]) result = {1'b0, result[31:1]};        // Shift 1 bit
        if (i_b[1]) result = {2'b00, result[31:2]};       // Shift 2 bits
        if (i_b[2]) result = {4'b0000, result[31:4]};     // Shift 4 bits
        if (i_b[3]) result = {8'b00000000, result[31:8]}; // Shift 8 bits
        if (i_b[4]) result = {16'b0000000000000000, result[31:16]}; // Shift 16 bits

        func_srl = result; // Assign the final result to the function output
    end
endfunction

// Function for SRA (Arithmetic Shift Right)
function [31:0] func_sra;
    input [31:0] i_a;
    input [4:0] i_b; // shift amount (max 31 bits)

    reg [31:0] shift1_out;
    reg [31:0] shift2_out;
    reg [31:0] shift3_out;
    reg [31:0] shift4_out;

    begin
        shift1_out = 32'b0;
        shift2_out = 32'b0;
        shift3_out = 32'b0;
        shift4_out = 32'b0;

        // Stage 1: Shift 1 bit if i_b[0] = 1, filling with sign bit
        shift1_out = i_b[0] ? {{1{i_a[31]}}, i_a[31:1]} : i_a;
        
        // Stage 2: Shift 2 bits if i_b[1] = 1, filling with sign bit
        shift2_out = i_b[1] ? {{2{shift1_out[31]}}, shift1_out[31:2]} : shift1_out;

        // Stage 3: Shift 4 bits if i_b[2] = 1, filling with sign bit
        shift3_out = i_b[2] ? {{4{shift2_out[31]}}, shift2_out[31:4]} : shift2_out;
        
        // Stage 4: Shift 8 bits if i_b[3] = 1, filling with sign bit
        shift4_out = i_b[3] ? {{8{shift3_out[31]}}, shift3_out[31:8]} : shift3_out;
        
        // Final stage: Shift 16 bits if i_b[4] = 1, filling with sign bit
        func_sra = i_b[4] ? {{16{shift4_out[31]}}, shift4_out[31:16]} : shift4_out;
    end
endfunction

endmodule
