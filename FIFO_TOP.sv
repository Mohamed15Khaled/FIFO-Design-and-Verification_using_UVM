import fifo_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module FIFO_TOP ();

bit clk ; 
initial begin
    clk = 1 ;
    forever begin
        #1 clk =~clk ;
    end
end
FIFO_interface FIFO_if (clk);
FIFO dut (FIFO_if) ;

initial begin
    uvm_config_db # (virtual FIFO_interface ) :: set (null , "uvm_test_top", "FIFO" , FIFO_if );
    run_test("fifo_test") ; 
end

endmodule