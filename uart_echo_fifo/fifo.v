`timescale 1ns / 1ps

module fifo #(parameter width = 16)
(
	input clk,
	input reset,

	// Write port
	input  [(width-1):0] wr_port,  // Data in port
	input                wr_req,   // Request to add data into the queue
	output               q_full,   // The queue is full (cannot write any more)

	// Read port
	output [(width-1):0] rd_port,  // Next data in the queue
	output               q_empty,  // The queue is empty! (cannot read!)
	input                rd_done   // The user read the current data within the queue
);

parameter nentries =     64;
parameter entrysz =       6;  // Log(entries) (wrap bit)

initial $dumpvars(0, write_ptr);
initial $dumpvars(0, read_ptr);

// The MSB bit of the rd/wr pointer is used for wraping purposes
// So when rd=wr means it's empty and when wr = rd + N (where N is
// queue size) means that it's full.

// Mantain an entry buffer, and write pointer
wire [entrysz:0]    nentries_bus;
reg [(width-1):0]   entries [0:(nentries-1)];

reg  [entrysz:0]    write_ptr, read_ptr;
wire [entrysz:0]    next_write_ptr, next_read_ptr;

assign nentries_bus = nentries;

assign q_full = (read_ptr - write_ptr) == nentries_bus;
assign q_empty = (read_ptr == write_ptr);

assign next_write_ptr = write_ptr + 1'b1;  // Advance write pointer
assign next_read_ptr = read_ptr + 1'b1;    // Advance read ptr

always @(posedge clk)
begin
	if (reset) begin
		write_ptr <= 0;
		read_ptr <= 0;
	end else begin
		if (wr_req && !q_full) begin
			write_ptr <= next_write_ptr;
			entries[write_ptr[(entrysz-1):0]] <= wr_port;
		end
		if (rd_done && !q_empty) begin
			read_ptr <= next_read_ptr;
		end
	end
end

// Read logic
assign rd_port = entries[read_ptr[(entrysz-1):0]];

endmodule

