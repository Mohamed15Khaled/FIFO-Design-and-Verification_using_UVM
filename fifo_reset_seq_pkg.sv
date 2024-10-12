package fifo_reset_seq_pkg ;
    import fifo_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh" 
    class fifo_reset_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_reset_seq)
    fifo_seq_item seq_item ;
 
        function new(string name = "fifo_reset_seq" );
            super.new(name) ;
        endfunction //new()
        task body ;
            seq_item = fifo_seq_item :: type_id :: create("seq_item");
            start_item (seq_item) ;
            assert(seq_item.randomize()) ;
            seq_item.rst_n = 0 ; 
            finish_item(seq_item) ;
        endtask 
    endclass //fifo_reset_seq extends superClass
endpackage