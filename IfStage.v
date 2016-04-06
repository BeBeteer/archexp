`timescale 1ns / 1ps

module IfStage (
		input clock,
		input mem_shouldBranch,	// ctrl_branch
		input [31:0] mem_branchPc,	// mem_pc
		output [31:0] pc_4,
		output [31:0] instruction
	);

	reg [31:0] pc = 0;

	assign pc_4 = pc + 4;

	always @(posedge clock) begin
		pc <= mem_shouldBranch ? mem_branchPc : pc_4;
	end

	InstructionMemory instructionMemory (
		.clka(~clock),
		.addra(pc[9:2]),
		.douta(instruction[31:0])
	);
endmodule
