`timescale 1ns / 1ps

module HexAsciiConverter (
		input [3:0] hex,
		output [7:0] ascii
	);

	assign ascii = hex < 4'd10 ? hex + "0" : hex - 4'd10 + "A";
endmodule
