`timescale 1ns / 1ps

module DebugRegisters (

		input clock,
		input reset,

		input [31:0] id_instruction,

		output reg [31:0] ex_instruction = 0,
		output reg [31:0] mem_instruction = 0,
		output reg [31:0] wb_instruction = 0
	);

	always @(posedge clock) begin

		if (reset) begin

			ex_instruction <= 0;
			mem_instruction <= 0;
			wb_instruction <= 0;

		end else begin

			ex_instruction <= id_instruction;
			mem_instruction <= ex_instruction;
			wb_instruction <= mem_instruction;
		end
	end
endmodule
