
module instruction_memory(
    input  logic [31:0] pc,
    output logic [31:0] instr
);
    logic [7:0][3:0] imem [2**11-1:0];  // Single-dimensional memory

    // Initialize the ROM with the program instructions
    initial begin
        $readmemh("../02_test/dump/mem.dump", imem);
    end

    // Fetch instruction
    assign instr = imem[pc[12:2]];
endmodule

