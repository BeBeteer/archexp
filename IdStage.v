`timescale 1ns / 1ps

module IdStage (

		input clock,

		input [31:0] instruction,	// id_inst
		input [31:0] if_instruction,	// if_inst
		input [31:0] ex_instruction,	// ex_inst

		output isJump,	// is_j
		output jumpIndex,	// j_address
		output isBneElseBeq,	// cu_bne_beq
		output isBranch,	// isBranch
		output isJumpRegister,	// is_jr

		output [31:0] immediate,
		output [4:0] aluOperation,	// cu_aluc
		output shouldAluUseShiftAmountElseRegisterA,	// cu_shift
		output shouldAluUseImmeidateElseRegisterB,	// cu_aluimm

		output shouldWriteRegister,	// cu_wreg
		output shouldWriteMemoryElseAluOutputToRegister,	// cu_m2reg
		output shouldWriteToRegisterRtElseRd,	// cu_regrt
		output shouldWriteMemory,	// cu_wmem

		output shouldStall,	// stall
		output shouldForwardRegisterA,	// fwda
		output shouldForwardRegisterB	// fwdb
	);

	wire shouldSignElseZeroExtendImmediate;	// cu_sext

	ControlUnit controlUnit (

		.instruction(instruction[31:0]),
		.if_instruction(if_instruction[31:0]),
		.ex_instruction(ex_instruction[31:0]),

		.isJump(isJump),
		.jumpIndex(jumpIndex),
		.isBneElseBeq(isBneElseBeq),
		.isBranch(isBranch),
		.isJumpRegister(isJumpRegister),

		.shouldSignElseZeroExtendImmediate(shouldSignElseZeroExtendImmediate),
		.aluOperation(aluOperation[4:0]),
		.shouldAluUseShiftAmountElseRegisterA(shouldAluUseShiftAmountElseRegisterA),
		.shouldAluUseImmeidateElseRegisterB(shouldAluUseImmeidateElseRegisterB),

		.shouldWriteRegister(shouldWriteRegister),
		.shouldWriteMemoryElseAluOutputToRegister(shouldWriteMemoryElseAluOutputToRegister),
		.shouldWriteToRegisterRtElseRd(shouldWriteToRegisterRtElseRd),
		.shouldWriteMemory(shouldWriteMemory),

		.shouldStall(shouldStall),
		.shouldForwardRegisterA(shouldForwardRegisterA),
		.shouldForwardRegisterB(shouldForwardRegisterB)
	);

	wire [15:0] instructionImmediate = instruction[15:0];
	assign immediate = {
			shouldSignElseZeroExtendImmediate ? {16{instructionImmediate[15]}} : 16'b0,
			instructionImmediate
	};
endmodule
