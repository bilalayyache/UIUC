transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/alu_unit.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/register_module.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/Synchronizers.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/HexDriver.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/tristate.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/test_memory.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/SLC3_2.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/Mem2IO.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/ISDU.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/mux4.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/register.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/bus.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/nzp.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/memory_contents.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/pc_module.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/mdr_module.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/datapath.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/slc3.sv}
vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/lab6_toplevel.sv}

vlog -sv -work work +incdir+U:/ece385_lab6 {U:/ece385_lab6/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 2000 ns
