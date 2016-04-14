`timescale 1ns / 1ps

module ExMemRegisters (

		input clock,
		input reset,

		input ex_shouldWriteRegister,
		input [4:0] ex_registerWriteAddress,
		input ex_shouldWriteMemoryElseAluOutputToRegister,

		input [31:0] ex_aluOutput,
		input ex_shouldWriteMemory,
		input [31:0] ex_registerRtOrZero,

		output reg mem_shouldWriteRegister = 0,
		output reg [4:0] mem_registerWriteAddress = 0,
		output reg mem_shouldWriteMemoryElseAluOutputToRegister = 0,

		output reg [31:0] mem_aluOutput = 0,
		output reg mem_shouldWriteMemory = 0,
		output reg [31:0] mem_registerRtOrZero = 0
	);

	always @(posedge clock or posedge reset) begin

		if (reset) begin

			mem_shouldWriteRegister <= 0;
			mem_registerWriteAddress <= 0;
			mem_shouldWriteMemoryElseAluOutputToRegister <= 0;

			mem_aluOutput <= 0;
			mem_shouldWriteMemory <= 0;
			mem_registerRtOrZero <= 0;

		end else begin

			mem_shouldWriteRegister <= ex_shouldWriteRegister;
			mem_registerWriteAddress <= ex_registerWriteAddress;
			mem_shouldWriteMemoryElseAluOutputToRegister <= ex_shouldWriteMemoryElseAluOutputToRegister;

			mem_aluOutput <= ex_aluOutput;
			mem_shouldWriteMemory <= ex_shouldWriteMemory;
			mem_registerRtOrZero <= ex_registerRtOrZero;
		end
	end
endmodule
