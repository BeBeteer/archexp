`timescale 1ns / 1ps

module console (
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
	wire [11:0] text_index;
	wire [7:0] font_index;
	wire [2:0] font_x;
	wire [3:0] font_y;
	wire [11:0] font_data_addr;
	wire [7:0] font_data;
	wire point;

	initial begin
		text[0] = "0";
		text[1] = "1";
		text[2] = "2";
		text[3] = "3";
		text[4] = "4";
		text[5] = "5";
		text[6] = "6";
		text[7] = "7";
		text[8] = "8";
		text[9] = "9";
		text[10] = "A";
		text[11] = "B";
		text[12] = "C";
		text[13] = "D";
		text[14] = "E";
		text[15] = "F";
		text[16] = "G";
		text[17] = "H";
		text[18] = "I";
		text[19] = "J";
	end

	always @(posedge clock) begin
		if (text_write) begin
			text[text_addr] <= text_in;
		end
	end
	assign text_out = text[text_addr];

	assign text_index = x_position / 8 + (y_position / 16) * 80;
	assign font_index = text[text_index];
	assign font_x = x_position % 8;
	assign font_y = y_position % 16;
	assign font_data_addr = font_index * 16 + font_y;
	assign point = font_data[8 - font_x];
	assign color = inside_video ? (point ? COLOR_WHITE : COLOR_BLACK) : 8'b0;

	font_data U_font_data (
		.a(font_data_addr[11:0]),
		.spo(font_data[7:0])
	);
endmodule
