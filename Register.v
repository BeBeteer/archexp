`timescale 1ns / 1ps

module Register (
		input clock,
		input reset,
		input writeEnabled,
		output [31:0] readData,
		input [31:0] writeData
	);

	reg [31:0] register = 0;

	assign readData = register;

	always @(posedge clock or posedge reset) begin
		if (reset) begin
			register <= 0;
		end else if (writeEnabled) begin
			register <= writeData;
		end
	end
endmodule
