`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:02:34 09/08/2015 
// Design Name: 
// Module Name:    test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test(
    input clk,
    output [3:0] led
    );
	 
reg [25:0] counter;
reg [3:0]  val;

always @(posedge clk) begin
	counter <= counter + 1;
	if (counter == 0)
		val <= ~val;
end

assign led = val;

endmodule
