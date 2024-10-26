transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Usuario/Desktop/467/labs-and-homework-jayalm7/lab-5/led_state_machine.vhd}

