# PE模块开发

## RSA设计

### PE_port

#### 输入

三态门

#### 输出

三态门（完成）

何时开始输出？

### PE_config

SA_start: 未自动化

3*3 

以cal_en拉高为起点

* 计算：N+1个时钟，得到输出
* 输出：以求和完成为起点，2N-1个时钟得到输出

所以，每一块为3*3是很合理的，上一批在输出时，这一批在计算



取消config

* westin->eastout
* northin->southout
* din->dout: 输出横向传递
* n_cal_en->cal_en, cal_done: 第一行横向传递，对每一列，纵向传递



特殊情况

* (1,1)：cal_en，cal_done

## 开发流程

使用

* 画逻辑框图
* 画波形图(visio)，根据波形图分析逻辑的正确性
* 参照波形图，编写verilog代码
* modelsim仿真，比照波形



## syncFIFO

参考正点原子逻辑设计参考手册

## VSCode编写Verilog

脚本，插件，https://blog.csdn.net/larpland/article/details/101349586

注意需安装chardet

* pip换源
* anaconda虚拟环境，需要在anaconda prompt内运行python文件



## Modelsim

* 安装，破解
* 先创建Library -- work
* 创建Project
  * 引用文件。这样修改文件可同步到modelsim中
  * modelsim文件夹中只是引用，移出project不会删除文件
* 一些操作
  * restart：可以重新开始
  * run：在现有波形后再仿真一轮
  * 修改程序后，编译相应程序，然后在仿真页面restart，选择reload，不必重新打开
* 快捷键：

## 资源

* 布线资源 or 触发器资源？ (cal_en的处理)
* 由于输出可能接到模块，故将输出的坐标与PE坐标绑定，输入与来源的PE坐标绑定
* 

220209

* cal_en cal_done传递路线与
* 未完成顶层模块的testbench
* 未仿真fifo，config

220210

* fifo需要分west和north
* 增加fifo读取的接口
* 带参数串转并：寄存器型变量reg驱动输入
* 直接输出：![image-20220210193635858](C:\Users\KevinZ\AppData\Roaming\Typora\typora-user-images\image-20220210193635858.png)
* 已经设置了fifo了，只需通过使能信号即可控制是否读取数据。输入信号可以接到一起
* 左移！从1号wr_en到2号wr_en

220212

* 相对路径问题[Verilog include 使用相对路径 - 米兰de小铁匠 - 博客园 (cnblogs.com)](https://www.cnblogs.com/undermyownmoon/p/10442780.html)
  * 需要在与modelsim仿真工程work文件夹同级创建一个data文件夹，存放数据文件

```verilog
fd = $fopen("data/DATA.HEX");
```



* 计算正确，din过早出现，怀疑是连线问题

220213

赋0 仍出现不定态

<img src="C:\Users\KevinZ\AppData\Roaming\Typora\typora-user-images\image-20220213173815129.png" alt="image-20220213173815129" style="zoom:50%;" />

![image-20220213173750854](C:\Users\KevinZ\AppData\Roaming\Typora\typora-user-images\image-20220213173750854.png)

而(X,Y)的PE没有出现问题

发现是(1,Y)的din_val没有接到din_val_gnd

![image-20220213183305472](C:\Users\KevinZ\AppData\Roaming\Typora\typora-user-images\image-20220213183305472.png)

![image-20220213183247492](C:\Users\KevinZ\AppData\Roaming\Typora\typora-user-images\image-20220213183247492.png)

modelsim保存仿真设置和仿真波形

[modelsim中仿真波形设置的保存_坚持-CSDN博客_questasim保存波形](https://blog.csdn.net/wordwarwordwar/article/details/55254441)



220301

* 取消原config
* westin[1].rd_en是wesin[X].wr_en的1级缓存（总成立）
* cal_en[1]是westin[1].wr_en的一级缓存（总成立）
* cal_done[1]由{cal_en[1]，cal_en[1]_r}=2’b01生成
* out_rd_en：dout_val[1]使能计数两次，开始输出，重新计数
* 最后一行的n_cal_en恰好可以作为northin_fifo的写使能信号！
  * 注意：需要用逻辑门/三态门实现数据传输
* fifo 取消n_rd_en



220303

* 连续，差一个周期T（输出极限情况下）
  * westin.rd_en可以再抢一个T
* fifo透传模式
  * 当{wr_en,rd_en}=2'b11，且empty时，直接dout<= din

除输出fifo使能外完成修改，已经找到流水思路

修改后尚未仿真

220304

* 仿真完成
* 加入了fifo透传模式
* outfifo.rd_en: 最后一个T对齐PE输出的最后一个outfifo.wr_en
  * outfifo.rd_en持续X个T
  * PE从第一个输入(cal_en上升沿)开始，到产生第一个输出，需要N+1个T；到产生最后一个输出，需要N+1+2(N-1)=3N-1个T
  * cal_en=westin[2].rd_en, westin[X].rd_en
  * 即：PE从westin[X].rd_en开始，到产生第一个输出，需要N个T；到产生最后一个输出，需要N+2(N-1)=3N-2个T
  * 所以，westin[X].rd_en的3N-2-(X-1)=3N-X-1级延迟，作为outfifo[1].rd_en
  *  outfifo[i].rd_en为outfifo[1].rd_en的i\*N级延迟，即westin[X].rd_en的(3+i)\*N-X-1级延迟
  * 总共需
* cal_en cal_done用reg？
* northfifo.rd_en目前是与westinfifo.rd_en一致 实际位宽可能不一样，还有循环的要求，要重新设计

晚上

* 加入fifo透传后，westin_fifo.rd_en还可以再提前几个周期