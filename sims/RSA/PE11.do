onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/clk}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/sys_rst_n}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/wr_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/rd_en}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/data_in}
add wave -noupdate {/tb_RSA/u_RSA/in_fifo_X[1]/u_sync_fifo/data_out}
add wave -noupdate {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/clk}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/sys_rst_n}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/cal_en}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/cal_done}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/westin}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/northin}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/din_val}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/din}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/dout_val}
add wave -noupdate -itemcolor Blue {/tb_RSA/u_RSA/PE_MAC_X[1]/PE_MAC_Y[1]/genblk1/u_PE_MAC/dout}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/clk}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/sys_rst_n}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/wr_en}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/rd_en}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/data_in}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/data_out}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/empty}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/full}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/wr_addr}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/rd_addr}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/count}
add wave -noupdate {/tb_RSA/u_RSA/out_fifo[1]/u_sync_fifo/fifo}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {243776 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 154
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {826016 ps} {927734 ps}