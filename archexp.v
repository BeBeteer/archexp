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

	// U9 Anti_jitter
	wire [3:0] button_out;
	wire rst;
	wire [7:0] SW_OK;

	// U8 clk_div
	wire [31:0] clkdiv;

	// U1 Multi_CPU
	wire [31:0] cpu_inst;
	wire mem_w;
	wire [31:0] cpu_pc;
	wire [4:0] cpu_state;
	wire [31:0] Addr_out;
	wire [31:0] Data_out;
	wire [32 * 32 - 1 : 0] cpu_regs;

	// U3 RAM_B
	wire clk_50mhz_inv;
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
		.rst(rst),
		.button_pulse(),
		.SW_OK(SW_OK[7:0])
	);
	clk_div U8 (
		.clk(clock50Mhz),
		.rst(rst),
		.clkdiv(clkdiv[31:0])
	);
	wire clock25Mhz = clkdiv[1];
	wire clock12_5Mhz = clkdiv[2];
	wire cpuClock = SW_OK[2] ? clkdiv[24] : clock12_5Mhz;
	Multi_CPU U1 (
		.clk(cpuClock),
		.reset(rst),
		.inst_out(cpu_inst[31:0]),
		.INT(),
		.Data_in(ram_data_out[31:0]),
		.MIO_ready(~button_out[1]),
		.mem_w(mem_w),
		.PC_out(cpu_pc[31:0]),
		.state(cpu_state[4:0]),
		.Addr_out(Addr_out[31:0]),
		.Data_out(ram_data_in[31:0]),
		.CPU_MIO(),
		.regs(cpu_regs[32 * 32 - 1 : 0])
	);
	assign ram_addr = Addr_out[11:2];
	RAM_B U3 (
		.addra(ram_addr[9:0]),
		.wea(mem_w),
		.dina(ram_data_in[31:0]),
		.clka(clock50Mhz),
		.douta(ram_data_out[31:0])
	);
	debugger u_debugger (
		.clock(clock25Mhz),
		.cpu_pc(cpu_pc[31:0]),
		.cpu_inst(cpu_inst[31:0]),
		.cpu_state(cpu_state[4:0]),
		.cpu_mem_write(mem_w),
		.cpu_mem_addr(Addr_out[31:0]),
		.cpu_mem_read_data(ram_data_out[31:0]),
		.cpu_mem_write_data(ram_data_in[31:0]),
		.cpu_regs(cpu_regs[32 * 32 - 1 : 0]),
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
		.reset(rst),
		.h_sync(h_sync),
		.v_sync(v_sync),
		.inside_video(inside_video),
		.x_position(x_position[9:0]),
		.y_position(y_position[8:0])
	);
endmodule
