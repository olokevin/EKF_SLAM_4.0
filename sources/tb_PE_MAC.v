`timescale  1ns/1ps

module tb_PE_MAC;

// PE_MAC Parameters
parameter PERIOD   = 10;
parameter N        = 3;
parameter IN_LEN   = 8;
parameter OUT_LEN  = 8;

// PE_MAC Inputs
reg   clk                                  = 1 ;
reg   sys_rst_n = 0;
reg   cal_en                               = 0 ;
reg   cal_done                             = 0 ;
reg   [IN_LEN-1:0]  westin                 = 0 ;
reg   [IN_LEN-1:0]  northin                = 0 ;
reg   din_val                              = 0 ;
reg   [OUT_LEN-1:0]  din                   = 0 ;

// PE_MAC Outputs
wire  n_cal_en                             ;
wire  n_cal_done                           ;
wire  [OUT_LEN-1:0]  eastout               ;
wire  [OUT_LEN-1:0]  southout              ;
wire  dout_val                             ;
wire  [OUT_LEN-1:0]  dout                  ;

//CLK
initial
begin
    
    forever #(PERIOD/2)  clk=~clk;
end

//sys_rst_n 延迟两个周期后置1
initial
begin
    #(PERIOD*2) sys_rst_n  =  1;
end

//cal_en
initial
begin
    #(PERIOD*4) cal_en  <=  1;
    #(PERIOD*3) cal_en  <=  0;
end

//cal_done
initial
begin
    #(PERIOD*7) cal_done <= 1;
    #(PERIOD)   cal_done <= 0;
end

//westin
initial begin
    #(PERIOD*4) westin <= 2;
    #PERIOD     westin <= 3;
    #PERIOD     westin <= 4;
    #PERIOD     westin <= 1;
end

//northin
initial begin
    #(PERIOD*4) northin <= 2;
    #PERIOD     northin <= 3;
    #PERIOD     northin <= 4;
    #PERIOD     northin <= 1;
end

//din_val
initial begin
    #(PERIOD*9) din_val <= 1;
    #PERIOD     din_val <= 0;
end

//din
initial begin
   #(PERIOD*9)  din <= 10;
   #PERIOD      din <= 1; 
end

PE_MAC #(
    .N       ( N       ),
    .IN_LEN  ( IN_LEN  ),
    .OUT_LEN ( OUT_LEN ))
 u_PE_MAC (
    .clk                     ( clk                       ),
    .sys_rst_n               ( sys_rst_n                 ),
    .cal_en                  ( cal_en                    ),
    .cal_done                ( cal_done                  ),
    .westin                  ( westin      [IN_LEN-1:0]  ),
    .northin                 ( northin     [IN_LEN-1:0]  ),
    .din_val                 ( din_val                   ),
    .din                     ( din         [OUT_LEN-1:0] ),

    .n_cal_en                ( n_cal_en                  ),
    .n_cal_done              ( n_cal_done                ),
    .eastout                 ( eastout     [OUT_LEN-1:0] ),
    .southout                ( southout    [OUT_LEN-1:0] ),
    .dout_val                ( dout_val                  ),
    .dout                    ( dout        [OUT_LEN-1:0] )
);

initial
begin
    $timeformat(-9, 0, "ns", 6);
    $monitor("@time %t: dout_val=%b dout=%b eastout=%b southout=%b",
    $time, dout_val, dout, eastout, southout);
    $stop;
end

endmodule