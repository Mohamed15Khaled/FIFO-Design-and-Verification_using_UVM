package fifo_coverage_pkg ;
import fifo_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_coverage extends uvm_component ;
`uvm_component_utils(fifo_coverage)
uvm_analysis_export #(fifo_seq_item) cov_export;
uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;
fifo_seq_item seq_item_cov ; 

covergroup  cvr_gp ;    
Reset : coverpoint seq_item_cov.rst_n ;
Read_EN : coverpoint seq_item_cov.rd_en ;
Write_EN : coverpoint seq_item_cov.wr_en ;
Write_acknowledge : coverpoint seq_item_cov.wr_ack ; 
Overflow : coverpoint seq_item_cov.overflow ;
FULL : coverpoint seq_item_cov.full ;
EMPTY : coverpoint seq_item_cov.empty ;
ALMOSTFULL : coverpoint seq_item_cov.almostfull ;
ALMOSTEMPTY : coverpoint seq_item_cov.almostempty ;
UNDERFLOW : coverpoint seq_item_cov.underflow ;
// crossing read_en and write_en with the outputs 
Cross_rd_wr_writer_ack : cross Read_EN , Write_EN , Write_acknowledge {
    illegal_bins high_wr_ack_low_write = binsof(Write_acknowledge) intersect {1} && binsof(Write_EN) intersect {0} ; // they mustn't happened  
}
Cross_rd_wr_Overflow : cross Read_EN , Write_EN , Overflow {
    illegal_bins high_overflow_low_write = binsof(Overflow) intersect {1} && binsof(Write_EN) intersect {0} ; // they mustn't happened 
    illegal_bins high_rd_full_low_write = binsof(Write_EN) intersect {1} && binsof (Read_EN) intersect {1} && binsof(Overflow) intersect {1} ; // they mustn't happend 
}
Cross_rd_wr_FULL : cross Read_EN , Write_EN , FULL {
    illegal_bins all_high = binsof(Write_EN) intersect {1} && binsof (Read_EN) intersect {1} && binsof(FULL) intersect {1} ; // they mustn't happend 
    illegal_bins high_rd_full_low_write = binsof(Write_EN) intersect {0} && binsof (Read_EN) intersect {1} && binsof(FULL) intersect {1} ; // they mustn't happend 
}
Cross_rd_wr_EMPTY : cross Read_EN , Write_EN , EMPTY ;
Cross_rd_wr_ALMOSTFULL : cross Read_EN , Write_EN , ALMOSTFULL ;
Cross_rd_wr_ALMOSTEMPTY : cross Read_EN , Write_EN , ALMOSTEMPTY ;
Cross_rd_wr_UNDERFLOW : cross Read_EN , Write_EN , UNDERFLOW {
    illegal_bins high_underflow_low_read = binsof(UNDERFLOW) intersect {1} && binsof(Read_EN) intersect {0} ; // they mustn't happened 
    illegal_bins high_rd_full_low_write = binsof(Write_EN) intersect {1} && binsof (Read_EN) intersect {1} && binsof(UNDERFLOW) intersect {1} ; // they mustn't happend 
}
endgroup

function new(string name = "fifo_coverage" , uvm_component parent = null);
    super.new(name,parent);
    cvr_gp = new() ;     
endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export", this);
        cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(seq_item_cov);
            cvr_gp.sample();
        end
    endtask
 
    
endclass //className
endpackage