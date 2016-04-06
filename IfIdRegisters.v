`timescale 1ns / 1ps

module IfIdRegisters(
		input clock,
		input [31:0] if_pc_4,
		input [31:0] if_instruction,
		output reg [31:0] id_pc_4,
		output reg [31:0] id_instruction
	);

	always @(posedge clock) begin
		id_pc_4 <= if_pc_4;
		id_instruction <= if_instruction;
	end
endmodule
