transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/Bin2BCD.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/sdr_top.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/sdr_test.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/sdr_fifo_ctrl.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/sdr_ctrl_top.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/sdr_controller.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/para.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/ipcore {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/ipcore/wr_fifo.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/ipcore {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/ipcore/rd_fifo.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/ipcore {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/ipcore/pll.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/Seg.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/db {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/db/pll_altpll.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/sdr_data.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/sdr_ctrl.v}
vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/src/sdr_cmd.v}

vlog -vlog01compat -work work +incdir+F:/FPGA_Learning/Course\ Design/CourseDesign_Mars/CourseDesign_Mars_2.13 {F:/FPGA_Learning/Course Design/CourseDesign_Mars/CourseDesign_Mars_2.13/sdr_ctrl_top_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  sdr_ctrl_top_tb

add wave *
view structure
view signals
run -all
