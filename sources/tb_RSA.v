`timescale 1ns/1ps

module tb_RSA;

// RSA Parameters
parameter PERIOD      = 10;
parameter M           = 7;
parameter X           = 3;
parameter N           = 3;
parameter Y           = 3;
parameter IN_LEN      = 4;
parameter OUT_LEN     = 8;
parameter ADDR_WIDTH  = 2;

// RSA Inputs
reg   clk                                  = 1 ;
reg   sys_rst_n                            = 0 ;
// reg   SA_start                             = 0 ;
reg   Xin_val                              = 0 ;
reg   [IN_LEN:1]  Xin_data                 = 0 ;
reg   Yin_val                              = 0 ;
reg   [IN_LEN:1]  Yin_data                 = 0 ;

// RSA Outputs
wire    out_val;
wire  [OUT_LEN:1]  out_data                ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) sys_rst_n  =  1;
end

initial begin
    #(PERIOD*3) Xin_val <= 1;
    #(PERIOD*(M*N)) Xin_val <= 0;
end

initial begin
    #(PERIOD*3) Yin_val <= 1;
    #(PERIOD*(Y*N)) Yin_val <= 0;
end

//读取文件
integer  Xin_fd, Xin_err, i, code;
reg [320:0] Xin_str;
initial begin
    Xin_fd = $fopen("data/Xin_data.HEX", "r");
    Xin_err = $ferror(Xin_fd, Xin_str);
end

//输出
initial begin
    #(PERIOD*3) ;
    if(!Xin_err) begin
        for(i=0; i<M*N; i=i+1) begin
            @(posedge clk);         //在每个时钟上升沿读取数据
            code = $fscanf(Xin_fd,"%h",Xin_data);
            $display("Xin_data%d: %h", i, Xin_data) ;
        end
    end
end

//读取文件
integer  Yin_fd, Yin_err, j;
reg [320:0] Yin_str;
initial begin
    Yin_fd = $fopen("data/Yin_data.HEX", "r");
    Yin_err = $ferror(Yin_fd, Yin_str);
end

//输出
initial begin
    #(PERIOD*3) ;
    if(!Yin_err) begin
        for(j=0; j<Y*N; j=j+1) begin
            @(posedge clk);     //在每个时钟上升沿读取数据
            code = $fscanf(Yin_fd,"%h",Yin_data);
            $display("Yin_data%d: %h", j, Yin_data) ;
        end
    end
end

// //SA_start
// initial begin
//     #(PERIOD*(2+3+2+Y*N)) SA_start <= 1;
//     #PERIOD SA_start <= 0;
// end

//读取结果
//SA_start后3+N+(X-1)+2*(Y-1)+1 全部结果存于FIFO中
// initial begin
//     // #(PERIOD*(2+3+Y*N + 3+N+(X-1)+2*(Y-1)+1)) ;
//     #(PERIOD*40) out_rdy <= 1;
//     #(PERIOD*X*Y) out_rdy <= 0; 
// end

RSA #(
    .X          ( X          ),
    .N          ( N          ),
    .Y          ( Y          ),
    .IN_LEN     ( IN_LEN     ),
    .OUT_LEN    ( OUT_LEN    ),
    .ADDR_WIDTH ( ADDR_WIDTH ))
 u_RSA (
    .clk                     ( clk                    ),
    .sys_rst_n               ( sys_rst_n              ),
    // .SA_start                ( SA_start               ),
    .Xin_val                 ( Xin_val                ),
    .Xin_data                ( Xin_data   [IN_LEN:1]  ),
    .Yin_val                 ( Yin_val                ),
    .Yin_data                ( Yin_data   [IN_LEN:1]  ),
    .out_val                 ( out_val                ),
    .out_data                ( out_data   [OUT_LEN:1] )
);

endmodule
