module sync_fifo
#(
    parameter DATA_LEN = 8,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = 3        //2^ADDR_WIDTH >=     
) 
(
    input   clk                           ,
    input   sys_rst_n                     ,
    input   wr_en                         ,
    input   rd_en                         ,
    input        [DATA_LEN-1:0]   data_in      ,

    output  reg  [DATA_LEN-1:0]   data_out,
    output  reg     n_rd_en               ,
    output  reg     empty                 ,
    output  reg     full

);

    reg [ADDR_WIDTH-1:0] wr_addr ;
    reg [ADDR_WIDTH-1:0] rd_addr ; 
    reg [ADDR_WIDTH:0] count ;
    reg [DATA_LEN-1:0] fifo [0:DEPTH-1] ; // 定义一个二维的RAM

    //n_rd_en
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            n_rd_en <= 0;
        else 
            n_rd_en <= rd_en;
    end

    //读操作
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            data_out <= 0;
        end
        else if(rd_en && empty == 0)begin
            data_out <= fifo[rd_addr]; 
        end
    end

    //写操作
    always @(posedge clk or negedge sys_rst_n) begin
        if(wr_en && full == 0)  begin
            fifo[wr_addr] <= data_in;
        end
    end

    //更新读地址
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            rd_addr <= 0;
        end
        else if(rd_en && empty == 0) begin
            rd_addr <= rd_addr + 1;
        end
    end

    //更新写地址
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            wr_addr <= 0;
        end
        else if(wr_en && full == 0) begin
            wr_addr <= wr_addr + 1;
        end
    end

    //更新标志位
    /*每个时钟周期
        wr_en   rd_en   cnt
        0       0       不变
        0       1       cnt-1
        1       0       cnt+1
        1       1       不变

        cnt==0        ->  empty = 1
        cnt==DEPTH-1  ->  full = 1

        cnt==1 {01} cnt==0 -> empty==1
        cnt==0

        cnt==DEPTH-2 {10} ->  full==1
    */
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            count <= 0;
        end
        else  begin
            case({wr_en,rd_en})
                2'b00: begin
                    count <= count;
                    empty <= 0;
                    full <= 0;
                end
                2'b01: begin
                    if(count > 1) begin
                        count <= count-1;
                        empty <= 0;
                        full <= 0;
                    end
                    else if(count <= 1) begin
                        count <= 0;
                        empty <= 1;
                        full <= 0;
                    end
                end
                2'b10: begin
                    if(count < DEPTH-2) begin
                        count <= count+1;
                        full <= 0;
                        empty <= 0;
                    end
                    else if(count >+ DEPTH-2) begin
                        count <= DEPTH-1;
                        full <= 1;
                        empty <= 0;
                    end
                end
                2'b11:  begin
                    count<=count;
                    empty <= 0;
                    full <= 0;
                end
            endcase
        end
    end

    //产生full empty信号
    // always @(posedge clk or negedge sys_rst_n) begin
    //     if(!sys_rst_n)  begin
    //         full <= 0;
    //     end
    //     else  begin
    //         if(count==DEPTH-1)
    //             full <= 1;
    //         else
    //             full <= 0;
    //     end
    // end
    // always @(posedge clk or negedge sys_rst_n) begin
    //     if(!sys_rst_n)  begin
    //         empty <= 0;
    //     end
    //     else  begin
    //         if(count==0)
    //             empty <= 1;
    //         else
    //             empty <= 0;
    //     end
    // end
endmodule