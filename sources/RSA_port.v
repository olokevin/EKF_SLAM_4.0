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
);
    
    reg [N-1:0] Xin_cnt;
    reg [N-1:0] Yin_cnt;
    reg [Y-1:0] out_cnt;

    reg [X:0]   e_westin_wr_en;       //e_westin_wr_en[0]为冗余位，初值位1，用于左移
    reg [Y:0]   e_northin_wr_en;
    reg [X:0]   e_out_rd_en;

always @(posedge clk or negedge sys_rst_n) begin
    if(!sys_rst_n)  begin
        westin_wr_en <= 0;
        northin_wr_en <= 0;
        out_rd_en <= 0;
    end
    else begin
        westin_wr_en <= e_westin_wr_en[X:1];
        northin_wr_en <= e_northin_wr_en[Y:1];
        out_rd_en <= e_out_rd_en[X:1];
    end
        
end

     //计数器
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            Xin_cnt <= 0; 
            e_westin_wr_en <= 1'b1;
        end    
        else if(Xin_val == 1'b1 && Xin_cnt != N)    
            Xin_cnt <= Xin_cnt + 1'b1;
        else if(Xin_val == 1'b1 && Xin_cnt == N) begin
            Xin_cnt <= 0;
            e_westin_wr_en <= {e_westin_wr_en[X-1:0] , e_westin_wr_en[X]};
        end       
    end

    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            Yin_cnt <= 0; 
            e_northin_wr_en <= 1'b1;
        end    
        else if(Yin_val == 1'b1 && Yin_cnt != N)    
            Yin_cnt <= Yin_cnt + 1'b1;
        else if(Yin_val == 1'b1 && Yin_cnt == N) begin
            Yin_cnt <= 0;
            e_northin_wr_en <= {e_northin_wr_en[Y-1:0] , e_northin_wr_en[Y]};
        end       
    end

    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            out_cnt <= 0;
            e_out_rd_en <= 1'b1;
        end
        else if(out_val == 1 && out_cnt != Y) begin
            out_cnt <= out_cnt + 1;
        end
        else if(out_val == 1 && out_cnt == Y) begin
            out_cnt <= 0;
            e_out_rd_en <= {e_out_rd_en[X-1:0] , e_out_rd_en[X]};
        end
        else if(e_out_rd_en[0] != 1 && out_cnt != Y) begin
            out_cnt <= out_cnt + 1;
        end    
        else if(e_out_rd_en[0] != 1 && out_cnt == Y) begin
            out_cnt <= 0;
            e_out_rd_en <= {e_out_rd_en[X-1:0] , e_out_rd_en[X]};
        end
    end

endmodule