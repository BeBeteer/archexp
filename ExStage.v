`timescale 1ns / 1ps

module ExStage(

		input [31:0] pc_4,	// ex_pc4
		input [31:0] instruction,	// ex_inst

		input [4:0] aluOperation,	// ealuc
		input shouldAluUseShiftAmountElseRegisterRs,	// eshift
		input shouldAluUseImmeidateElseRegisterRt,	// ealuimm

		input shouldWriteToRegisterRtElseRd,	// e_regrt

		input [31:0] shiftAmount,
		input [31:0] immediate,	// odata_imm

		input [31:0] registerRs,	// edata_a
		input [31:0] registerRt,	// edata_b

		input shouldStall,	// stall
		input shouldForwardRegisterRs,	// fwda
		input shouldForwardRegisterRt,	// fwdb

		output [31:0] aluOutput,	// ex_aluR

		output [31:0] isAluOutputZero,	// ex_zero
		output [31:0] branchPc,	// ex_pc

		output [4:0] registerWriteAddress	// ex_destR
	);

	// TODO: Forward
	// TODO: Should we output forwarded registerRs/Rt?
	wire [31:0] forwardedRegisterRs = registerRs;
	wire [31:0] forwardedRegisterRt = registerRt;

	wire [31:0] aluInputA = shouldAluUseShiftAmountElseRegisterRs ? shiftAmount : forwardedRegisterRs;
	wire [31:0] aluInputB = shouldAluUseImmeidateElseRegisterRt ? immediate : forwardedRegisterRt;

	Alu alu (
		.inputA(aluInputA[31:0]),
		.inputB(aluInputB[31:0]),
		.opreration(aluOperation[4:0]),
		.output_(aluOutput[31:0]),
	);

	assign isAluOutputZero = aluOutput == 0;
	assign branchPc = pc_4 + {immediate[29:0], 2'b0};

	wire rt = instruction[20:16];
	wire rd = instruction[15:11];
	assign registerWriteAddress = shouldWriteToRegisterRtElseRd ? rt : rd;
endmodule
