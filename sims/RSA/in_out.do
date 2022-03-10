onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_RSA/clk
add wave -noupdate /tb_RSA/sys_rst_n
add wave -noupdate /tb_RSA/Xin_val
add wave -noupdate /tb_RSA/Xin_data
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/wr_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/data_in}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/rd_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/data_out}
add wave -noupdate -itemcolor Blue /tb_RSA/Yin_val
add wave -noupdate -itemcolor Blue /tb_RSA/Yin_data
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_Y[1]/u_sync_fifo/wr_en}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_Y[1]/u_sync_fifo/data_in}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_Y[1]/u_sync_fifo/rd_en}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_Y[1]/u_sync_fifo/data_out}
add wave -noupdate /tb_RSA/u_RSA/u_PE_config/cal_en
add wave -noupdate /tb_RSA/u_RSA/u_PE_config/cal_done
add wave -noupdate {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/dout_val}
add wave -noupdate {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/dout}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/rd_en}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/data_out}
add wave -noupdate -itemcolor Blue /tb_RSA/u_RSA/out_val
add wave -noupdate -itemcolor Blue -radix unsigned /tb_RSA/out_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {211690 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 100
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
WaveRestoreZoom {197192 ps} {348836 ps}
