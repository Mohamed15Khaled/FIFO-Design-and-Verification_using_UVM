package fifo_scoreboard_pkg ;
    import shared_pkg::*;
    import fifo_seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class fifo_scoreboard extends uvm_scoreboard ;
        `uvm_component_utils(fifo_scoreboard)
        uvm_analysis_export #(fifo_seq_item) sb_export ;
        uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo ;
        fifo_seq_item seq_item_sb ;
        
        const int FULL_SIZE = FIFO_DEPTH ;
        const int ALMOST_FULL_SIZE = FIFO_DEPTH-1 ;
        const int EMPTY_SIZE = 0 ;
        const int ALMOST_EMPTY_SIZE = 1 ;
        int actual_size = 0 ; // the actual size of the fifo after reading and writing 

        logic[FIFO_WIDTH-1:0] fifo_ref [$] ;
        logic[FIFO_WIDTH-1:0] data_out_ref; 
        logic wr_ack_ref, overflow_ref ;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

        function new(string name = "fifo_scoreboard" , uvm_component parent = null);
            super.new(name,parent); 
        endfunction //new()

        function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export" , this) ;
        sb_fifo = new("sb_fifo" , this) ;
        endfunction

        function void connect_phase(uvm_phase phase); 
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export) ;
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb) ;
                reference_model(seq_item_sb) ;
                if (seq_item_sb.data_out != data_out_ref) begin
                    $display("ERROR data_out_observed  = 0h%0h , data_out_expected = 0h%0h ", seq_item_sb.data_out , data_out_ref);
                    error_count++ ;
                end
                else begin
                    correct_count++ ; 
                end
               
                // extra part checking other outputs 
                if (seq_item_sb.full != full_ref || seq_item_sb.almostfull != almostfull_ref || seq_item_sb.empty != empty_ref 
                || seq_item_sb.almostempty != almostempty_ref || seq_item_sb.wr_ack != wr_ack_ref || seq_item_sb.overflow != overflow_ref
                || seq_item_sb.underflow != underflow_ref ) begin
                $display ("Error in flags ") ;
                error_count++ ;
                end
            end 
        endtask

        task reference_model(fifo_seq_item seq_item_check );
        
                if (!seq_item_check.rst_n) begin
                    fifo_ref.delete(); 
                    overflow_ref = 0 ; underflow_ref = 0 ; 
                    actual_size = 0 ; wr_ack_ref = 0 ;     
                end
                else begin
                    // seting default values for sequential outputs except data_out to be assigned with it until no condition change it 
                    overflow_ref = 0 ; underflow_ref = 0 ; 
                    // push and pop data from the fifo 
                    case ({seq_item_check.wr_en , seq_item_check.rd_en})
                        2'b11: begin // write and read 
                            if(actual_size != FULL_SIZE && actual_size != EMPTY_SIZE) begin
                                fifo_ref.push_back(seq_item_check.data_in) ;
                                data_out_ref = fifo_ref.pop_front() ;
                                wr_ack_ref = 1 ;
                            end 
                            else if (actual_size == FULL_SIZE) begin
                                data_out_ref = fifo_ref.pop_front();
                                actual_size = actual_size - 1 ;
                                wr_ack_ref = 0 ; 
                            end   
                            else if (actual_size == EMPTY_SIZE) begin
                                fifo_ref.push_back(seq_item_check.data_in) ;
                                actual_size = actual_size+1 ; 
                                wr_ack_ref = 1 ; 
                            end
                        end
                        2'b10 : begin // write only 
                            if(actual_size != FULL_SIZE) begin
                                fifo_ref.push_back (seq_item_check.data_in);
                                actual_size = actual_size + 1 ;
                                wr_ack_ref = 1 ; 
                            end
                            else begin
                                overflow_ref = 1 ; wr_ack_ref =  0 ; 
                            end
                        end
                        2'b01 : begin // read only 
                            if(actual_size != EMPTY_SIZE) begin
                                data_out_ref = fifo_ref.pop_front() ; 
                                actual_size = actual_size - 1 ; 
                                wr_ack_ref = 0 ;
                            end 
                            else begin
                                underflow_ref = 1 ;
                                wr_ack_ref = 0 ;
                            end 
                        end 
                        2'b00 : begin
                            wr_ack_ref = 0 ; overflow_ref = 0 ; underflow_ref = 0; 
                        end    
                    endcase  
                end 
                    almostempty_ref = 0 ; empty_ref = 0 ;
                    almostfull_ref = 0 ; full_ref = 0 ;
                    if (actual_size == FULL_SIZE) begin
                        full_ref = 1 ;  
                    end
                    else if (actual_size == ALMOST_FULL_SIZE) begin
                        almostfull_ref = 1 ;
                    end
                    else if (actual_size == EMPTY_SIZE) begin
                        empty_ref = 1 ; 
                    end
                    else if (actual_size == ALMOST_EMPTY_SIZE) begin
                        almostempty_ref = 1 ;  
                    end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful transactions: %0d", correct_count), UVM_MEDIUM);
            `uvm_info("report_phase", $sformatf("Total failed transactions: %0d", error_count), UVM_MEDIUM);
        endfunction

    endclass 
endpackage