transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+U:/ece385_lab4_processor {U:/ece385_lab4_processor/Synchronizers.sv}
vlog -sv -work work +incdir+U:/ece385_lab4_processor {U:/ece385_lab4_processor/Router.sv}
vlog -sv -work work +incdir+U:/ece385_lab4_processor {U:/ece385_lab4_processor/Reg_8.sv}
vlog -sv -work work +incdir+U:/ece385_lab4_processor {U:/ece385_lab4_processor/HexDriver.sv}
vlog -sv -work work +incdir+U:/ece385_lab4_processor {U:/ece385_lab4_processor/Control.sv}
vlog -sv -work work +incdir+U:/ece385_lab4_processor {U:/ece385_lab4_processor/compute.sv}
vlog -sv -work work +incdir+U:/ece385_lab4_processor {U:/ece385_lab4_processor/Register_unit.sv}
vlog -sv -work work +incdir+U:/ece385_lab4_processor {U:/ece385_lab4_processor/Processor.sv}

vlog -sv -work work +incdir+U:/ece385_lab4_processor {U:/ece385_lab4_processor/testbench_8.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
