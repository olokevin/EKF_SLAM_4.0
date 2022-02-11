module RSA 
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

    input   SA_start,      //阵列启动信号

    input               Xin_val,
    input [IN_LEN:1]    Xin_data,
    input               Yin_val,
    input [IN_LEN:1]    Yin_data,

    // output              out_val,
    output [OUT_LEN:1]  out_data

);

//互连信号线
wire [X:1]  westin_wr_en;     
wire [X+1:1]  westin_rd_en;
wire [Y:1]  northin_wr_en;
wire [Y+1:1]  northin_rd_en;
wire [X:1]  out_rd_en;


wire    [(X-1)*Y:0]           n_cal_en;         //由于输出可能接到模块，故将输出的坐标与PE坐标绑定，输入与来源的PE坐标绑定
wire    [(X-1)*Y:0]           n_cal_done;       //n_cal_en[0]接到(1,1)的PE 其余与PE坐标一致

wire    [X*IN_LEN*Y:1]    westin;
wire    [Y*IN_LEN*X:1]    northin;

wire    [X*Y:1]           dout_val;
wire    [X*OUT_LEN*Y:1]   dout;

//输入数据buffer
reg [IN_LEN:1]    Xin_buffer;
reg [IN_LEN:1]    Yin_buffer;
always @(posedge clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        Xin_buffer <= 0;
    else 
        Xin_buffer <= Xin_data;
end

always @(posedge clk or negedge sys_rst_n) begin
    if(!sys_rst_n)
        Yin_buffer <= 0;
    else 
        Yin_buffer <= Yin_data;
end

PE_config 
#(
    .X (X ),
    .N (N ),
    .Y (Y )
)
u_PE_config(
    .clk       (clk       ),
    .sys_rst_n (sys_rst_n ),
    .SA_start  (SA_start  ),
    .cal_en    (n_cal_en[0]    ),
    .cal_done  (n_cal_done[0]  ),
    // .in_wr_en  (in_wr_en),
    .westin_rd_en  (westin_rd_en[1] ),
    .northin_rd_en (northin_rd_en[1])
);

RSA_port 
#(
    .X          (X          ),
    .N          (N          ),
    .Y          (Y          ),
    .IN_LEN     (IN_LEN     ),
    .OUT_LEN    (OUT_LEN    ),
    .ADDR_WIDTH (ADDR_WIDTH )
)
u_RSA_port(
    .clk           (clk           ),
    .sys_rst_n     (sys_rst_n     ),
    .Xin_val       (Xin_val       ),
    .Yin_val       (Yin_val       ),
    .out_val       (dout_val[(X-1)*Y+1]       ),
    .westin_wr_en  (westin_wr_en[1]  ),
    .northin_wr_en (northin_wr_en[1] ),
    .out_rd_en     (out_rd_en[1]     )
);

//X输入fifo
genvar  i;
genvar  j;
generate
    for(i = 1; i <= X; i=i+1) begin: in_fifo_X
        sync_fifo 
        #(
            .DATA_LEN   (IN_LEN   ),
            .DEPTH      (N      ),
            .ADDR_WIDTH (ADDR_WIDTH )
        )
        u_sync_fifo(
        	.clk       (clk       ),
            .sys_rst_n (sys_rst_n ),
            .wr_en     (westin_wr_en[i]     ),
            .rd_en     (westin_rd_en[i]     ),
            .data_in   (Xin_buffer   ),
            .data_out  (westin[IN_LEN*((i-1)*Y+1):IN_LEN*((i-1)*Y)+1]  ),   //j=1
            .n_rd_en   (westin_rd_en[i+1]   ),
            .empty     (     ),
            .full      (     )
        );
        
    end
endgenerate

//Yin northin FIFO
generate
    for(j = 1; j <= Y; j=j+1) begin:in_fifo_Y
        sync_fifo 
        #(
            .DATA_LEN   (IN_LEN   ),
            .DEPTH      (N      ),
            .ADDR_WIDTH (ADDR_WIDTH )
        )
        u_sync_fifo(
        	.clk       (clk       ),
            .sys_rst_n (sys_rst_n ),
            .wr_en     (northin_wr_en[j]     ),
            .rd_en     (northin_rd_en[j]     ),
            .data_in   (Yin_data   ),
            .data_out  (northin[IN_LEN*j:IN_LEN*(j-1)+1]  ),  //i=1
            .n_rd_en   (northin_rd_en[j+1]   ),
            .empty     (     ),
            .full      (      )
        );
        
    end

endgenerate

//out_fifo 接在最左一行 j=1
generate
    for(i=1; i<=X; i=i+1) begin:out_fifo
       sync_fifo 
        #(
            .DATA_LEN   (OUT_LEN   ),
            .DEPTH      (N      ),
            .ADDR_WIDTH (ADDR_WIDTH )
        )
        u_sync_fifo(
        	.clk       (clk       ),
            .sys_rst_n (sys_rst_n ),
            .wr_en     (dout_val[(i-1)*Y+1]    ),
            .rd_en     (out_rd_en[i]     ),
            .data_in   (dout[ OUT_LEN*((i-1)*Y+1) : OUT_LEN*((i-1)*Y) + 1 ]   ),
            .data_out  (out_data  ),  //i=1
            .n_rd_en   (  ),          //输出的读出使能直接由RSA_port控制
            .empty     (     ),
            .full      (      )
        );
         
    end
endgenerate 

generate
    for(i=1; i<=X; i=i+1) begin:PE_MAC_X
        for(j=1; j<=Y; j=j+1) begin:PE_MAC_Y
        //第(i,j)个PE data：[ LEN*((i-1)*Y+j) : LEN*((i-1)*Y+j-1) + 1 ]
        //第(i,j)个PE sig:  [(i-1)*Y+j]
            //第一行 cal_en cal_done
            //第一列的cal_en cal_done来自该列上一列 j-1
            if(i==1) begin
                PE_MAC 
                #(
                    .N       (N       ),
                    .IN_LEN  (IN_LEN  ),
                    .OUT_LEN (OUT_LEN )
                )
                u_PE_MAC(
                    .clk        (clk        ),
                    .sys_rst_n  (sys_rst_n  ),
                    .cal_en     (n_cal_en[j-1]     ),  //第一列的cal_en cal_done来自该列上一列 j-1
                    .cal_done   (n_cal_done[j-1]   ),
                    .westin     (westin[IN_LEN*((i-1)*Y+j) : IN_LEN*((i-1)*Y+j-1)+1]     ),
                    .northin    (northin[IN_LEN*((i-1)*Y+j) : IN_LEN*((i-1)*Y+j-1)+1]    ),
                    .din_val    (dout_val[(i-1)*Y+j+1]    ),
                    .din        (dout[OUT_LEN*((i-1)*Y+j+1) : OUT_LEN*((i-1)*Y+j)+1]        ),
                    .n_cal_en   (n_cal_en[(i-1)*Y+j]   ),
                    .n_cal_done (n_cal_done[(i-1)*Y+j] ),
                    .eastout    (westin[IN_LEN*((i-1)*Y+j+1) : IN_LEN*((i-1)*Y+j)+1]    ),
                    .southout   (northin[IN_LEN*(i*Y+j) : IN_LEN*(i*Y+j-1)+1]   ),
                    .dout_val   (dout_val[(i-1)*Y+j]   ),  
                    .dout       (dout[OUT_LEN*((i-1)*Y+j) : OUT_LEN*((i-1)*Y+j-1)+1]       )
                );
            end
            //中间部分
            else if(i>1 && i<X && j<Y) begin
                PE_MAC 
                #(
                    .N       (N       ),
                    .IN_LEN  (IN_LEN  ),
                    .OUT_LEN (OUT_LEN )
                )
                u_PE_MAC(
                    .clk        (clk        ),
                    .sys_rst_n  (sys_rst_n  ),
                    .cal_en     (n_cal_en[(i-2)*Y+j]     ),  //cal_en cal_done来自上一行
                    .cal_done   (n_cal_done[(i-2)*Y+j]   ),
                    .westin     (westin[IN_LEN*((i-1)*Y+j) : IN_LEN*((i-1)*Y+j-1)+1]     ),  //westin，northin，按PE模块位置设置
                    .northin    (northin[IN_LEN*((i-1)*Y+j) : IN_LEN*((i-1)*Y+j-1)+1]    ),
                    .din_val    (dout_val[(i-1)*Y+j+1]    ),    //din来自右边 j+1
                    .din        (dout[OUT_LEN*((i-1)*Y+j+1) : OUT_LEN*((i-1)*Y+j)+1]        ),
                    .n_cal_en   (n_cal_en[(i-1)*Y+j]   ),       //n_cal_en传到下方
                    .n_cal_done (n_cal_done[(i-1)*Y+j] ),
                    .eastout    (westin[IN_LEN*((i-1)*Y+j+1) : IN_LEN*((i-1)*Y+j)+1]    ),  //eastout传到右边 j+1
                    .southout   (northin[IN_LEN*(i*Y+j) : IN_LEN*(i*Y+j-1)+1]   ),   //southout传到下边 i+1
                    .dout_val   (dout_val[(i-1)*Y+j]   ),  //dout连线标号按位置给定
                    .dout       (dout[OUT_LEN*((i-1)*Y+j) : OUT_LEN*((i-1)*Y+j-1)+1]       )
                );
            end
            //最后一行，没有southout, n_cal_en, n_cal_done
            else if(i==X && j!=Y) begin
                PE_MAC 
                #(
                    .N       (N       ),
                    .IN_LEN  (IN_LEN  ),
                    .OUT_LEN (OUT_LEN )
                )
                u_PE_MAC(
                    .clk        (clk        ),
                    .sys_rst_n  (sys_rst_n  ),
                    .cal_en     (n_cal_en[(i-2)*Y+j]     ),  //cal_en cal_done来自上方的
                    .cal_done   (n_cal_done[(i-2)*Y+j]   ),
                    .westin     (westin[IN_LEN*((i-1)*Y+j) : IN_LEN*((i-1)*Y+j-1)+1]     ),  //westin，northin，按PE模块位置设置
                    .northin    (northin[IN_LEN*((i-1)*Y+j) : IN_LEN*((i-1)*Y+j-1)+1]    ),
                    .din_val    (dout_val[(i-1)*Y+j+1]    ),    //din来自右边 j+1
                    .din        (dout[OUT_LEN*((i-1)*Y+j+1) : OUT_LEN*((i-1)*Y+j)+1]        ),
                    .n_cal_en   (   ),       //最后一行，无n_cal_en
                    .n_cal_done (  ),
                    .eastout    (westin[IN_LEN*((i-1)*Y+j+1) : IN_LEN*((i-1)*Y+j)+1]    ),  //eastout传到右边 j+1
                    .southout   (   ),   //southout传到下边 i+1
                    .dout_val   (dout_val[(i-1)*Y+j]   ),  //dout连线标号按位置给定
                    .dout       (dout[OUT_LEN*((i-1)*Y+j) : OUT_LEN*((i-1)*Y+j-1)+1]       )
                );
            end
            //最右一列，没有eastout，没有din
            else if(i!=X && j==Y) begin
                PE_MAC 
                #(
                    .N       (N       ),
                    .IN_LEN  (IN_LEN  ),
                    .OUT_LEN (OUT_LEN )
                )
                u_PE_MAC(
                    .clk        (clk        ),
                    .sys_rst_n  (sys_rst_n  ),
                    .cal_en     (n_cal_en[(i-2)*Y+j]     ),  //cal_en cal_done来自上一行
                    .cal_done   (n_cal_done[(i-2)*Y+j]   ),
                    .westin     (westin[IN_LEN*((i-1)*Y+j) : IN_LEN*((i-1)*Y+j-1)+1]     ),  //westin，northin，按PE模块位置设置
                    .northin    (northin[IN_LEN*((i-1)*Y+j) : IN_LEN*((i-1)*Y+j-1)+1]    ),
                    .din_val    (0    ),    
                    .din        (0   ),
                    .n_cal_en   (n_cal_en[(i-1)*Y+j]   ),       
                    .n_cal_done (n_cal_done[(i-1)*Y+j] ),
                    .eastout    (    ),  //eastout传到右边 j+1
                    .southout   (northin[IN_LEN*(i*Y+j) : IN_LEN*(i*Y+j-1)+1]   ),   //southout传到下边 i+1
                    .dout_val   (dout_val[(i-1)*Y+j]   ),  //dout连线标号按位置给定
                    .dout       (dout[OUT_LEN*((i-1)*Y+j) : OUT_LEN*((i-1)*Y+j-1)+1]       )
                );
            end
            //右下角
            else if(i==X && j==Y) begin
                PE_MAC 
                #(
                    .N       (N       ),
                    .IN_LEN  (IN_LEN  ),
                    .OUT_LEN (OUT_LEN )
                )
                u_PE_MAC(
                    .clk        (clk        ),
                    .sys_rst_n  (sys_rst_n  ),
                    .cal_en     (n_cal_en[(i-2)*Y+j]     ),  //cal_en cal_done来自上一行
                    .cal_done   (n_cal_done[(i-2)*Y+j]   ),
                    .westin     (westin[IN_LEN*((i-1)*Y+j) : IN_LEN*((i-1)*Y+j-1)+1]     ),  //westin，northin，按PE模块位置设置
                    .northin    (northin[IN_LEN*((i-1)*Y+j) : IN_LEN*((i-1)*Y+j-1)+1]    ),
                    .din_val    (0    ),    
                    .din        (0   ),
                    .n_cal_en   (   ),       
                    .n_cal_done ( ),
                    .eastout    (    ),  //eastout传到右边 j+1
                    .southout   (   ),   //southout传到下边 i+1
                    .dout_val   (dout_val[(i-1)*Y+j]   ),  //dout连线标号按位置给定
                    .dout       (dout[OUT_LEN*((i-1)*Y+j) : OUT_LEN*((i-1)*Y+j-1)+1]       )
                );
            end
            
        end
    end
endgenerate

    
endmodule