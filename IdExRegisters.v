`timescale 1ns / 1ps

module IdExRegisters (

		input clock,
		input reset,

		input [31:0] id_pc_4,
		input [31:0] id_instruction,

		output reg [31:0] ex_pc_4 = 4,
		output reg [31:0] ex_instruction = 0
	);

	always @(posedge clock or posedge reset) begin
		if (reset) begin
			ex_pc_4 <= 4;
			ex_instruction <= 0;
		end else begin
			ex_pc_4 <= id_pc_4;
			ex_instruction <= id_instruction;
		end
	end
endmodule
