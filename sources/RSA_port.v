module RSA_port 
#(
    parameter X = 3,
    parameter N = 4,
    parameter Y = 3,

    parameter IN_LEN = 8,
    parameter OUT_LEN = 8,
    parameter ADDR_WIDTH = 2
) 
(
    input   clk,
    input   sys_rst_n,

    input   Xin_val,
    input   Yin_val,
    input   out_val,                        //只用一位

    output  reg [X:1]   westin_wr_en,       //e_westin_wr_en[0]为冗余位，初值位1，用于左移
    output  reg [Y:1]   northin_wr_en,
    output  reg [X:1]   out_rd_en
    // output   [X:1]   westin_wr_en,       //e_westin_wr_en[0]为冗余位，初值位1，用于左移
    // output   [Y:1]   northin_wr_en,
    // output   [X:1]   out_rd_en
);
    
    reg [N-1:0] Xin_cnt;
    reg [N-1:0] Yin_cnt;
    reg [Y-1:0] out_cnt;

    reg Xin_val_r;  
    reg Yin_val_r;
    reg out_val_r;

    //延迟一个周期，用于判断上升/下降沿
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            Xin_val_r <= 0;
        else 
            Xin_val_r <= Xin_val;
    end

    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            Yin_val_r <= 0;
        else 
            Yin_val_r <= Yin_val;
    end

    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            out_val_r <= 0;
        else 
            out_val_r <= out_val;
    end

     //Xin 按行写入
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            Xin_cnt <= 0; 
            westin_wr_en <= 0;
        end    
        //Xin上升沿
        else if({Xin_val,Xin_val_r} == 2'b10) begin
            Xin_cnt <= 0; 
            westin_wr_en <= 1'b1;
        end    
        //计数
        else if(Xin_val == 1'b1 && Xin_cnt < N-1)    
            Xin_cnt <= Xin_cnt + 1'b1;
        //移位
        else if(Xin_val == 1'b1 && Xin_cnt == N-1) begin
            Xin_cnt <= 0;
            westin_wr_en <= {westin_wr_en[X-1:1] , westin_wr_en[X]};
        end     
        else begin
            Xin_cnt <= 0; 
            westin_wr_en <= 0;
        end  
    end

    //Yin 按列写入
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            Yin_cnt <= 0; 
            northin_wr_en <= 0;
        end    
        //Yin_val 第一列使能
        else if({Yin_val,Yin_val_r} == 2'b10) begin
            Yin_cnt <= 0; 
            northin_wr_en <= 1'b1;
        end    
        //计数
        else if(Yin_val == 1'b1 && Yin_cnt < N*Y) begin
            Yin_cnt <= Yin_cnt + 1'b1;
            northin_wr_en <= {northin_wr_en[Y-1:1] , northin_wr_en[Y]};
        end     
        else begin
            Yin_cnt <= 0; 
            northin_wr_en <= 0;
        end  
    end

    //out
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            out_cnt <= 0; 
            out_rd_en <= 0;
        end    
        //Yin
        else if({out_val,out_val_r} == 2'b10) begin
            out_cnt <= 0; 
            out_rd_en <= 1'b1;
        end    
        //计数
        else if(out_val == 1'b1 && out_cnt < Y-1)    
            out_cnt <= out_cnt + 1'b1;
        else if(out_val == 1'b1 && out_cnt == Y-1) begin
            out_cnt <= 0;
            out_rd_en <= {out_rd_en[X-1:1] , out_rd_en[X]};
        end     
        else begin
            out_cnt <= 0; 
            out_rd_en <= 0;
        end  
    end

    // always @(posedge clk or negedge sys_rst_n) begin
    //     if(!sys_rst_n) begin
    //         Xin_cnt <= 0; 
    //         e_westin_wr_en <= 1'b1;
    //     end    
    //     else if(Xin_val == 1'b1 && Xin_cnt < N)    
    //         Xin_cnt <= Xin_cnt + 1'b1;
    //     else if(Xin_val == 1'b1 && Xin_cnt == N) begin
    //         Xin_cnt <= 0;
    //         e_westin_wr_en <= {e_westin_wr_en[X-1:0] , e_westin_wr_en[X]};
    //     end     
    //     else begin
    //         Xin_cnt <= 0; 
    //         e_westin_wr_en <= 1'b1;
    //     end  
    // end
    

endmodule