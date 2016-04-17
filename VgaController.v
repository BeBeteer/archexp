`timescale 1ns / 1ps

module VgaController (
		input clock25Mhz,
		input reset,
		output reg hSync = 0,
		output reg vSync = 0,
		output reg isActive = 0,
		output [9:0] x,
		output [8:0] y
	);

	// SYNC, BPORCH, VIDEO, FPORCH.
	localparam H_SYNC = 96;
	localparam H_BPORCH = 144;
	localparam H_FPORCH = 784;
	localparam H_TOTAL = 800;
	localparam V_SYNC = 2;
	localparam V_BPORCH = 35;
	localparam V_FPORCH = 511;
	localparam V_TOTAL = 525;

	reg [9:0] hCounter = 0;
	reg [9:0] vCounter = 0;
	reg shouldIncrementVCounter = 0;

	always @(posedge clock25Mhz or posedge reset) begin
		if (reset) begin
			hCounter <= 0;
		end else if (hCounter == H_TOTAL - 1) begin
			hCounter <= 0;
			shouldIncrementVCounter <= 1;
		end else begin
			hCounter <= hCounter + 1'b1;
			shouldIncrementVCounter <= 0;
		end
	end

	always @(*) begin
		if (hCounter < H_SYNC) begin
			hSync = 0;
		end else begin
			hSync = 1;
		end
	end

	always @(posedge clock25Mhz or posedge reset) begin
		if (reset) begin
			vCounter <= 0;
		end else if (shouldIncrementVCounter) begin
			if (vCounter == V_TOTAL - 1) begin
				vCounter <= 0;
			end else begin
				vCounter <= vCounter + 1'b1;
			end
		end
	end

	always @(*) begin
		if (vCounter < V_SYNC) begin
			vSync = 0;
		end else begin
			vSync = 1;
		end
	end

	always @(*) begin
		if ((hCounter >= H_BPORCH) && (hCounter < H_FPORCH) && (vCounter >= V_BPORCH) && (vCounter < V_FPORCH)) begin
			isActive = 1;
		end else begin
			isActive = 0;
		end
	end

	assign x = hCounter - H_BPORCH;
	assign y = vCounter - V_BPORCH;
endmodule
