vdel -all
vlib work

vlog RAM.v
vlog Wrapper.v 
vlog SPI_SLAVE.v
# vlog SPI_tb.v

# vsim -voptargs=+acc work.SPI_tb
#add wave sim:/SPI_tb/*
#add wave -r sim:/SPI_tb/dut/*

run -all