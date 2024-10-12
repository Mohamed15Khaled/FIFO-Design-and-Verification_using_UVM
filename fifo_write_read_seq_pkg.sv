package fifo_write_read_seq_pkg ;
    import fifo_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh" 
    class fifo_write_read_seq extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_write_read_seq)
    fifo_seq_item seq_item ;
    int read_dist  ;
    int write_dist ;

        function new(string name = "fifo_write_read_seq" );
            super.new(name) ;
        endfunction //new()

        task body ;
        // Randomize transactions with mostly writes
        read_dist = 30 ; write_dist = 70 ;
            repeat (500) begin
                seq_item = fifo_seq_item :: type_id :: create("seq_item");
                seq_item.RD_EN_ON_DIST = read_dist;
                seq_item.WR_EN_ON_DIST = write_dist;
                start_item (seq_item) ;
                assert(seq_item.randomize()) ;
                finish_item(seq_item) ;
            end 

        // Randomize transactions with mostly writes
        read_dist = 70 ; write_dist = 50 ;
            repeat (500) begin
                seq_item = fifo_seq_item :: type_id :: create("seq_item");
                seq_item.RD_EN_ON_DIST = read_dist;
                seq_item.WR_EN_ON_DIST = write_dist;
                start_item (seq_item) ;
                assert(seq_item.randomize()) ;
                finish_item(seq_item) ;
            end 

        // Randomize transactions with equal reads and writes
        read_dist = 50 ; write_dist = 50 ;
            repeat (500) begin
                seq_item = fifo_seq_item :: type_id :: create("seq_item");
                seq_item.RD_EN_ON_DIST = read_dist;
                seq_item.WR_EN_ON_DIST = write_dist;
                start_item (seq_item) ;
                assert(seq_item.randomize()) ;
                finish_item(seq_item) ;
            end 

        endtask 

    endclass //fifo_write_read_seq extends superClass
endpackage