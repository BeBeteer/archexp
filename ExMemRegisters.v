`timescale 1ns / 1ps

module ExMemRegisters (

		input clock,
		input reset,

		input [31:0] ex_pc_4,
		input [31:0] ex_instruction,

		input ex_isJump,
		input [25:0] ex_jumpIndex,
		input ex_isJumpAndLink,
		input ex_isJumpRegister,

		input ex_isBranch,
		input ex_isBneElseBeq,
		input [31:0] ex_isAluOutputZero,
		input [31:0] ex_branchPc,

		input [31:0] ex_aluOutput,

		input ex_shouldWriteRegister,
		input [4:0] ex_registerWriteAddress,
		input ex_shouldWriteMemoryElseAluOutputToRegister,

		input ex_shouldWriteMemory,

		input [31:0] ex_registerRt,

		output reg [31:0] mem_pc_4 = 0,
		output reg [31:0] mem_instruction = 0,

		output reg mem_isJump = 0,
		output reg [25:0] mem_jumpIndex = 0,
		output reg mem_isJumpAndLink = 0,
		output reg mem_isJumpRegister = 0,

		output reg mem_isBranch = 0,
		output reg mem_isBneElseBeq = 0,
		output reg [31:0] mem_isAluOutputZero = 0,
		output reg [31:0] mem_branchPc = 0,

		output reg [31:0] mem_aluOutput = 0,

		output reg mem_shouldWriteRegister = 0,
		output reg [4:0] mem_registerWriteAddress = 0,
		output reg mem_shouldWriteMemoryElseAluOutputToRegister = 0,

		output reg mem_shouldWriteMemory = 0,

		output reg [31:0] mem_registerRt = 0
	);

	always @(posedge clock or posedge reset) begin

		if (reset) begin

			mem_pc_4 <= 0;
			mem_instruction <= 0;

			mem_isJump <= 0;
			mem_jumpIndex <= 0;
			mem_isJumpAndLink <= 0;
			mem_isJumpRegister <= 0;

			mem_isBranch <= 0;
			mem_isBneElseBeq <= 0;
			mem_isAluOutputZero <= 0;
			mem_branchPc <= 0;

			mem_aluOutput <= 0;

			mem_shouldWriteRegister <= 0;
			mem_registerWriteAddress <= 0;
			mem_shouldWriteMemoryElseAluOutputToRegister <= 0;

			mem_shouldWriteMemory <= 0;

			mem_registerRt <= 0;

		end else begin

			mem_pc_4 <= ex_pc_4;
			mem_instruction <= ex_instruction;

			mem_isJump <= ex_isJump;
			mem_jumpIndex <= ex_jumpIndex;
			mem_isJumpAndLink <= ex_isJumpAndLink;
			mem_isJumpRegister <= ex_isJumpRegister;

			mem_isBranch <= ex_isBranch;
			mem_isBneElseBeq <= ex_isBneElseBeq;
			mem_isAluOutputZero <= ex_isAluOutputZero;
			mem_branchPc <= ex_branchPc;

			mem_aluOutput <= ex_aluOutput;

			mem_shouldWriteRegister <= ex_shouldWriteRegister;
			mem_registerWriteAddress <= ex_registerWriteAddress;
			mem_shouldWriteMemoryElseAluOutputToRegister <= ex_shouldWriteMemoryElseAluOutputToRegister;

			mem_shouldWriteMemory <= ex_shouldWriteMemory;

			mem_registerRt <= ex_registerRt;
		end
	end
endmodule
