`timescale 1ns/1ns    //?????? ·timescale <????>/<????>
module BCD_tb;        //BCD_TB?BCD_tb?BCD_TB1 ??????
  reg [3:0]addend1,addend2;   //?????????reg?
  wire [3:0]sum;
  wire C;                     //???????wire?
  
  parameter DELAY = 100;      //
  integer i,j;
  
  BCD U1( .A(addend1),
          .B(addend2),
          .Cout(C),
          .Sum(sum)
          );    // BCD UI?addend1,addend2,sum,C);  ?????????????
                //??????
          
  initial       //???????????
  begin
    addend1 = 0;  
    addend2 = 0;
    for(i = 0;i < 10;i = i + 1)
    for(j = 0;j < 10;j = j + 1)
    begin
      #DELAY addend1 = i;
             addend2 = j;
    end
  end
  
  initial
  $monitor($time,,,"%d + %d = %d , carry = %d ",addend1,addend2,sum,C);
  //??????
  //$monitor("??????,????????;   
  /* ===>????????????????????????????
   ?????????????transcript???wave?????? */
 
endmodule
 
