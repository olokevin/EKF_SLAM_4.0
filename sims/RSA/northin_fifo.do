onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[1]/u_sync_fifo/wr_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[1]/u_sync_fifo/rd_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[1]/u_sync_fifo/data_in}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[1]/u_sync_fifo/data_out}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[1]/u_sync_fifo/wr_addr}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[1]/u_sync_fifo/rd_addr}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_Y[2]/u_sync_fifo/wr_en}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_Y[2]/u_sync_fifo/rd_en}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_Y[2]/u_sync_fifo/data_in}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_Y[2]/u_sync_fifo/data_out}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_Y[2]/u_sync_fifo/wr_addr}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_Y[2]/u_sync_fifo/rd_addr}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[3]/u_sync_fifo/wr_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[3]/u_sync_fifo/rd_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[3]/u_sync_fifo/data_in}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[3]/u_sync_fifo/data_out}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[3]/u_sync_fifo/wr_addr}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_Y[3]/u_sync_fifo/rd_addr}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {499270 ps} 0}
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
WaveRestoreZoom {368659 ps} {506913 ps}
