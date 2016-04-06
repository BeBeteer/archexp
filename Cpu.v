`timescale 1ns / 1ps

module Cpu(
		input clock
	);

	wire [31:0] if_pc_4;
	wire [31:0] if_instruction;

	wire [31:0] id_pc_4;
	wire [31:0] id_instruction;

	wire mem_shouldBranch;
	wire [31:0] mem_branchPc;

	IfStage ifStage (
		.clock(clock),
		.mem_shouldBranch(mem_shouldBranch),
		.mem_branchPc(mem_branchPc),
		.pc_4(if_pc_4[31:0]),
		.instruction(if_instruction[31:0])
	);

	IfIdRegisters ifIdRegisters (
		.clock(clock),
		.if_pc_4(if_pc_4[31:0]),
		.if_instruction(If_instruction[31:0]),
		.id_pc_4(id_pc_4[31:0]),
		.id_instruction(Id_instruction[31:0])
	);
endmodule
