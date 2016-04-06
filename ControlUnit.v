`timescale 1ns / 1ps

`include "Constants.vh"

module ControlUnit(

		input [31:0] instruction,	// instr
		input [31:0] if_instruction,	// if_inst
		input [31:0] ex_instruction,	// ex_inst

		output isJump,	// is_j, J or JAL
		output [25:0] jumpIndex,	// j_address
		output isBneElseBeq,	// cu_bne_beq
		output isBranch,	// cu_branch, BEQ or BNE
		output isJumpRegister,	// is_jr, JR, but not JALR yet

		output shouldSignElseZeroExtendImmediate,	// cu_sext
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

	wire [5:0] code = instruction[31:26];
	wire [5:0] function_ = instruction[5:0];

	assign isJump = code == `CODE_J || code == `CODE_JAL;
	assign jumpIndex = instruction[25:0];
	assign isBneElseBeq = code == `CODE_BNE;
	assign isBranch = code == `CODE_BEQ || isBneElseBeq;
	wire isRType = code == `CODE_R_TYPE;
	// TODO: JALR
	assign isJumpRegister = isRType && function_ == FUNCTION_JR;

	assign shouldSignElseZeroExtendImmediate =
			code == `CODE_ADDI
			|| code == `CODE_ADDIU
			|| code == `CODE_LW
			|| code == `CODE_SW
			|| code == `CODE_BEQ
			|| code == `CODE_BNE
			|| code == `CODE_SLTI;
	assign aluOperation =
			isRType ? (
				function_ == `FUNCTION_ADD ? `ALU_ADD
				: function_ == `FUNCTION_ADDU ? `ALU_ADDU
				: function_ == `FUNCTION_SUB ? `ALU_SUB
				: function_ == `FUNCTION_SUBU ? `ALU_SUBU
				: function_ == `FUNCTION_AND ? `ALU_AND
				: function_ == `FUNCTION_OR ? `ALU_OR
				: function_ == `FUNCTION_XOR ? `ALU_XOR
				: function_ == `FUNCTION_NOR ? `ALU_NOR
				: function_ == `FUNCTION_SLT ? `ALU_SUB
				: function_ == `FUNCTION_SLTU ? `ALU_SUBU
				: function_ == `FUNCTION_SLL ? `ALU_SLL
				: function_ == `FUNCTION_SRL ? `ALU_SRL
				: function_ == `FUNCTION_SRA ? `ALU_SRA
				: function_ == `FUNCTION_SLLV ? `ALU_SLL
				: function_ == `FUNCTION_SRLV ? `ALU_SRL
				: function_ == `FUNCTION_SRAV ? `ALU_SRA
				: ALU_NONE
			) : code == `CODE_ADDI ? `ALU_ADD
			: code == `CODE_ADDIU ? `ALU_ADDU
			: code == `CODE_ANDI ? `ALU_AND
			: code == `CODE_ORI ? `ALU_OR
			: code == `CODE_XORI ? `ALU_XOR
			: code == `CODE_LUI ? `ALU_SLL	// HIGHLIGHT
			: code == `CODE_LW ? `ALU_ADD
			: code == `CODE_SW ? `ALU_ADD
			: code == `CODE_BEQ ? `ALU_SUB
			: code == `CODE_BNE ? `ALU_SUB
			: code == `CODE_SLTI ? `ALU_SUB
			: code == `CODE_SLTIU ? `ALU_SUBU
			: ALU_NONE;
	assign shouldAluUseShiftAmountElseRegisterA =
			isRType && (
				function_ == `FUNCTION_SLL
				|| function_ == `FUNCTION_SRL
				|| function_ == `FUNCTION_SRA
			);
	assign shouldAluUseImmeidateElseRegisterB =
			code == `CODE_ADDI
			|| code == `CODE_ADDIU
			|| code == `CODE_ANDI
			|| code == `CODE_ORI
			|| code == `CODE_XORI
			|| code == `CODE_LUI	// TODO: Correct?
			|| code == `CODE_LW
			|| code == `CODE_SW
			|| code == `CODE_SLTI
			|| code == `CODE_SLTIU;

	assign shouldWriteToRegisterRtElseRd =
			code == `CODE_ADDI
			|| code == `CODE_ADDIU
			|| code == `CODE_ANDI
			|| code == `CODE_ORI
			|| code == `CODE_XORI
			|| code == `CODE_LUI
			|| code == `CODE_LW
			|| code == `CODE_SLTI
			|| code == `CODE_SLTIU;
	assign shouldWriteRegister = (isRType && !isJumpRegister) || shouldWriteToRegisterRtElseRd;
	assign shouldWriteMemoryElseAluOutputToRegister = code == `CODE_LW;
	assign shouldWriteMemory = code == `CODE_SW;

	// TODO: Forward and stall.
endmodule
