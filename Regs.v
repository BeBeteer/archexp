`timescale 1ns / 1ps

module Regs(
		input clk,
		input rst,
		input L_S,
		input [4:0] R_addr_A,
		input [4:0] R_addr_B,
		input [4:0] Wt_addr,
		input [31:0] Wt_data,
		output [31:0] rdata_A,
		output [31:0] rdata_B,
		output [32 * 32 - 1 : 0] regs
	);

	reg [31:0] register [1:31];

	initial begin
		for (i = 1; i < 32; i = i + 1) begin
			register[i] = 0;
		end
	end

	assign rdata_A = R_addr_A == 0 ? 0 : register[R_addr_A];

	assign rdata_B = R_addr_B == 0 ? 0 : register[R_addr_B];

	integer i;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			for (i = 1; i < 32; i = i + 1) begin
				register[i] <= 0;
			end
		end else if (L_S == 1 && Wt_addr != 0) begin
			register[Wt_addr] <= Wt_data;
		end
	end

	assign regs = {register[31], register[30], register[29], register[28],
			register[27], register[26], register[25], register[24], register[23],
			register[22], register[21], register[20], register[19], register[18],
			register[17], register[16], register[15], register[14], register[13],
			register[12], register[11], register[10], register[9], register[8],
			register[7], register[6], register[5], register[4], register[3],
			register[2], register[1], 32'b0};
endmodule
