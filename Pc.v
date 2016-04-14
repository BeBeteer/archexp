`timescale 1ns / 1ps

module Pc (

		input clock,
		input reset,

		input [31:0] nextPc,
		output reg [31:0] pc = 0
	);

	always @(posedge clock or posedge reset) begin
		if (reset) begin
			pc <= 0;
		end else begin
			pc <= nextPc;
		end
	end
endmodule
