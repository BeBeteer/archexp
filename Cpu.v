`timescale 1ns / 1ps

module Cpu (
		input clock,
		input reset
	);

	wire [31:0] if_pc_4;
	wire [31:0] if_instruction;

	wire [31:0] id_pc_4;
	wire [31:0] id_instruction;
	wire id_isJump;
	wire [25:0] id_jumpIndex;
	wire id_isJumpAndLink;
	wire id_isJumpRegister;
	wire id_isBranch;
	wire id_isBneElseBeq;
	wire [4:0] id_aluOperation;
	wire id_shouldAluUseShiftAmountElseRegisterA;
	wire id_shouldAluUseImmeidateElseRegisterB;
	wire id_shouldWriteRegister;
	wire id_shouldWriteMemoryElseAluOutputToRegister;
	wire id_shouldWriteToRegisterRtElseRd;
	wire id_shouldWriteMemory;
	wire [31:0] id_immediate;
	wire [31:0] id_registerRs;
	wire [31:0] id_registerRt;
	wire id_shouldStall;
	wire id_shouldForwardRegisterRs;
	wire id_shouldForwardRegisterRt;

	wire [31:0] ex_pc_4;
	wire [31:0] ex_instruction;
	wire ex_isJump;
	wire [25:0] ex_jumpIndex;
	wire ex_isJumpAndLink;
	wire ex_isJumpRegister;
	wire ex_isBranch;
	wire ex_isBneElseBeq;
	wire [4:0] ex_aluOperation;
	wire ex_shouldAluUseShiftAmountElseRegisterA;
	wire ex_shouldAluUseImmeidateElseRegisterB;
	wire ex_shouldWriteRegister;
	wire ex_shouldWriteMemoryElseAluOutputToRegister;
	wire ex_shouldWriteToRegisterRtElseRd;
	wire ex_shouldWriteMemory;
	wire [31:0] ex_immediate;
	wire [31:0] ex_registerRs;
	wire [31:0] ex_registerRt;
	wire ex_shouldForwardRegisterRs;
	wire ex_shouldForwardRegisterRt;

	wire mem_shouldBranch;
	wire [31:0] mem_branchPc;
	wire mem_shouldWriteRegister;
	wire [4:0] mem_registerWriteAddress;
	wire [31:0] mem_registerWriteData;

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

		.isJump(id_isJump),
		.jumpIndex(id_jumpIndex[25:0]),
		.isJumpAndLink(id_isJumpAndLink),
		.isJumpRegister(id_isJumpRegister),
		.isBranch(id_isBranch),
		.isBneElseBeq(id_isBneElseBeq),

		.aluOperation(id_aluOperation[4:0]),
		.shouldAluUseShiftAmountElseRegisterA(id_shouldAluUseShiftAmountElseRegisterA),
		.shouldAluUseImmeidateElseRegisterB(id_shouldAluUseImmeidateElseRegisterB),

		.shouldWriteRegister(id_shouldWriteRegister),
		.shouldWriteMemoryElseAluOutputToRegister(id_shouldWriteMemoryElseAluOutputToRegister),
		.shouldWriteToRegisterRtElseRd(id_shouldWriteToRegisterRtElseRd),
		.shouldWriteMemory(id_shouldWriteMemory),

		.immediate(id_immediate[31:0]),

		.registerRs(id_registerRs[31:0]),
		.registerRt(id_registerRt[31:0]),

		.mem_shouldWriteRegister(mem_shouldWriteRegister),
		.mem_registerWriteAddress(mem_registerWriteAddress[4:0]),
		.mem_registerWriteData(mem_registerWriteData[31:0]),

		.if_instruction(if_instruction[31:0]),
		.ex_instruction(ex_instruction[31:0]),
		.shouldStall(id_shouldStall),
		.shouldForwardRegisterRs(id_shouldForwardRegisterRs),
		.shouldForwardRegisterRt(id_shouldForwardRegisterRt)
	);

	IdExRegisters idExRegisters (

		.clock(clock),
		.reset(reset),

		.id_pc_4(id_pc_4[31:0]),
		.id_instruction(id_instruction[31:0]),

		.id_isJump(id_isJump),
		.id_jumpIndex(id_jumpIndex[25:0]),
		.id_isJumpAndLink(id_isJumpAndLink),
		.id_isJumpRegister(id_isJumpRegister),
		.id_isBranch(id_isBranch),
		.id_isBneElseBeq(id_isBneElseBeq),

		.id_aluOperation(id_aluOperation[4:0]),
		.id_shouldAluUseShiftAmountElseRegisterA(id_shouldAluUseShiftAmountElseRegisterA),
		.id_shouldAluUseImmeidateElseRegisterB(id_shouldAluUseImmeidateElseRegisterB),

		.id_shouldWriteRegister(id_shouldWriteRegister),
		.id_shouldWriteMemoryElseAluOutputToRegister(id_shouldWriteMemoryElseAluOutputToRegister),
		.id_shouldWriteToRegisterRtElseRd(id_shouldWriteToRegisterRtElseRd),
		.id_shouldWriteMemory(id_shouldWriteMemory),

		.id_immediate(id_immediate[31:0]),

		.id_registerRs(id_registerRs[31:0]),
		.id_registerRt(id_registerRt[31:0]),

		.id_shouldStall(id_shouldStall),
		.id_shouldForwardRegisterRs(id_shouldForwardRegisterRs),
		.id_shouldForwardRegisterRt(id_shouldForwardRegisterRt),

		.ex_pc_4(ex_pc_4[31:0]),
		.ex_instruction(ex_instruction[31:0]),

		.ex_isJump(ex_isJump),
		.ex_jumpIndex(ex_jumpIndex[25:0]),
		.ex_isJumpAndLink(ex_isJumpAndLink),
		.ex_isJumpRegister(ex_isJumpRegister),
		.ex_isBranch(ex_isBranch),
		.ex_isBneElseBeq(ex_isBneElseBeq),

		.ex_aluOperation(ex_aluOperation[4:0]),
		.ex_shouldAluUseShiftAmountElseRegisterA(ex_shouldAluUseShiftAmountElseRegisterA),
		.ex_shouldAluUseImmeidateElseRegisterB(ex_shouldAluUseImmeidateElseRegisterB),

		.ex_shouldWriteRegister(ex_shouldWriteRegister),
		.ex_shouldWriteMemoryElseAluOutputToRegister(ex_shouldWriteMemoryElseAluOutputToRegister),
		.ex_shouldWriteToRegisterRtElseRd(ex_shouldWriteToRegisterRtElseRd),
		.ex_shouldWriteMemory(ex_shouldWriteMemory),

		.ex_immediate(ex_immediate[31:0]),

		.ex_registerRs(ex_registerRs[31:0]),
		.ex_registerRt(ex_registerRt[31:0]),

		.ex_shouldForwardRegisterRs(ex_shouldForwardRegisterRs),
		.ex_shouldForwardRegisterRt(ex_shouldForwardRegisterRt)
	);
endmodule
