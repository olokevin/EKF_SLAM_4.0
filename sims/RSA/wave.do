onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_RSA/clk
add wave -noupdate /tb_RSA/sys_rst_n
add wave -noupdate /tb_RSA/SA_start
add wave -noupdate /tb_RSA/Xin_val
add wave -noupdate /tb_RSA/Xin_data
add wave -noupdate /tb_RSA/Yin_val
add wave -noupdate /tb_RSA/Yin_data
add wave -noupdate /tb_RSA/out_rdy
add wave -noupdate -radix unsigned /tb_RSA/out_data
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/rd_en}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/data_out}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {54356 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {15759 ps} {157607 ps}
