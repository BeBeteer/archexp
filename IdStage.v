`timescale 1ns / 1ps

module IdStage (

		input clock,
		input reset,

		input [31:0] pc_4,

		input [31:0] instruction,

		output shouldJumpOrBranch,	// BRANCH
		output [31:0] jumpOrBranchPc,

		output [31:0] shiftAmount,
		output [31:0] immediate,

		output [31:0] registerRsOrPc_4,
		output [31:0] registerRtOrZero,

		output [3:0] aluOperation,	// ALUC
		output shouldAluUseShiftAmountElseRegisterRsOrPc_4,	// SHIFT
		output shouldAluUseImmeidateElseRegisterRtOrZero,	// ALUIMM

		output shouldWriteRegister,	// WREG
		output [4:0] registerWriteAddress,
		output shouldWriteMemoryElseAluOutputToRegister,	// M2REG

		output shouldWriteMemory,	// WMEM

		input wb_shouldWriteRegister,
		input [4:0] wb_registerWriteAddress,
		input [31:0] wb_registerWriteData,

		output shouldStall,	// WPCIR

		output [32 * 32 - 1 : 0] debug_registers
	);

	wire isJumpIndex;	// JUMP
	wire [25:0] jumpIndex;	// address
	wire isJumpRegister;	// JR
	wire isRegisterRsRtEqual;	// RSRTEQU
	wire isJumpAndLink;	// JAL
	wire shouldSignElseZeroExtendImmediate;	// SEXT
	wire shouldWriteToRegisterRtElseRd;	// REGRT
	wire [1:0] registerRsForwardControl;	// FWDA
	wire [1:0] registerRtForwardControl;	// FWDB
	ControlUnit controlUnit (

		.instruction(instruction[31:0]),

		.isJumpIndex(isJumpIndex),
		.jumpIndex(jumpIndex[25:0]),
		.isJumpRegister(isJumpRegister),
		.isRegisterRsRtEqual(isRegisterRsRtEqual),
		.shouldJumpOrBranch(shouldJumpOrBranch),
		.isJumpAndLink(isJumpAndLink),

		.shouldSignElseZeroExtendImmediate(shouldSignElseZeroExtendImmediate),

		.aluOperation(aluOperation[3:0]),
		.shouldAluUseShiftAmountElseRegisterRsOrPc_4(shouldAluUseShiftAmountElseRegisterRsOrPc_4),
		.shouldAluUseImmeidateElseRegisterRtOrZero(shouldAluUseImmeidateElseRegisterRtOrZero),

		.shouldWriteRegister(shouldWriteRegister),
		.shouldWriteToRegisterRtElseRd(shouldWriteToRegisterRtElseRd),
		.shouldWriteMemoryElseAluOutputToRegister(shouldWriteMemoryElseAluOutputToRegister),

		.shouldWriteMemory(shouldWriteMemory),

		.shouldStall(shouldStall),
		.registerRsForwardControl(registerRsForwardControl[1:0]),
		.registerRtForwardControl(registerRtForwardControl[1:0])
	);

	assign shiftAmount = {27'b0, instruction[10:6]};
	wire [15:0] instructionImmediate = instruction[15:0];
	assign immediate = {
			shouldSignElseZeroExtendImmediate ? {16{instructionImmediate[15]}} : 16'b0,
			instructionImmediate
	};

	wire [4:0] rs = instruction[25:21];
	wire [4:0] rt = instruction[20:16];
	wire [4:0] rd = instruction[15:11];

	assign registerWriteAddress =
			isJumpAndLink ? 5'd31
			: shouldWriteToRegisterRtElseRd ? rt : rd;

	wire [31:0] localRegisterRs;
	wire [31:0] localRegisterRt;
	RegisterFile registerFile (

		.clock(clock),
		.reset(reset),

		.readAddressA(rs[4:0]),
		.readDataA(localRegisterRs[31:0]),
		.readAddressB(rt[4:0]),
		.readDataB(localRegisterRt[31:0]),

		.shouldWrite(wb_shouldWriteRegister),
		.writeAddress(wb_registerWriteAddress[4:0]),
		.writeData(wb_registerWriteData[31:0]),

		.debug_registers(debug_registers[32 * 32 - 1 : 0])
	);

	// TODO: Forwarding
	wire [31:0] registerRs = localRegisterRs;
	wire [31:0] registerRt = localRegisterRt;

	assign registerRsOrPc_4 = isJumpAndLink ? pc_4 : registerRs;
	assign registerRtOrZero = isJumpAndLink ? 32'b0 : registerRt;

	assign isRegisterRsRtEqual = registerRs == registerRt;
	wire jumpIndexPc = {pc_4[31:28], jumpIndex, 2'b0};
	wire branchPc = pc_4 + {immediate[29:0], 2'b0};
	assign jumpOrBranchPc =
			isJumpRegister ? registerRs
			: isJumpIndex ? jumpIndexPc
			: branchPc;
endmodule
