`timescale 1ns / 1ps

module BinaryAsciiConverter (
		input binary,
		output [7:0] ascii
	);

	assign ascii = binary ? "1" : "0";
endmodule
