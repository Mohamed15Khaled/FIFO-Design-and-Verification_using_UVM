interface FIFO_interface(clk) ;
input clk ;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
bit [FIFO_WIDTH-1:0] data_in;
bit clk, rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow, underflow;
logic  full, empty, almostfull, almostempty;   

modport DUT (
input data_in,clk,rst_n,wr_en , rd_en ,
output data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow
);

endinterface //interfacename