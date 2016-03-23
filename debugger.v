`timescale 1ns / 1ps

module debugger (
		input clock,
		input [31:0] cpu_pc,
		input [31:0] cpu_inst,
		input [4:0] cpu_state,
		input [31:0] cpu_mem_addr,
		input [31:0] cpu_mem_read_data,
		input [31:0] cpu_mem_write_data,
//		input [31:0] cpu_regs [1:31],
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

	wire [3:0] hex_ascii_in = is_next_terminal_addr_in_range(0, 8, 8) ? cpu_pc[31 - 4 * (terminal_next_addr - calc_terminal_addr(0, 8)) -: 4]
			: is_next_terminal_addr_in_range(3, 8, 8) ? cpu_mem_addr[31 - 4 * (terminal_next_addr - calc_terminal_addr(3, 8)) -: 4]
			: is_next_terminal_addr_in_range(4, 8, 8) ? cpu_mem_read_data[31 - 4 * (terminal_next_addr - calc_terminal_addr(4, 8)) -: 4]
			: is_next_terminal_addr_in_range(5, 8, 8) ? cpu_mem_write_data[31 - 4 * (terminal_next_addr - calc_terminal_addr(5, 8)) -: 4]
			: 4'hF;
	wire [7:0] hex_ascii_out;
	hex_ascii u_hex_ascii (
		.in(hex_ascii_in),
		.out(hex_ascii_out)
	);

	wire bin_ascii_in = terminal_next_addr >= is_next_terminal_addr_in_range(1, 8, 32) ? cpu_inst[terminal_next_addr - calc_terminal_addr(1, 8)]
			: terminal_next_addr >= is_next_terminal_addr_in_range(2, 8, 4) ? cpu_state[terminal_next_addr - calc_terminal_addr(2, 8)]
			: 1'b1;
	wire [7:0] bin_ascii_out;
	bin_ascii u_bin_ascii (
		.in(bin_ascii_in),
		.out(bin_ascii_out[7:0])
	);

	wire [0 : 3 * 8 - 1] PC_PROMPT = "PC:";
	wire [0 : 5 * 8 - 1] INST_PROMPT = "Inst:";
	wire [0 : 6 * 8 - 1] STATE_PROMPT = "State:";
	wire [0 : 6 * 8 - 1] MEM_ADDR_PROMPT = "MAddr:";
	wire [0 : 7 * 8 - 1] MEM_READ_DATA_PROMPT = "MRData:";
	wire [0 : 7 * 8 - 1] MEM_WRITE_DATA_PROMPT = "MWData:";
	wire [0 : 5 * 8 - 1] REGS_PROMPT = "Regs:";

	always @(posedge clock) begin

		terminal_addr <= terminal_next_addr;

		terminal_data <= is_next_terminal_addr_in_range(0, 0, 3) ? PC_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(0, 0)) +: 8]
				: is_next_terminal_addr_in_range(0, 8, 8) ? hex_ascii_out

				: is_next_terminal_addr_in_range(1, 0, 5) ? INST_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(1, 0)) +: 8]
				: is_next_terminal_addr_in_range(1, 8, 32) ? bin_ascii_out

				: is_next_terminal_addr_in_range(2, 0, 6) ? STATE_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(2, 0)) +: 8]
				: is_next_terminal_addr_in_range(2, 8, 4) ? bin_ascii_out

				: is_next_terminal_addr_in_range(3, 0, 6) ? MEM_ADDR_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(3, 0)) +: 8]
				: is_next_terminal_addr_in_range(3, 8, 8) ? hex_ascii_out

				: is_next_terminal_addr_in_range(4, 0, 7) ? MEM_READ_DATA_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(4, 0)) +: 8]
				: is_next_terminal_addr_in_range(4, 8, 8) ? hex_ascii_out

				: is_next_terminal_addr_in_range(5, 0, 7) ? MEM_WRITE_DATA_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(5, 0)) +: 8]
				: is_next_terminal_addr_in_range(5, 8, 8) ? hex_ascii_out

				: is_next_terminal_addr_in_range(6, 0, 5) ? REGS_PROMPT[8 * (terminal_next_addr - calc_terminal_addr(6, 0)) +: 8]

				: 0;
	end
endmodule
