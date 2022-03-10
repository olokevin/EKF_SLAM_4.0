onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_RSA/u_RSA/u_PE_config/clk
add wave -noupdate /tb_RSA/u_RSA/u_PE_config/sys_rst_n
add wave -noupdate /tb_RSA/u_RSA/u_PE_config/Xin_val
add wave -noupdate /tb_RSA/u_RSA/u_PE_config/Yin_val
add wave -noupdate -expand /tb_RSA/u_RSA/u_PE_config/westin_wr_en
add wave -noupdate -expand /tb_RSA/u_RSA/u_PE_config/northin_wr_en
add wave -noupdate -expand /tb_RSA/u_RSA/u_PE_config/westin_rd_en
add wave -noupdate -expand /tb_RSA/u_RSA/u_PE_config/northin_rd_en
add wave -noupdate /tb_RSA/u_RSA/u_PE_config/cal_en
add wave -noupdate /tb_RSA/u_RSA/u_PE_config/cal_done
add wave -noupdate -expand /tb_RSA/u_RSA/u_PE_config/out_rd_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {360000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 148
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
WaveRestoreZoom {325630 ps} {509178 ps}
