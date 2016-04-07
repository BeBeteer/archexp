`timescale 1ns / 1ps

module Cpu (
		input clock,
		input reset
	);

	wire [31:0] if_pc_4;
	wire [31:0] if_instruction;

	wire [31:0] id_pc_4;
	wire [31:0] id_instruction;

	wire [31:0] ex_pc_4;
	wire [31:0] ex_instruction;

	wire mem_shouldBranch;
	wire [31:0] mem_branchPc;

	IfStage ifStage (

		.clock(clock),
		.reset(reset),

		.mem_shouldBranch(mem_shouldBranch),
		.mem_branchPc(mem_branchPc),

		.pc_4(if_pc_4[31:0]),
		.instruction(if_instruction[31:0])
	);

	IfIdRegisters ifIdRegisters (

		.clock(clock),
		.reset(reset),

		.if_pc_4(if_pc_4[31:0]),
		.if_instruction(if_instruction[31:0]),

		.id_pc_4(id_pc_4[31:0]),
		.id_instruction(id_instruction[31:0])
	);

	IdStage idStage (

		.clock(clock),
		.reset(reset),

		.instruction(id_instruction[31:0]),
		.if_instruction(if_instruction[31:0]),
		.ex_instruction(ex_instruction[31:0])

		// TODO
	);

	IdExRegisters idExRegisters (

		.clock(clock),
		.reset(reset),

		.id_pc_4(id_pc_4[31:0]),
		.id_instruction(id_instruction[31:0]),

		.ex_pc_4(ex_pc_4[31:0]),
		.ex_instruction(ex_instruction[31:0])
	);
endmodule
