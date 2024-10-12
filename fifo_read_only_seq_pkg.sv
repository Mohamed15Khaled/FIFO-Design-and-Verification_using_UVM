package fifo_read_only_seq_pkg ;
    import fifo_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh" 
    class fifo_read_only_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_read_only_seq)
    fifo_seq_item seq_item ;
    int read_dist = 100 ; // Read only
    int write_dist = 0 ; // No write 
        function new(string name = "fifo_read_only_seq" );
            super.new(name) ;
        endfunction //new()
        task body ;
           repeat (50) begin
            seq_item = fifo_seq_item :: type_id :: create("seq_item");
            seq_item.RD_EN_ON_DIST = read_dist;
            seq_item.WR_EN_ON_DIST = write_dist;
            start_item (seq_item) ;
            assert(seq_item.randomize()) ;
            finish_item(seq_item) ;
           end 
        endtask //automatic
    endclass //fifo_read_only_seq extends superClass
endpackage