transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+U:/ece385_lab5 {U:/ece385_lab5/HexDriver.sv}
vlog -sv -work work +incdir+U:/ece385_lab5 {U:/ece385_lab5/register.sv}
vlog -sv -work work +incdir+U:/ece385_lab5 {U:/ece385_lab5/adder.sv}
vlog -sv -work work +incdir+U:/ece385_lab5 {U:/ece385_lab5/Control.sv}
vlog -sv -work work +incdir+U:/ece385_lab5 {U:/ece385_lab5/d_flipflop.sv}
vlog -sv -work work +incdir+U:/ece385_lab5 {U:/ece385_lab5/multiplier_toplevel.sv}

vlog -sv -work work +incdir+U:/ece385_lab5 {U:/ece385_lab5/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
