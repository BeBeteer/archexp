`timescale 1ns / 1ps

module archexp(
		input clock50Mhz,
		input [3:0] BTN,
		input [7:0] SW,
		output [3:0] AN,
		output [7:0] SEGMENT,
		output [7:0] LED,

		output [2:0] red,
		output [2:0] green,
		output [1:0] blue,
		output h_sync,
		output v_sync
	);

	wire [3:0] button_out;
	wire reset;
	wire [7:0] SW_OK;

	wire [31:0] clockCounter;

	wire [31:0] cpu_pc;
	wire [31:0] cpu_instruction;
	wire [32 * 32 - 1 : 0] cpu_registers;
	wire mem_w;
	wire [31:0] Addr_out;
	wire [31:0] Data_out;

	wire [31:0] ram_data_out;
	wire [31:0] ram_data_in;
	wire [9:0] ram_addr;

	wire [11:0] terminal_addr;
	wire terminal_write;
	wire [7:0] terminal_in;
	wire [7:0] terminal_out;

	// U0 terminal
	wire [9:0] x_position;
	wire [8:0] y_position;
	wire inside_video;
	wire [7:0] color;

	Anti_jitter U9 (
		.clk(clock50Mhz),
		.button(BTN[3:0]),
		.SW(SW[7:0]),
		.button_out(button_out[3:0]),
		.rst(reset),
		.button_pulse(),
		.SW_OK(SW_OK[7:0])
	);
	ClockDivider clockDivider (
		.clock(clock50Mhz),
		.reset(reset),
		.counter(clockCounter[31:0])
	);
	wire clock25Mhz = clockCounter[1];
	wire cpuClock = SW_OK[2] ? clockCounter[24] : clock25Mhz;
	Cpu cpu (

		.clock(cpuClock),
		.reset(reset),

		.debug_pc(cpu_pc[31:0]),
		.debug_instruction(cpu_instruction[31:0]),
		.debug_registers(cpu_registers[32 * 32 - 1 : 0])
	);
	debugger u_debugger (
		.clock(clock25Mhz),
		.cpu_pc(cpu_pc[31:0]),
		.cpu_instruction(cpu_instruction[31:0]),
		.cpu_mem_write(mem_w),
		.cpu_mem_addr(Addr_out[31:0]),
		.cpu_mem_read_data(ram_data_out[31:0]),
		.cpu_mem_write_data(ram_data_in[31:0]),
		.cpu_registers(cpu_registers[32 * 32 - 1 : 0]),
		.terminal_addr(terminal_addr[11:0]),
		.terminal_write(terminal_write),
		.terminal_data(terminal_in[7:0])
	);
	terminal u_terminal (
		.clock(clock50Mhz),
		.text_addr(terminal_addr[11:0]),
		.text_write(terminal_write),
		.text_in(terminal_in[7:0]),
		.x_position(x_position[9:0]),
		.y_position(y_position[8:0]),
		.inside_video(inside_video),
		.text_out(terminal_out[7:0]),
		.color(color[7:0])
	);
	assign red = color[7:5];
	assign green = color[4:2];
	assign blue = color[1:0];
	vga_controller U00 (
		.clock_25mhz(clock25Mhz),
		.reset(reset),
		.h_sync(h_sync),
		.v_sync(v_sync),
		.inside_video(inside_video),
		.x_position(x_position[9:0]),
		.y_position(y_position[8:0])
	);
endmodule
