package fifo_test_pkg  ;
import fifo_env_pkg::*;
import fifo_reset_seq_pkg::*;
import fifo_write_only_seq_pkg::*;
import fifo_read_only_seq_pkg::*;
import fifo_write_read_seq_pkg::*;
import fifo_config_obj_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_test extends uvm_test;
`uvm_component_utils(fifo_test)
fifo_env env ;
fifo_reset_seq rst_seq ;
fifo_write_only_seq wr_seq ;
fifo_read_only_seq rd_seq ;
fifo_write_read_seq wr_rd_seq ;
fifo_config_obj cfg_obj_test ;
    function new(string name = "fifo_test" , uvm_component parent = null);
        super.new(name,parent);    
    endfunction //new()
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env :: type_id :: create ("env" , this) ; // this refere to this test class which is the parent for env
        cfg_obj_test = fifo_config_obj :: type_id :: create ("cfg_obj_test") ;
        rst_seq = fifo_reset_seq :: type_id :: create ("rst_seq") ;
        wr_seq = fifo_write_only_seq :: type_id :: create ("wr_seq") ;
        rd_seq = fifo_read_only_seq :: type_id :: create ("rd_seq") ;
        wr_rd_seq = fifo_write_read_seq :: type_id :: create ("wr_rd_seq") ;

        if(!uvm_config_db # (virtual FIFO_interface) :: get (this ,"","FIFO",cfg_obj_test.fifo_vif )) begin
            `uvm_fatal ("build_phase" , "TEST unable to get the virtual interface of the FIFO form configration data base ") ;
        end
        uvm_config_db # (fifo_config_obj) :: set (this ,"*","FIFOVIF",cfg_obj_test ) ;
    endfunction

    task  run_phase(uvm_phase phase);
        super.run_phase (phase) ;
        phase.raise_objection (this) ;
        // reset sequence 
        `uvm_info ("run_phase" , "Reseting Started ",UVM_LOW)
        rst_seq.start(env.agent.sqr) ;
        `uvm_info ("run_phase" , "Reseting  Ended ",UVM_LOW)

        // writing only sequence 
         `uvm_info ("run_phase" , "Writing only Started ",UVM_LOW)
        wr_seq.start(env.agent.sqr) ;
        `uvm_info ("run_phase" , "Writing only Ended ",UVM_LOW)

        // Reading only sequence 
        `uvm_info ("run_phase" , "Reading only Started ",UVM_LOW)
        rd_seq.start(env.agent.sqr) ;
        `uvm_info ("run_phase" , "Reading only Ended ",UVM_LOW) 

        // Writing and Reading  sequence 
        `uvm_info ("run_phase" , "Writing and Reading Started ",UVM_LOW)
        wr_rd_seq.start(env.agent.sqr) ;
        `uvm_info ("run_phase" , "Writing and Reading Ended ",UVM_LOW)
        
        phase.drop_objection(this) ;
    endtask : run_phase
    
endclass : fifo_test
    
endpackage