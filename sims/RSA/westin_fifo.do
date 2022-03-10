onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/clk}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/sys_rst_n}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/wr_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/rd_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/data_in}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/data_out}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/wr_addr}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/rd_addr}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/fifo}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_X[2]/u_sync_fifo/wr_en}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_X[2]/u_sync_fifo/rd_en}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_X[2]/u_sync_fifo/data_in}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_X[2]/u_sync_fifo/data_out}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_X[2]/u_sync_fifo/wr_addr}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_X[2]/u_sync_fifo/rd_addr}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_X[2]/u_sync_fifo/fifo}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/in_fifo_X[2]/u_sync_fifo/i_wr_addr}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[3]/u_sync_fifo/wr_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[3]/u_sync_fifo/rd_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[3]/u_sync_fifo/data_in}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[3]/u_sync_fifo/data_out}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[3]/u_sync_fifo/wr_addr}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[3]/u_sync_fifo/rd_addr}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[3]/u_sync_fifo/fifo}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[3]/u_sync_fifo/i_wr_addr}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {388129 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 114
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 2
configure wave -childrowmargin 1
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {358545 ps} {507446 ps}
