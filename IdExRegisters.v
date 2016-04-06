`timescale 1ns / 1ps

module IdExRegisters (

		input clock,

		input [31:0] id_pc_4,
		input [31:0] id_instruction,

		output reg [31:0] ex_pc_4,
		output reg [31:0] ex_instruction
	);

	always @(posedge clock) begin
		ex_pc_4 <= id_pc_4;
		ex_instruction <= id_instruction;
	end
endmodule
