module fifo_assertions (FIFO_interface.DUT FIFO_if);
 
always_comb begin 
if(dut.count == FIFO_if.FIFO_DEPTH) 
FULL : assert final (FIFO_if.full == 1) ;
else 
NOT_FULL : assert final (FIFO_if.full == 0) ;

if(dut.count == FIFO_if.FIFO_DEPTH-1) 
ALMOSTFULL : assert final (FIFO_if.almostfull == 1) ;
else 
NOT_ALMOSTFULL : assert final (FIFO_if.almostfull == 0) ;

if(sut.count == 0) 
EMPTY : assert final (FIFO_if.empty == 1) ;
else 
NOT_EMPTY : assert final (FIFO_if.empty == 0) ;

if(dut.count == 1) 
ALMOSTEMPTY : assert final (FIFO_if.almostempty == 1) ;
else 
NOT_ALMOSTEMPTY : assert final (FIFO_if.almostempty == 0) ;
 // reset 
if (!FIFO_if.rst_n)
assert_reset : assert final (dut.wr_ptr==0 && dut.rd_ptr == 0 && FIFO_if.wr_ack == 0 && FIFO_if.overflow == 0 && FIFO_if.underflow == 0 && dut.count == 0) ;

end

property write_ptr ;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && dut.count < FIFO_if.FIFO_DEPTH) |=> (dut.wr_ptr == $past(dut.wr_ptr+1'b1));
endproperty

property read_ptr ;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.rd_en && dut.count != 0) |=> (dut.rd_ptr == $past(dut.rd_ptr+1'b1)) ;
endproperty

property counter_up ;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) ((({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b10) && !FIFO_if.full) || (FIFO_if.empty && ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) )) |=> (dut.count == $past(dut.count+1'b1)) ;
endproperty

property counter_down ;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) ( (({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b01) && !FIFO_if.empty) || (FIFO_if.full && ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) )) |=> (dut.count == $past(dut.count-1'b1)) ;
endproperty

property wr_acknowlage ;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && dut.count < FIFO_if.FIFO_DEPTH) |=> (FIFO_if.wr_ack == 1);
endproperty

property high_overflow ;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.full & FIFO_if.wr_en & !FIFO_if.rd_en) |=> (FIFO_if.overflow == 1) ;
endproperty

property low_overflow ;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) !(FIFO_if.full & FIFO_if.wr_en & !FIFO_if.rd_en) |=> (FIFO_if.overflow == 0) ;
endproperty

property high_underflow ;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.empty & !FIFO_if.wr_en & FIFO_if.rd_en) |=> (FIFO_if.underflow == 1) ;
endproperty

property low_underflow ;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) !(FIFO_if.empty & !FIFO_if.wr_en & FIFO_if.rd_en) |=> (FIFO_if.underflow == 0) ;
endproperty

// assert assertions 
// Write pointer assertion
Write_pointer: assert property (write_ptr);

// Read pointer assertion
Read_pointer: assert property (read_ptr);

// Counter up assertion
Counter_up: assert property (counter_up);

// Counter down assertion
Counter_down: assert property (counter_down);

// Write acknowledge assertion
Write_acknowledge: assert property (wr_acknowlage);

// High overflow assertion
High_overflow: assert property (high_overflow);

// Low overflow assertion
Low_overflow: assert property (low_overflow);

// High underflow assertion
High_underflow: assert property (high_underflow);

// Low underflow assertion
Low_underflow: assert property (low_underflow);

// coverage the assertions 
// Write pointer cover property
Write_pointer_cover: cover property (write_ptr);

// Read pointer cover property
Read_pointer_cover: cover property (read_ptr);

// Counter up cover property
Counter_up_cover: cover property (counter_up);

// Counter down cover property
Counter_down_cover: cover property (counter_down);

// Write acknowledge cover property
Write_acknowledge_cover: cover property (wr_acknowlage);

// High overflow cover property
High_overflow_cover: cover property (high_overflow);

// Low overflow cover property
Low_overflow_cover: cover property (low_overflow);

// High underflow cover property
High_underflow_cover: cover property (high_underflow);

// Low underflow cover property
Low_underflow_cover: cover property (low_underflow);


endmodule