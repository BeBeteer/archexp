`timescale 1ns / 1ps

module IdStage (

		input clock,
		input reset,

		input [31:0] instruction,	// id_inst

		output isJump,	// is_j
		output [25:0] jumpIndex,	// j_address
		output isJumpAndLink,	// is_jal
		output isJumpRegister,	// is_jr

		output isBranch,	// isBranch
		output isBneElseBeq,	// cu_bne_beq

		output [4:0] aluOperation,	// id_aluc
		output shouldAluUseShiftAmountElseRegisterA,	// cu_shift
		output shouldAluUseImmeidateElseRegisterB,	// cu_aluimm

		output shouldWriteRegister,	// cu_wreg
		output shouldWriteMemoryElseAluOutputToRegister,	// cu_m2reg
		output shouldWriteToRegisterRtElseRd,	// cu_regrt
		output shouldWriteMemory,	// cu_wmem

		output [31:0] shiftAmount,
		output [31:0] immediate,	// id_imm

		output [31:0] registerRs,	// id_inA
		output [31:0] registerRt,	// id_inB

		input wb_shouldWriteRegister,
		input [4:0] wb_registerWriteAddress,
		input [31:0] wb_registerWriteData,

		input [31:0] if_instruction,	// if_inst
		input [31:0] ex_instruction,	// ex_inst
		output shouldStall,	// stall
		output shouldForwardRegisterRs,	// fwda
		output shouldForwardRegisterRt	// fwdb
	);

	wire shouldSignElseZeroExtendImmediate;	// cu_sext

	ControlUnit controlUnit (

		.instruction(instruction[31:0]),

		.isJump(isJump),
		.jumpIndex(jumpIndex[25:0]),
		.isJumpAndLink(isJumpAndLink),
		.isJumpRegister(isJumpRegister),

		.isBranch(isBranch),
		.isBneElseBeq(isBneElseBeq),

		.shouldSignElseZeroExtendImmediate(shouldSignElseZeroExtendImmediate),
		.aluOperation(aluOperation[4:0]),
		.shouldAluUseShiftAmountElseRegisterA(shouldAluUseShiftAmountElseRegisterA),
		.shouldAluUseImmeidateElseRegisterB(shouldAluUseImmeidateElseRegisterB),

		.shouldWriteRegister(shouldWriteRegister),
		.shouldWriteMemoryElseAluOutputToRegister(shouldWriteMemoryElseAluOutputToRegister),
		.shouldWriteToRegisterRtElseRd(shouldWriteToRegisterRtElseRd),
		.shouldWriteMemory(shouldWriteMemory),

		.if_instruction(if_instruction[31:0]),
		.ex_instruction(ex_instruction[31:0]),
		.shouldStall(shouldStall),
		.shouldForwardRegisterRs(shouldForwardRegisterRs),
		.shouldForwardRegisterRt(shouldForwardRegisterRt)
	);

	wire [15:0] instructionImmediate = instruction[15:0];
	assign immediate = {
			shouldSignElseZeroExtendImmediate ? {16{instructionImmediate[15]}} : 16'b0,
			instructionImmediate
	};
	assign shiftAmount = {27'b0, instruction[10:6]};

	wire [4:0] rs = instruction[25:21];
	wire [4:0] rt = instruction[20:16];
	RegisterFile registerFile (

		.clock(clock),
		.reset(reset),

		.readAddressA(rs[4:0]),
		.readDataA(registerRs[31:0]),
		.readAddressB(rt[4:0]),
		.readDataB(registerRt[31:0]),

		.shouldWrite(wb_shouldWriteRegister),
		.writeAddress(wb_registerWriteAddress[4:0]),
		.writeData(wb_registerWriteData[31:0])
	);
endmodule
