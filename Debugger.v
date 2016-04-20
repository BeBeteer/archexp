`timescale 1ns / 1ps

module Debugger (

		input clock,

		input [31:0] cpu_if_pc,
		input [31:0] cpu_if_nextPc,
		input [31:0] cpu_if_instruction,
		input [31:0] cpu_id_instruction,
		input [32 * 32 - 1 : 0] cpu_id_registers,
		input [31:0] cpu_ex_instruction,
		input [31:0] cpu_ex_aluInputA,
		input [31:0] cpu_ex_aluInputB,
		input [31:0] cpu_ex_aluOutput,
		input [31:0] cpu_mem_instruction,
		input [31:0] cpu_mem_memoryAddress,
		input [31:0] cpu_mem_memoryReadData,
		input cpu_mem_shouldWriteMemory,
		input [31:0] cpu_mem_memoryWriteData,
		input [31:0] cpu_wb_instruction,
		input cpu_wb_shouldWriteRegister,
		input [4:0] cpu_wb_registerWriteAddress,
		input [31:0] cpu_wb_registerWriteData,

		output reg [11:0] terminalAddress = 0,
		output shouldWriteTerminal,
		output reg [7:0] terminalWriteData = 0
	);

	localparam TERMINAL_ADDRESS_MAX = 2399;
	localparam TERMINAL_COLUMN_SIZE = 80;

	assign shouldWriteTerminal = 1;

	function [11:0] getTerminalAddress (
			input [4:0] row,
			input [6:0] column
		);
		getTerminalAddress = row * TERMINAL_COLUMN_SIZE + column;
	endfunction

	wire [11:0] nextTerminalAddress = terminalAddress < TERMINAL_ADDRESS_MAX ? terminalAddress + 1'b1 : 0;

	function isTerminalAddressInRange (
			input [4:0] row,
			input [6:0] columnStart,
			input [6:0] columnLength
		);
		isTerminalAddressInRange = nextTerminalAddress >= getTerminalAddress(row[4:0], columnStart[6:0]) && nextTerminalAddress < getTerminalAddress(row[4:0], {columnStart + columnLength}[6:0]);
	endfunction

	function getDistanceFromTerminalAddress (
			input [4:0] row,
			input [6:0] column
		);
		getDistanceFromTerminalAddress = nextTerminalAddress - getTerminalAddress(row[4:0], column[6:0]);
	endfunction

	wire [3:0] hexAsciiInput =
			isTerminalAddressInRange(0, 8, 8) ? cpu_pc[31 - 4 * getDistanceFromTerminalAddress(0, 8) -: 4]

			: isTerminalAddressInRange(1, 8, 8) ? cpu_instruction[31 - 4 * getDistanceFromTerminalAddress(1, 8) -: 4]

			: isTerminalAddressInRange(2, 8, 8) ? cpu_mem_addr[31 - 4 * getDistanceFromTerminalAddress(2, 8) -: 4]
			: isTerminalAddressInRange(3, 8, 8) ? cpu_mem_read_data[31 - 4 * getDistanceFromTerminalAddress(3, 8) -: 4]
			: isTerminalAddressInRange(5, 8, 8) ? cpu_mem_write_data[31 - 4 * getDistanceFromTerminalAddress(5, 8) -: 4]

			: isTerminalAddressInRange(7, 0, 8) ? cpu_registers[32 * 1 - 1 - 4 * getDistanceFromTerminalAddress(7, 0) -: 4]
			: isTerminalAddressInRange(7, 16, 8) ? cpu_registers[32 * 2 - 1 - 4 * getDistanceFromTerminalAddress(7, 16) -: 4]
			: isTerminalAddressInRange(7, 32, 8) ? cpu_registers[32 * 3 - 1 - 4 * getDistanceFromTerminalAddress(7, 32) -: 4]
			: isTerminalAddressInRange(7, 48, 8) ? cpu_registers[32 * 4 - 1 - 4 * getDistanceFromTerminalAddress(7, 48) -: 4]
			: isTerminalAddressInRange(7, 64, 8) ? cpu_registers[32 * 5 - 1 - 4 * getDistanceFromTerminalAddress(7, 64) -: 4]
			: isTerminalAddressInRange(8, 0, 8) ? cpu_registers[32 * 6 - 1 - 4 * getDistanceFromTerminalAddress(8, 0) -: 4]
			: isTerminalAddressInRange(8, 16, 8) ? cpu_registers[32 * 7 - 1 - 4 * getDistanceFromTerminalAddress(8, 16) -: 4]
			: isTerminalAddressInRange(8, 32, 8) ? cpu_registers[32 * 8 - 1 - 4 * getDistanceFromTerminalAddress(8, 32) -: 4]
			: isTerminalAddressInRange(8, 48, 8) ? cpu_registers[32 * 9 - 1 - 4 * getDistanceFromTerminalAddress(8, 48) -: 4]
			: isTerminalAddressInRange(8, 64, 8) ? cpu_registers[32 * 10 - 1 - 4 * getDistanceFromTerminalAddress(8, 64) -: 4]
			: isTerminalAddressInRange(9, 0, 8) ? cpu_registers[32 * 11 - 1 - 4 * getDistanceFromTerminalAddress(9, 0) -: 4]
			: isTerminalAddressInRange(9, 16, 8) ? cpu_registers[32 * 12 - 1 - 4 * getDistanceFromTerminalAddress(9, 16) -: 4]
			: isTerminalAddressInRange(9, 32, 8) ? cpu_registers[32 * 13 - 1 - 4 * getDistanceFromTerminalAddress(9, 32) -: 4]
			: isTerminalAddressInRange(9, 48, 8) ? cpu_registers[32 * 14 - 1 - 4 * getDistanceFromTerminalAddress(9, 48) -: 4]
			: isTerminalAddressInRange(9, 64, 8) ? cpu_registers[32 * 15 - 1 - 4 * getDistanceFromTerminalAddress(9, 64) -: 4]
			: isTerminalAddressInRange(10, 0, 8) ? cpu_registers[32 * 16 - 1 - 4 * getDistanceFromTerminalAddress(10, 0) -: 4]
			: isTerminalAddressInRange(10, 16, 8) ? cpu_registers[32 * 17 - 1 - 4 * getDistanceFromTerminalAddress(10, 16) -: 4]
			: isTerminalAddressInRange(10, 32, 8) ? cpu_registers[32 * 18 - 1 - 4 * getDistanceFromTerminalAddress(10, 32) -: 4]
			: isTerminalAddressInRange(10, 48, 8) ? cpu_registers[32 * 19 - 1 - 4 * getDistanceFromTerminalAddress(10, 48) -: 4]
			: isTerminalAddressInRange(10, 64, 8) ? cpu_registers[32 * 20 - 1 - 4 * getDistanceFromTerminalAddress(10, 64) -: 4]
			: isTerminalAddressInRange(11, 0, 8) ? cpu_registers[32 * 21 - 1 - 4 * getDistanceFromTerminalAddress(11, 0) -: 4]
			: isTerminalAddressInRange(11, 16, 8) ? cpu_registers[32 * 22 - 1 - 4 * getDistanceFromTerminalAddress(11, 16) -: 4]
			: isTerminalAddressInRange(11, 32, 8) ? cpu_registers[32 * 23 - 1 - 4 * getDistanceFromTerminalAddress(11, 32) -: 4]
			: isTerminalAddressInRange(11, 48, 8) ? cpu_registers[32 * 24 - 1 - 4 * getDistanceFromTerminalAddress(11, 48) -: 4]
			: isTerminalAddressInRange(11, 64, 8) ? cpu_registers[32 * 25 - 1 - 4 * getDistanceFromTerminalAddress(11, 64) -: 4]
			: isTerminalAddressInRange(12, 0, 8) ? cpu_registers[32 * 26 - 1 - 4 * getDistanceFromTerminalAddress(12, 0) -: 4]
			: isTerminalAddressInRange(12, 16, 8) ? cpu_registers[32 * 27 - 1 - 4 * getDistanceFromTerminalAddress(12, 16) -: 4]
			: isTerminalAddressInRange(12, 32, 8) ? cpu_registers[32 * 28 - 1 - 4 * getDistanceFromTerminalAddress(12, 32) -: 4]
			: isTerminalAddressInRange(12, 48, 8) ? cpu_registers[32 * 29 - 1 - 4 * getDistanceFromTerminalAddress(12, 48) -: 4]
			: isTerminalAddressInRange(12, 64, 8) ? cpu_registers[32 * 30 - 1 - 4 * getDistanceFromTerminalAddress(12, 64) -: 4]
			: isTerminalAddressInRange(13, 0, 8) ? cpu_registers[32 * 31 - 1 - 4 * getDistanceFromTerminalAddress(13, 0) -: 4]
			: isTerminalAddressInRange(13, 16, 8) ? cpu_registers[32 * 32 - 1 - 4 * getDistanceFromTerminalAddress(13, 16) -: 4]

			: 4'hF;
	wire [7:0] hexAsciiOutput;
	HexAsciiConverter hexAsciiConverter (
		.hex(hexAsciiInput[3:0]),
		.ascii(hexAsciiOutput[7:0])
	);

	wire binaryAsciiInput =
			isTerminalAddressInRange(4, 8, 1) ? cpu_mem_write
			: 1'b1;
	wire [7:0] binaryAsciiOutput;
	BinaryAsciiConverter binaryAsciiConverter (
		.binary(binaryAsciiInput),
		.ascii(binaryAsciiOutput[7:0])
	);

	wire [31:0] disassemblerInput =
			;
	wire [32 * 8 - 1 : 0] disassemblerOutput;
	Disassembler disassembler (
		.instruction(cpu_instruction[31:0]),
		.text(disassemblerOutput[32 * 8 - 1 : 0])
	);

	always @(posedge clock) begin

		terminalAddress <= nextTerminalAddress;

		terminalWriteData <=
				isTerminalAddressInRange(0, 0, 25) ? {"Zhang Hai's Pipelined CPU"}[8 * getDistanceFromTerminalAddress(0, 0) +: 8]

				: isTerminalAddressInRange(1, 0, 80) ? "="

				: isTerminalAddressInRange(3, 0, 9) ? {"IF Stage:"}[8 * getDistanceFromTerminalAddress(3, 0) +: 8]
				// FIXME
				: isTerminalAddressInRange(3, 10, 32) ? disassemblerOutput[8 * getDistanceFromTerminalAddress(3, 10) +: 8]
				: isTerminalAddressInRange(4, 0, 3) ? {"PC:"}[8 * getDistanceFromTerminalAddress(4, 0) +: 8]
				: isTerminalAddressInRange(4, 4, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(4, 40, 8) ? {"Next PC:"}[8 * getDistanceFromTerminalAddress(4, 40) +: 8]
				: isTerminalAddressInRange(4, 49, 8) ? hexAsciiOutput

				: isTerminalAddressInRange(1, 0, 5) ? INST_PROMPT[8 * getDistanceFromTerminalAddress(1, 0) +: 8]
				: isTerminalAddressInRange(1, 8, 8) ? hexAsciiOutput

				: isTerminalAddressInRange(2, 0, 6) ? MEM_ADDR_PROMPT[8 * getDistanceFromTerminalAddress(2, 0) +: 8]
				: isTerminalAddressInRange(2, 8, 8) ? hexAsciiOutput

				: isTerminalAddressInRange(3, 0, 7) ? MEM_READ_DATA_PROMPT[8 * getDistanceFromTerminalAddress(3, 0) +: 8]
				: isTerminalAddressInRange(3, 8, 8) ? hexAsciiOutput

				: isTerminalAddressInRange(4, 0, 7) ? MEM_WRITE_PROMPT[8 * getDistanceFromTerminalAddress(4, 0) +: 8]
				: isTerminalAddressInRange(4, 8, 1) ? binaryAsciiOutput

				: isTerminalAddressInRange(5, 0, 7) ? MEM_WRITE_DATA_PROMPT[8 * getDistanceFromTerminalAddress(5, 0) +: 8]
				: isTerminalAddressInRange(5, 8, 8) ? hexAsciiOutput

				: isTerminalAddressInRange(6, 0, 5) ? REGS_PROMPT[8 * getDistanceFromTerminalAddress(6, 0) +: 8]

				: isTerminalAddressInRange(7, 0, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(7, 16, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(7, 32, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(7, 48, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(7, 64, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(8, 0, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(8, 16, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(8, 32, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(8, 48, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(8, 64, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(9, 0, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(9, 16, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(9, 32, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(9, 48, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(9, 64, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(10, 0, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(10, 16, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(10, 32, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(10, 48, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(10, 64, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(11, 0, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(11, 16, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(11, 32, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(11, 48, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(11, 64, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(12, 0, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(12, 16, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(12, 32, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(12, 48, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(12, 64, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(13, 0, 8) ? hexAsciiOutput
				: isTerminalAddressInRange(13, 16, 8) ? hexAsciiOutput

				: isTerminalAddressInRange(15, 0, 32) ? disassemblerOutput[32 * 8 - 1 - 8 * getDistanceFromTerminalAddress(15, 0) -: 8]

				: 8'b0;
	end
endmodule
