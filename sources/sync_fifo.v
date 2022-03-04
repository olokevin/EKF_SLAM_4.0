//sync fifo without empty and full sign
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

    output  reg  [DATA_LEN-1:0]   data_out

);

    reg [ADDR_WIDTH-1:0] wr_addr ;
    reg [ADDR_WIDTH-1:0] rd_addr ; 

    reg [DATA_LEN-1:0] fifo [0:DEPTH-1] ; // 定义�?个二维的RAM

    //读操�?
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            data_out <= {DATA_LEN{1'b0}};
        end
        case({rd_en,wr_en}) 
            2'b10:  data_out <= fifo[rd_addr]; 
            2'b11: begin
                if(wr_addr == rd_addr)
                    data_out <= data_in;
                else
                    data_out <= fifo[rd_addr]; 
            end
            default: data_out <= {DATA_LEN{1'b0}};
        endcase
    end    
        // else if(rd_en == 1'b1) begin
        //     if(wr_en == 1'b1 && wr_addr == rd_addr)
        //         data_out <= data_in; 
        //     else
        //         data_out <= fifo[rd_addr]; 
        // end

    //写操�?
    integer i_wr_addr;
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            for(i_wr_addr=0; i_wr_addr<DEPTH; i_wr_addr=i_wr_addr+1) begin
                fifo[i_wr_addr] <= {DATA_LEN{1'b0}};
            end
        end
        else if(wr_en)  begin
            fifo[wr_addr] <= data_in;
        end
    end

    //更新读地�?
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            rd_addr <= {ADDR_WIDTH{1'b0}};
        end
        else if(rd_en) begin
            if(rd_addr == DEPTH-1)
                rd_addr <= {ADDR_WIDTH{1'b0}};
            else
                rd_addr <= rd_addr + {{(ADDR_WIDTH-1){1'b0}},{1'b1}};
        end
    end

    //更新写地�?
    always @(posedge clk or negedge sys_rst_n) begin
        if(!sys_rst_n)  begin
            wr_addr <= {ADDR_WIDTH{1'b0}};
        end
        else if(wr_en) begin
            if(wr_addr == DEPTH-1)
                wr_addr <= {ADDR_WIDTH{1'b0}};
            else
                wr_addr <= wr_addr + {{(ADDR_WIDTH-1){1'b0}},{1'b1}};
        end
    end

endmodule