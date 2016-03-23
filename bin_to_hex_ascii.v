`timescale 1ns / 1ps

module bin_to_hex_ascii (
	input [3:0] in,
	output [7:0] out
	);

	assign out = in < 10 ? in + "0" : in - 7'd10 + "A";
endmodule
