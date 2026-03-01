module risc_immediate_cpu (
    input clk,
    input reset,
    output [7:0] R0,
    output [7:0] R1,
    output [7:0] R2,
    output [7:0] R3
);

    reg [3:0] PC;
    reg [7:0] IR;

    reg [7:0] reg_file [0:3];

    // Instruction fields
    wire [1:0] rd     = IR[7:6];
    wire [1:0] rs     = IR[5:4];
    wire [1:0] imm    = IR[3:2];
    wire [1:0] opcode = IR[1:0];

    parameter ADD  = 2'b00;
    parameter SUB  = 2'b01;
    parameter ADDI = 2'b10;

    reg [7:0] program [0:15];

    initial begin
        reg_file[0] = 5;
        reg_file[1] = 3;
        reg_file[2] = 0;
        reg_file[3] = 0;

        // Format: rd rs imm opcode
        program[0] = 8'b10_00_01_10; // ADDI R2 = R0 + 1
        program[1] = 8'b01_01_00_00; // ADD R1 = R1 + R0
        program[2] = 8'b11_01_01_10; // ADDI R3 = R1 + 1
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
        end else begin

            IR <= program[PC];
            PC <= PC + 1;

            case(opcode)

                ADD:
                    reg_file[rd] <= reg_file[rd] + reg_file[rs];

                SUB:
                    reg_file[rd] <= reg_file[rd] - reg_file[rs];

                ADDI:
                    reg_file[rd] <= reg_file[rs] + imm;

            endcase
        end
    end

    assign R0 = reg_file[0];
    assign R1 = reg_file[1];
    assign R2 = reg_file[2];
    assign R3 = reg_file[3];

endmodule