`timescale 1ns / 1ps

module terminal (
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

	localparam COLOR_WHITE = 8'b111_111_11;
	localparam COLOR_BLACK = 8'b000_000_00;

	// 640x480, 80x30
	reg [7:0] text [0:2399];

	always @(posedge clock) begin
		if (text_write) begin
			text[text_addr] <= text_in;
		end
	end
	assign text_out = text[text_addr];

	wire [11:0] text_index = x_position / 8 + (y_position / 16) * 80;
	wire [7:0] font_index = text[text_index];
	wire [2:0] font_x = x_position % 8;
	wire [3:0] font_y = y_position % 16;
	wire [11:0] font_addr = font_index * 16 + font_y;
	wire [7:0] font_out;
	font u_font (
		.a(font_addr[11:0]),
		.spo(font_out[7:0])
	);
	wire point = font_out[8 - font_x];
	assign color = inside_video ? (point ? COLOR_WHITE : COLOR_BLACK) : 8'b0;
endmodule
