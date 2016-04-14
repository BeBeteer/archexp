`timescale 1ns / 1ps

module debugger (

		input clock,

		input [31:0] cpu_pc,
		input [31:0] cpu_instruction,
		input [4:0] cpu_state,
		input cpu_mem_write,
		input [31:0] cpu_mem_addr,
		input [31:0] cpu_mem_read_data,
		input [31:0] cpu_mem_write_data,
		input [32 * 32 - 1:0] cpu_registers,

		output reg [11:0] terminal_addr = 0,
		output terminal_write,
		output reg [7:0] terminal_data = 0
	);

	localparam TERMINAL_ADDR_MAX = 2399;
	localparam TERMINAL_COLUMN_MAX = 80;

	function [11:0] calc_terminal_addr (
			input [4:0] row,
			input [6:0] column
		);
		calc_terminal_addr = row * TERMINAL_COLUMN_MAX + column;
	endfunction

	assign terminal_write = 1;

	wire [11:0] terminal_next_addr = terminal_addr < TERMINAL_ADDR_MAX ? terminal_addr + 1'b1 : 0;

	function is_next_terminal_addr_in_range (
			input [4:0] row,
			input [6:0] column_start,
			input [6:0] column_len
		);
		is_next_terminal_addr_in_range = terminal_next_addr >= calc_terminal_addr(row, column_start) && terminal_next_addr < calc_terminal_addr(row, column_start + column_len);
	endfunction

	wire [3:0] hex_ascii_in =
			is_next_terminal_addr_in_range(0, 8, 8) ? cpu_pc[31 - 4 * (terminal_next_addr - calc_terminal_addr(0, 8)) -: 4]

			: is_next_terminal_addr_in_range(1, 8, 8) ? cpu_instruction[31 - 4 * (terminal_next_addr - calc_terminal_addr(1, 8)) -: 4]

			: is_next_terminal_addr_in_range(4, 8, 8) ? cpu_mem_addr[31 - 4 * (terminal_next_addr - calc_terminal_addr(4, 8)) -: 4]
			: is_next_terminal_addr_in_range(5, 8, 8) ? cpu_mem_read_data[31 - 4 * (terminal_next_addr - calc_terminal_addr(5, 8)) -: 4]
			: is_next_terminal_addr_in_range(6, 8, 8) ? cpu_mem_write_data[31 - 4 * (terminal_next_addr - calc_terminal_addr(6, 8)) -: 4]

			: is_next_terminal_addr_in_range(8, 0, 8) ? cpu_registers[32 * 1 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(8, 0)) -: 4]
			: is_next_terminal_addr_in_range(8, 16, 8) ? cpu_registers[32 * 2 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(8, 16)) -: 4]
			: is_next_terminal_addr_in_range(8, 32, 8) ? cpu_registers[32 * 3 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(8, 32)) -: 4]
			: is_next_terminal_addr_in_range(8, 48, 8) ? cpu_registers[32 * 4 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(8, 48)) -: 4]
			: is_next_terminal_addr_in_range(8, 64, 8) ? cpu_registers[32 * 5 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(8, 64)) -: 4]
			: is_next_terminal_addr_in_range(9, 0, 8) ? cpu_registers[32 * 6 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(9, 0)) -: 4]
			: is_next_terminal_addr_in_range(9, 16, 8) ? cpu_registers[32 * 7 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(9, 16)) -: 4]
			: is_next_terminal_addr_in_range(9, 32, 8) ? cpu_registers[32 * 8 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(9, 32)) -: 4]
			: is_next_terminal_addr_in_range(9, 49, 8) ? cpu_registers[32 * 9 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(9, 48)) -: 4]
			: is_next_terminal_addr_in_range(9, 64, 8) ? cpu_registers[32 * 10 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(9, 64)) -: 4]
			: is_next_terminal_addr_in_range(10, 0, 8) ? cpu_registers[32 * 11 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(10, 0)) -: 4]
			: is_next_terminal_addr_in_range(10, 16, 8) ? cpu_registers[32 * 12 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(10, 16)) -: 4]
			: is_next_terminal_addr_in_range(10, 32, 8) ? cpu_registers[32 * 13 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(10, 32)) -: 4]
			: is_next_terminal_addr_in_range(10, 48, 8) ? cpu_registers[32 * 14 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(10, 48)) -: 4]
			: is_next_terminal_addr_in_range(10, 64, 8) ? cpu_registers[32 * 15 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(10, 64)) -: 4]
			: is_next_terminal_addr_in_range(11, 0, 8) ? cpu_registers[32 * 16 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(11, 0)) -: 4]
			: is_next_terminal_addr_in_range(11, 16, 8) ? cpu_registers[32 * 17 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(11, 16)) -: 4]
			: is_next_terminal_addr_in_range(11, 32, 8) ? cpu_registers[32 * 18 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(11, 32)) -: 4]
			: is_next_terminal_addr_in_range(11, 48, 8) ? cpu_registers[32 * 19 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(11, 48)) -: 4]
			: is_next_terminal_addr_in_range(11, 64, 8) ? cpu_registers[32 * 20 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(11, 64)) -: 4]
			: is_next_terminal_addr_in_range(12, 0, 8) ? cpu_registers[32 * 21 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(12, 0)) -: 4]
			: is_next_terminal_addr_in_range(12, 16, 8) ? cpu_registers[32 * 22 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(12, 16)) -: 4]
			: is_next_terminal_addr_in_range(12, 32, 8) ? cpu_registers[32 * 23 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(12, 32)) -: 4]
			: is_next_terminal_addr_in_range(12, 48, 8) ? cpu_registers[32 * 24 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(12, 48)) -: 4]
			: is_next_terminal_addr_in_range(12, 64, 8) ? cpu_registers[32 * 25 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(12, 64)) -: 4]
			: is_next_terminal_addr_in_range(13, 0, 8) ? cpu_registers[32 * 26 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(13, 0)) -: 4]
			: is_next_terminal_addr_in_range(13, 16, 8) ? cpu_registers[32 * 27 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(13, 16)) -: 4]
			: is_next_terminal_addr_in_range(13, 32, 8) ? cpu_registers[32 * 28 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(13, 32)) -: 4]
			: is_next_terminal_addr_in_range(13, 48, 8) ? cpu_registers[32 * 29 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(13, 48)) -: 4]
			: is_next_terminal_addr_in_range(13, 64, 8) ? cpu_registers[32 * 30 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(13, 64)) -: 4]
			: is_next_terminal_addr_in_range(14, 0, 8) ? cpu_registers[32 * 31 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(14, 0)) -: 4]
			: is_next_terminal_addr_in_range(14, 16, 8) ? cpu_registers[32 * 32 - 1 - 4 * (terminal_next_addr - calc_terminal_addr(14, 16)) -: 4]

			: 4'hF;
	wire [7:0] hex_ascii_out;
	hex_ascii u_hex_ascii (
		.in(hex_ascii_in[3:0]),
		.out(hex_ascii_out[7:0])
	);

	wire bin_ascii_in = 
			is_next_terminal_addr_in_range(2, 8, 5) ? cpu_state[5 - (terminal_next_addr - calc_terminal_addr(2, 8))]
			: is_next_terminal_addr_in_range(3, 8, 1) ? cpu_mem_write
			: 1'b1;
	wire [7:0] bin_ascii_out;
	bin_ascii u_bin_ascii (
		.in(bin_ascii_in),
		.out(bin_ascii_out[7:0])
	);

	wire [0 : 3 * 8 - 1] PC_PROMPT = "PC:";
	wire [0 : 5 * 8 - 1] INST_PROMPT = "Inst:";
	wire [0 : 6 * 8 - 1] STATE_PROMPT = "State:";
	wire [0 : 7 * 8 - 1] MEM_WRITE_PROMPT = "MWrite:";
	wire [0 : 6 * 8 - 1] MEM_ADDR_PROMPT = "MAddr:";
	wire [0 : 7 * 8 - 1] MEM_READ_DATA_PROMPT = "MRData:";
	wire [0 : 7 * 8 - 1] MEM_WRITE_DATA_PROMPT = "MWData:";
	wire [0 : 5 * 8 - 1] REGS_PROMPT = "Regs:";

	always @(posedge clock) begin

		terminal_addr <= terminal_next_addr;

		terminal_data <= is_next_terminal_addr_in_range(0, 0, 3) ? PC_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(0, 0)) +: 8]
				: is_next_terminal_addr_in_range(0, 8, 8) ? hex_ascii_out

				: is_next_terminal_addr_in_range(1, 0, 5) ? INST_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(1, 0)) +: 8]
				: is_next_terminal_addr_in_range(1, 8, 8) ? hex_ascii_out

				: is_next_terminal_addr_in_range(2, 0, 6) ? STATE_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(2, 0)) +: 8]
				: is_next_terminal_addr_in_range(2, 8, 5) ? bin_ascii_out

				: is_next_terminal_addr_in_range(3, 0, 7) ? MEM_WRITE_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(3, 0)) +: 8]
				: is_next_terminal_addr_in_range(3, 8, 1) ? bin_ascii_out

				: is_next_terminal_addr_in_range(4, 0, 6) ? MEM_ADDR_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(4, 0)) +: 8]
				: is_next_terminal_addr_in_range(4, 8, 8) ? hex_ascii_out

				: is_next_terminal_addr_in_range(5, 0, 7) ? MEM_READ_DATA_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(5, 0)) +: 8]
				: is_next_terminal_addr_in_range(5, 8, 8) ? hex_ascii_out

				: is_next_terminal_addr_in_range(6, 0, 7) ? MEM_WRITE_DATA_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(6, 0)) +: 8]
				: is_next_terminal_addr_in_range(6, 8, 8) ? hex_ascii_out

				: is_next_terminal_addr_in_range(7, 0, 5) ? REGS_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(7, 0)) +: 8]

				: is_next_terminal_addr_in_range(8, 0, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(8, 16, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(8, 32, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(8, 48, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(8, 64, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(9, 0, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(9, 16, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(9, 32, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(9, 48, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(9, 64, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(10, 0, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(10, 16, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(10, 32, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(10, 48, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(10, 64, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(11, 0, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(11, 16, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(11, 32, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(11, 48, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(11, 64, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(12, 0, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(12, 16, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(12, 32, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(12, 48, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(12, 64, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(13, 0, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(13, 16, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(13, 32, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(13, 48, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(13, 64, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(14, 0, 8) ? hex_ascii_out
				: is_next_terminal_addr_in_range(14, 16, 8) ? hex_ascii_out

				: 8'b0;
	end
endmodule
