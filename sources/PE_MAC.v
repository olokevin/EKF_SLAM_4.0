module PE_MAC 
#(
    parameter N = 4,
    parameter IN_LEN = 8,
    parameter OUT_LEN = 8
)
(
    input       clk                        ,
    input       sys_rst_n                  ,
    
    input       cal_en                     ,
    input       cal_done                   ,    

    input           [IN_LEN-1:0]  westin,
    input           [IN_LEN-1:0]  northin,

    input                         din_val,
    input           [OUT_LEN-1:0] din,

    output   reg                   n_cal_en,
    output   reg                   n_cal_done,

    output   reg    [IN_LEN-1:0]  eastout,
    output   reg    [IN_LEN-1:0]  southout,
    output   reg                   dout_val,
    output   reg    [OUT_LEN-1:0]  dout
);

    //下一模块的cal_en: n_cal_en
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            n_cal_en <= 0;
        end
        else  begin
            n_cal_en <= cal_en;
        end
    end

    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            n_cal_done <= 0;
        end
        else  begin
            n_cal_done <= cal_done;
        end
    end

    //乘积+求和
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            dout <= 0; 
        end
        else if(cal_en == 1'b1 && cal_done != 1'b1)
            dout <= dout + westin * northin;
        else if(din_val == 1'b1)
            dout <= din;
        else 
            dout <= 0; 
    end

    //dout_val 输出有效
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            dout_val <= 1'b0;
        end
        else if(cal_done == 1'b1 || din_val == 1) begin
            dout_val <= 1'b1;
        end
    end

    //eastout 行数据复用
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            eastout <= 0;
        end
        else if(cal_en == 1'b1) begin
            eastout <= westin;
        end
    end

    //southout 列数据复用
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            southout <= 0;
        end
        else if(cal_en == 1'b1) begin
            southout <= northin;
        end
    end
endmodule