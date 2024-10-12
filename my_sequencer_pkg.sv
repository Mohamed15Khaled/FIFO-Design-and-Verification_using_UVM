package my_sequencer_pkg ;
import fifo_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class my_sequencer extends uvm_sequencer #(fifo_seq_item);
`uvm_component_utils(my_sequencer) 
    function new(string name = "my_sequencer" , uvm_component parent = null);
        super.new(name,parent) ;
    endfunction //new()
endclass //className extends superClass
    
endpackage