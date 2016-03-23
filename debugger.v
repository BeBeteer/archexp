`timescale 1ns / 1ps

module debugger (
		input clock,
		input [31:0] cpu_pc,
		input cpu_inst,
		input cpu_stage,
		input cpu_mem_read_addr,
		input cpu_mem_write_addr,
//		input [31:0] cpu_regs [1:31],
		output reg [11:0] console_addr = 0,
		output console_write,
		output reg [7:0] console_data = 0
	);

	localparam CONSOLE_ADDR_MAX = 2399;
	localparam CONSOLE_LINE_MAX = 80;

	assign console_write = 1;

	wire [11:0] console_next_addr = console_addr < CONSOLE_ADDR_MAX ? console_addr + 1'b1 : 0;

	wire [3:0] hex_ascii_in = console_next_addr == 8 ? cpu_pc[31:28]
			: console_next_addr == 9 ? cpu_pc[27:24]
			: console_next_addr == 10 ? cpu_pc[23:20]
			: console_next_addr == 11 ? cpu_pc[19:16]
			: console_next_addr == 12 ? cpu_pc[15:12]
			: console_next_addr == 13 ? cpu_pc[11:8]
			: console_next_addr == 14 ? cpu_pc[7:4]
			: console_next_addr == 15 ? cpu_pc[3:0]
			: 4'hF;
	wire [7:0] hex_ascii_out;
	hex_ascii u_hex_ascii (
		.in(hex_ascii_in),
		.out(hex_ascii_out)
	);

	always @(posedge clock) begin

		console_addr <= console_next_addr;

		if (console_next_addr == 0) begin console_data <= "P"; end
		else if (console_next_addr == 1) begin console_data <= "C"; end
		else if (console_next_addr == 2) begin console_data <= ":"; end
		else if (console_next_addr >= 8 && console_next_addr < 16) begin console_data <= hex_ascii_out; end
		else begin console_data <= 0; end
	end

endmodule
