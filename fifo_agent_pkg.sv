package fifo_agent_pkg ;
import fifo_seq_item_pkg::*;
import my_sequencer_pkg::*; 
import fifo_driver_pkg::*;
import fifo_monitor_pkg::*;
import fifo_config_obj_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_agent extends uvm_agent ;
`uvm_component_utils (fifo_agent)

my_sequencer sqr ;
fifo_driver driver ; 
fifo_monitor monitor ;
fifo_config_obj cfg_obj ;
uvm_analysis_port #(fifo_seq_item) agt_ap ; 

    function new(string name = "fifo_agent" , uvm_component parent = null);
        super.new(name,parent); 
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(fifo_config_obj) :: get (this, "" ,"FIFOVIF", cfg_obj)) 
        `uvm_fatal("build phase" , "Agent - unable to get configration object ")
        driver = fifo_driver :: type_id :: create ("driver", this);
        sqr = my_sequencer :: type_id :: create("sqr",this) ;
        monitor = fifo_monitor :: type_id :: create ("monitor", this) ; 
        agt_ap = new("agt_ap" ,this) ;  
    endfunction

    function void connect_phase(uvm_phase phase );
        driver.fifo_vif  = cfg_obj.fifo_vif;
        monitor.fifo_vif = cfg_obj.fifo_vif;
        driver.seq_item_port.connect(sqr.seq_item_export);
        monitor.mon_ap.connect(agt_ap);
    endfunction

endclass //className extends superClass
endpackage