`timescale 1ns / 1ps

module IdExRegisters (

		input clock,
		input reset,

		input [31:0] id_pc_4,
		input [31:0] id_instruction,

		input id_isJump,
		input [25:0] id_jumpIndex,
		input id_isJumpAndLink,
		input id_isJumpRegister,

		input id_isBranch,
		input id_isBneElseBeq,

		input [4:0] id_aluOperation,
		input id_shouldAluUseShiftAmountElseRegisterRs,
		input id_shouldAluUseImmeidateElseRegisterRt,

		input id_shouldWriteRegister,
		input id_shouldWriteMemoryElseAluOutputToRegister,
		input id_shouldWriteToRegisterRtElseRd,
		input id_shouldWriteMemory,

		input [31:0] id_shiftAmount,
		input [31:0] id_immediate,

		input [31:0] id_registerRs,
		input [31:0] id_registerRt,

		input id_shouldStall,
		input id_shouldForwardRegisterRs,
		input id_shouldForwardRegisterRt,

		output reg [31:0] ex_pc_4 = 0,
		output reg [31:0] ex_instruction = 0,
		output reg ex_isJump = 0,
		output reg [25:0] ex_jumpIndex = 0,
		output reg ex_isJumpAndLink = 0,
		output reg ex_isJumpRegister = 0,

		output reg ex_isBranch = 0,
		output reg ex_isBneElseBeq = 0,

		output reg [4:0] ex_aluOperation = 0,
		output reg ex_shouldAluUseShiftAmountElseRegisterRs = 0,
		output reg ex_shouldAluUseImmeidateElseRegisterRt = 0,

		output reg ex_shouldWriteRegister = 0,
		output reg ex_shouldWriteMemoryElseAluOutputToRegister = 0,
		output reg ex_shouldWriteToRegisterRtElseRd = 0,
		output reg ex_shouldWriteMemory = 0,

		output reg [31:0] ex_shiftAmount = 0,
		output reg [31:0] ex_immediate = 0,

		output reg [31:0] ex_registerRs = 0,
		output reg [31:0] ex_registerRt = 0,

		output reg ex_shouldForwardRegisterRs = 0,
		output reg ex_shouldForwardRegisterRt = 0
	);

	always @(posedge clock or posedge reset) begin

		if (reset) begin

			ex_pc_4 <= 0;
			ex_instruction <= 0;

			ex_isJump <= 0;
			ex_jumpIndex <= 0;
			ex_isJumpAndLink <= 0;
			ex_isJumpRegister <= 0;

			ex_isBranch <= 0;
			ex_isBneElseBeq <= 0;

			ex_aluOperation <= 0;
			ex_shouldAluUseShiftAmountElseRegisterRs <= 0;
			ex_shouldAluUseImmeidateElseRegisterRt <= 0;

			ex_shouldWriteRegister <= 0;
			ex_shouldWriteMemoryElseAluOutputToRegister <= 0;
			ex_shouldWriteToRegisterRtElseRd <= 0;
			ex_shouldWriteMemory <= 0;

			ex_shiftAmount <= 0;
			ex_immediate <= 0;

			ex_registerRs <= 0;
			ex_registerRt <= 0;

			ex_shouldForwardRegisterRs <= 0;
			ex_shouldForwardRegisterRt <= 0;

		end else begin

			ex_pc_4 <= id_pc_4;
			ex_instruction <= id_instruction;

			ex_isJump <= id_isJump;
			ex_jumpIndex <= id_jumpIndex;
			ex_isJumpAndLink <= id_isJumpAndLink;
			ex_isJumpRegister <= id_isJumpRegister;

			ex_isBranch <= id_isBranch;
			ex_isBneElseBeq <= id_isBneElseBeq;

			ex_aluOperation <= id_aluOperation;
			ex_shouldAluUseShiftAmountElseRegisterRs <= id_shouldAluUseShiftAmountElseRegisterRs;
			ex_shouldAluUseImmeidateElseRegisterRt <= id_shouldAluUseImmeidateElseRegisterRt;

			ex_shouldWriteRegister <= id_shouldWriteRegister;
			ex_shouldWriteMemoryElseAluOutputToRegister <= id_shouldWriteMemoryElseAluOutputToRegister;
			ex_shouldWriteToRegisterRtElseRd <= id_shouldWriteToRegisterRtElseRd;
			ex_shouldWriteMemory <= id_shouldWriteMemory;

			ex_shiftAmount <= id_shiftAmount;
			ex_immediate <= id_immediate;

			ex_registerRs <= id_registerRs;
			ex_registerRt <= id_registerRt;

			ex_shouldForwardRegisterRs <= id_shouldForwardRegisterRs;
			ex_shouldForwardRegisterRt <= id_shouldForwardRegisterRt;
		end
	end
endmodule
