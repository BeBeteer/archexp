`timescale 1ns / 1ps

module console(
		input clock,
		input [11:0] text_addr,
		input text_write,
		input [7:0] text_in,
		input [9:0] x_position,
		input [8:0] y_position,
		input inside_video,
		output [7:0] text_out,
		output [7:0] color
	);

	parameter COLOR_WHITE = 8'b111_111_11;
	parameter COLOR_BLACK = 8'b000_000_00;

	// 640x480, 80x30
	reg [7:0] text [0:11];

	wire [11:0] text_index;
	wire [7:0] font_index;
	wire [2:0] font_x;
	wire [3:0] font_y;
	wire [11:0] font_data_addr;
	wire [7:0] font_data;
	wire point;

	always @(posedge clock) begin
		if (text_write) begin
			text[text_addr] <= text_in;
		end
	end
	assign text_out = text[text_addr];

	assign text_index = x_position / 8 + y_position / 16 * 80;
	assign font_index = text[text_index];
	assign font_x = x_position % 8;
	assign font_y = y_position % 16;
	assign font_data_addr = font_index * 16 + font_y;
	assign point = font_data[8 - font_x];
	assign color = inside_video ? (point ? COLOR_WHITE : COLOR_BLACK) : 8'b0;

	font_data U_font_data(
		.a(font_data_addr[11:0]),
		.spo(font_data[7:0])
	);
endmodule
