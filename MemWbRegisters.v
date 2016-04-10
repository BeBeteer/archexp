`timescale 1ns / 1ps

module MemWbRegisters (

		input clock,
		input reset,

		input [31:0] mem_pc_4,

		input mem_isJumpAndLink,

		input [31:0] mem_aluOutput,

		input mem_shouldWriteRegister,
		input [4:0] mem_registerWriteAddress,
		input mem_shouldWriteMemoryElseAluOutputToRegister,
		input [31:0] mem_memoryData,

		output reg [31:0] wb_pc_4 = 0,

		output reg wb_isJumpAndLink = 0,

		output reg [31:0] wb_aluOutput = 0,

		output reg wb_shouldWriteRegister = 0,
		output reg [4:0] wb_registerWriteAddress = 0,
		output reg wb_shouldWriteMemoryElseAluOutputToRegister = 0,
		output reg [31:0] wb_memoryData = 0
	);

	always @(posedge clock or posedge reset) begin

		if (reset) begin

			wb_pc_4 <= 0;

			wb_isJumpAndLink <= 0;

			wb_aluOutput <= 0;

			wb_shouldWriteRegister <= 0;
			wb_registerWriteAddress <= 0;
			wb_shouldWriteMemoryElseAluOutputToRegister <= 0;
			wb_memoryData <= 0;

		end else begin

			wb_pc_4 <= mem_pc_4;

			wb_isJumpAndLink <= mem_isJumpAndLink;

			wb_aluOutput <= mem_aluOutput;

			wb_shouldWriteRegister <= mem_shouldWriteRegister;
			wb_registerWriteAddress <= mem_registerWriteAddress;
			wb_shouldWriteMemoryElseAluOutputToRegister <= mem_shouldWriteMemoryElseAluOutputToRegister;
			wb_memoryData <= mem_memoryData;
		end
	end
endmodule
