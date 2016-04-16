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
	wire [31:0] cpu_memoryAddress;
	wire [31:0] cpu_memoryReadData;
	wire cpu_shouldWriteMemory;
	wire [31:0] cpu_memoryWriteData;

	wire [11:0] terminal_addr;
	wire terminal_write;
	wire [7:0] terminal_in;
	wire [7:0] terminal_out;

	wire [9:0] vgaX;
	wire [8:0] vgaY;
	wire isVgaActive;
	wire [7:0] vgaColor;

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
	wire cpuClock = SW_OK[2] ? button_out[1] && clockCounter[26] : clock25Mhz;
	Cpu cpu (

		.clock(cpuClock),
		.reset(reset),

		.debug_pc(cpu_pc[31:0]),
		.debug_instruction(cpu_instruction[31:0]),
		.debug_registers(cpu_registers[32 * 32 - 1 : 0]),
		.debug_memoryAddress(cpu_memoryAddress[31:0]),
		.debug_memoryReadData(cpu_memoryReadData[31:0]),
		.debug_shouldWriteMemory(cpu_shouldWriteMemory),
		.debug_memoryWriteData(cpu_memoryWriteData[31:0])
	);

	debugger u_debugger (
		.clock(clock25Mhz),
		.cpu_pc(cpu_pc[31:0]),
		.cpu_instruction(cpu_instruction[31:0]),
		.cpu_mem_addr(cpu_memoryAddress[31:0]),
		.cpu_mem_read_data(cpu_memoryReadData[31:0]),
		.cpu_mem_write(cpu_shouldWriteMemory),
		.cpu_mem_write_data(cpu_memoryWriteData[31:0]),
		.cpu_registers(cpu_registers[32 * 32 - 1 : 0]),
		.terminal_addr(terminal_addr[11:0]),
		.terminal_write(terminal_write),
		.terminal_data(terminal_in[7:0])
	);

	Terminal terminal (

		.clock(clock50Mhz),

		.isVgaActive(isVgaActive),
		.vgaX(vgaX[9:0]),
		.vgaY(vgaY[8:0]),
		.vgaColor(vgaColor[7:0]),

		.textAddress(terminal_addr[11:0]),
		.textReadData(terminal_out[7:0]),
		.shouldWriteText(terminal_write),
		.textWriteData(terminal_in[7:0])
	);
	assign red = vgaColor[7:5];
	assign green = vgaColor[4:2];
	assign blue = vgaColor[1:0];

	vga_controller U00 (
		.clock_25mhz(clock25Mhz),
		.reset(reset),
		.h_sync(h_sync),
		.v_sync(v_sync),
		.inside_video(isVgaActive),
		.x_position(vgaX[9:0]),
		.y_position(vgaY[8:0])
	);
endmodule
