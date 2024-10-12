vlib work
vlog +define+fifo_assertions *v +cover -covercells
vsim -voptargs=+acc work.FIFO_TOP -cover
add wave /FIFO_TOP/FIFO_if/*
coverage save FIFO_TOP.ucdb -onexit
run -all
 