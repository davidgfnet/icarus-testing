`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:51:15 09/08/2015 
// Design Name: 
// Module Name:    uart_echo 
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
module uart_echo(
    input clk,
    input uart_rx,
    output uart_tx
);

wire[7:0] data_rx;
reg [7:0] data_tx;
wire      got_something;
reg       do_send;
wire      tx_busy;
wire      fifo_empty;
reg       fifo_rd_done;
wire[7:0] fifo_rd_port;

always @(posedge clk) begin
	do_send <= 0;
	if (!tx_busy && !do_send) begin
		data_tx <= data_tx + 1'b1;
		do_send <= 1;
	end
end

uart uart_test(
	.clk(clk), .reset(1'b0),

	.rx(uart_rx), .tx(uart_tx),
	.tx_byte(data_tx), .tx_req(do_send), .tx_busy(tx_busy),
	.rx_ready(got_something), .rx_byte(data_rx)
);


endmodule
