`timescale 1ns / 1ps

module MemStage(

		input clock,
		input reset,

		input isBranch,	// branch
		input isBneElseBeq,	// mem_bne_beq (missing in sample)
		input isAluOutputZero,	// zero
		output shouldBranch,	// mem_branch

		input [31:0] aluOutput,	// mem_aluR
		input shouldWriteMemory,	// mwmem
		input [31:0] registerRt,	// data_in
		output [31:0] memoryData	// m_mdata
	);

	assign shouldBranch = isBranch && (isBneElseBeq != isAluOutputZero);

	DataMemory dataMemory(
		.clka(~clock),
		.addra(aluOutput[31:0]),
		.dout(memoryData[31:0]),
		.wea(shouldWriteMemory),
		.dina(registerRt[31:0])
	);
endmodule
