`timescale 1ns / 1ps

module WbStage(

		input isJumpAndLink,	// wb_is_jal
		input [31:0] pc_4, // wb_pc4
		input shouldWriteMemoryElseAluOutputToRegister, 	// wm2reg
		input [31:0] memoryData,	// wdata_out
		input [31:0] aluOutput,	// waluout
		output [31:0] registerWriteData	// wb_dest
	);

	assign registerWriteData =
			isJumpAndLink ? pc_4
			: shouldWriteMemoryElseAluOutputToRegister ?
				memoryData : aluOutput;
endmodule
