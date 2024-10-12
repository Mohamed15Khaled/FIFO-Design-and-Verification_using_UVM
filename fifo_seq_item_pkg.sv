package fifo_seq_item_pkg ;
import uvm_pkg::*;
`include "uvm_macros.svh"
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
class fifo_seq_item extends uvm_sequence_item ;
`uvm_object_utils (fifo_seq_item)
// declare variables 
int RD_EN_ON_DIST = 30 ;
int WR_EN_ON_DIST = 70 ;
rand logic [FIFO_WIDTH-1:0] data_in;
rand logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
function new(string name = "fifo_seq_item");
    super.new(name);  
endfunction // new
//  ------------constraint_randamization----------------------
constraint reset {
    rst_n dist {1:/99 , 0:/1} ; // active low reset most of the time 
} 
constraint Write_en {
    wr_en dist {1:/WR_EN_ON_DIST , 0:/ (100-WR_EN_ON_DIST) };
}  
constraint Read_en {
    rd_en dist {1:/RD_EN_ON_DIST , 0:/(100-RD_EN_ON_DIST)};
}

function string convert2string();
        return $sformatf ("%s reset =%0b , wr_en = %0b , rd_en = %0b , data_in = 0d%0d, data_out = 0d%0d  ",
         super.convert2string(), rst_n,wr_en, rd_en , data_in , data_out ) ;    
    endfunction

    function string convert2string_stimulus();
        return $sformatf (" reset =%0b , wr_en = %0b , rd_en = %0b , data_in = 0d%0d, data_out = 0d%0d  ",
         rst_n,wr_en, rd_en , data_in , data_out ) ;    
    endfunction

endclass //className
    
endpackage