module PE_config 
#(
    parameter X = 3,
    parameter N = 3,
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
    // input   out_val,                        //只用一位

    //input->in_fifo
    output  reg [X:1]   westin_wr_en,       //e_westin_wr_en[0]为冗余位，初值位1，用于左移
    output  reg [Y:1]   northin_wr_en,
    //in_fifo->PEs
    output  reg [X:1]     westin_rd_en,  //输入，与N有关 westin和northin都是存N个数据
    output  reg [Y:1]     northin_rd_en,
    //PE calculation enable
    output  reg         cal_en,
    output  reg         cal_done,   
    // output           cal_en,
    // output           cal_done, 
    //out_fifo->output
    output  reg [X:1]   out_rd_en
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

    // always @(posedge clk or negedge sys_rst_n) begin
    //     if(!sys_rst_n)
    //         out_val_r <= 0;
    //     else 
    //         out_val_r <= out_val;
    // end

     //Xin 按行写入
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            Xin_cnt <= 0; 
            westin_wr_en <= 0;
        end    
        //Xin上升沿，即使能westin_fifo[1]
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

//westin.rd_en
    reg [N*(X-1):1]   westin_delay_en_delay;
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            westin_delay_en_delay <= 0;
        else 
            westin_delay_en_delay <= {westin_delay_en_delay[N*(X-1)-1:1],Xin_val};
    end

    reg westin_delay_en;    //生成第一个westin_rd_en
    reg westin_delay_X_en;  //生成2~X后续westin_rd_en
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            westin_delay_en <= 0;
        else begin
            westin_delay_en <= Xin_val | westin_delay_en_delay[N*(X-1)];
            westin_delay_X_en <= Xin_val | westin_delay_en_delay[N];
        end   
    end

    reg [N*(X-1):1]  westin_rd_en_delay;
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            westin_rd_en_delay <= 0;
        // else
        //     westin_rd_en_delay <= {westin_rd_en_delay[N*(X-1)-1:1],westin_wr_en[1]};
        else if(westin_delay_X_en == 1'b1)
            westin_rd_en_delay <= {westin_rd_en_delay[N*(X-1)-1:1],westin_wr_en[1]};
        else
            westin_rd_en_delay <= 0;
    end

    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            westin_rd_en <= 0;
        // else
        //     westin_rd_en <= {westin_rd_en[X-1:1],westin_rd_en_delay[N*(X-1)]};
        else if(westin_delay_en == 1'b1) begin
            westin_rd_en <= {westin_rd_en[X-1:1],westin_rd_en_delay[N*(X-1)]};
        end
        else
            westin_rd_en <= 0;
    end

//northin.rd_en
    reg [N:1]   northin_delay_en_delay;
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            northin_delay_en_delay <= 0;
        else 
            northin_delay_en_delay <= {northin_delay_en_delay[N-1:1],Yin_val};
    end

    reg northin_delay_en;
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            northin_delay_en <= 0;
        else 
            northin_delay_en <= Yin_val | northin_delay_en_delay[N];
    end

    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            northin_rd_en <= 0;
        // else
        //     northin_rd_en <= {northin_rd_en[Y-1:1],westin_rd_en_delay[N*(X-1)]};
        else if(westin_delay_en == 1'b1) begin
            northin_rd_en <= {northin_rd_en[Y-1:1],westin_rd_en_delay[N*(X-1)]};
        end
        else   
            northin_rd_en <= 0;
    end

    //cal_en
    // assign cal_en = westin_rd_en[2];
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n) begin
            cal_en <= 0;
        end
        else begin
            cal_en <= westin_rd_en[1];
        end            
    end

    //cal_done
    // assign cal_done = ({westin_rd_en[3],westin_rd_en[2]} == 2'b10) ? 1'b1 : 1'b0;
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            cal_done <= 1'b0;
        else if({cal_en,westin_rd_en[1]} == 2'b10)
            cal_done <= 1'b1;
        else
            cal_done <= 1'b0;
    end

    //out
    reg [(3*N-3):1] cal_delay;
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            cal_delay <= 0;
        else begin
            cal_delay <= {cal_delay[(3*N-3):1],westin_rd_en[1]};
        end   
    end

    //out_rd_en[1]总计3N-2级延迟
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            out_rd_en[1] <= 1'b0;
        else      
            out_rd_en[1] <= cal_delay[3*N-3];  
    end

    genvar i_delay;
    generate
        for(i_delay=2; i_delay<=X; i_delay=i_delay+1) begin:out_rd_en_gen
            reg [N-1:1] out_rd_en_delay;
            always @(posedge clk or negedge sys_rst_n) begin
                if(!sys_rst_n)
                    out_rd_en_delay <= 0;
                else begin
                    out_rd_en_delay <= {out_rd_en_delay[N-2:1],out_rd_en[i_delay-1]};
                end     
            end

            always @(posedge clk or negedge sys_rst_n) begin
                if(!sys_rst_n)
                    out_rd_en[i_delay] <= 0;
                else begin
                    out_rd_en[i_delay] <= out_rd_en_delay[N-1];
                end
            end
        end
    endgenerate
    
//using outside out_rdy
    // always @(posedge clk or negedge sys_rst_n) begin
    //     if(!sys_rst_n) begin
    //         out_cnt <= 0; 
    //         out_rd_en <= 0;
    //     end    
    //     //Yin
    //     else if({out_val,out_val_r} == 2'b10) begin
    //         out_cnt <= 0; 
    //         out_rd_en <= 1'b1;
    //     end    
    //     //计数
    //     else if(out_val == 1'b1 && out_cnt < Y-1)    
    //         out_cnt <= out_cnt + 1'b1;
    //     else if(out_val == 1'b1 && out_cnt == Y-1) begin
    //         out_cnt <= 0;
    //         out_rd_en <= {out_rd_en[X-1:1] , out_rd_en[X]};
    //     end     
    //     else begin
    //         out_cnt <= 0; 
    //         out_rd_en <= 0;
    //     end  
    // end
    

endmodule