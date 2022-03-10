# RSA控制信号设计

$$
A_{mn}\times B_{nk} = C_{mk}
$$

输入：

* Xin_val: 与Xin_data同步的有效信号
* Xin_data

接下来可以输入：

m n k

参数：

* RSA维度：X*Y个PE

  * X和westin_fifo

  * Y个northin_fifo

  * X个out_fifo

* FIFO深度：N(n的最大值)

* 输入数据最大位宽IN_LEN

* 输出数据最大位宽OUT_LEN

根据输入的m n k，生成使能信号Xin_val, Yin_val 

## 硬件连接结构

$A_{mn}$输入：从左到右

$B_{nk}$输入：从上到下，最后数据循环回north_fifo

输出：从右向左横向输出。从最右端逐步向左

PE：n_cal_en, n_cal_done：第一行横向传递，其余每列纵向传递

## 输入->in_fifo：两种模式

* 外部输入信号->fifo
* 数据复用模式
  * eastout -> westin_fifo
  * southout -> northin_fifo 

### 输入$A_{mn}$->westin_fifo

* 整体使能信号：Xin_val
* westin_wr_en[1]：
  * 持续时间为n个周期——计数器+比较
* westin_wr_en[X:1]：
  * 移位寄存器。计数器计满则移位
  * 移位一次，计数一次。与n比较，确定是否往复

![image-20220308104402124](C:\Users\KevinZ\AppData\Roaming\Typora\typora-user-images\image-20220308104402124.png)

### 输入$B_{nk}$ -> northin_fifo

* 整体使能信号：Yin_val
* northin_wr_en[Y:1]:
  * 每个时钟周期移位
  * 与n比较，确定是否往复

![image-20220308105756934](C:\Users\KevinZ\AppData\Roaming\Typora\typora-user-images\image-20220308105756934.png)

### 数据复用

三态门

fifo.wr_en可直接用n_cal_en

最后一个周期不再往里写：

## in_fifo -> PE

### westin_rd_en[X:1]

* westin_rd_en[1]是westin[1].wr_en的n*(m-1)+1级延迟
  * 无需额外使能信号(Xin_val有效才会产生对应的rd_en)
* westin[i].rd_en：westin[1].rd_en的(i-1)级延迟
  * 共m-1级延迟
  * 使能信号：fifo_empty?

### northin_rd_en[Y:1]

* northin[1].rd_en是westin[1].wr_en的n*(m-1)+1级延迟
* northin[i].rd_en：northin[1].rd_en的(i-1)级延迟

## 计算使能

cal_en: westin[1].rd_en的一级延迟

cal_done: if({cal_en,westin_rd_en[1]} == 2'b10), cal_done<=1'b1;

## PE总使能端



## PE输出->outFIFO：有对应输出信号



## outFIFO->输出

* outfifo[1].rd_en：westin[1].rd_en的n+2+(k-1)=n+k+1级延迟
  * 1：cal_en[1]: westin[1].rd_en的一级延迟
  * n+1：cal_en上升沿后n+1个周期，产生第一个输出结果
  * 2\*(k-1)：产生第一个输出结果后2\*(k-1)个周期，产生最后一个输出结果
  * 保证最后一个输出的out.wr_en和out.rd_en是同一个时钟周期。
  * 往前(k-1)个时钟周期，outfifo[1].rd_en有效

* outfifo[i].rd_en为outfifo[1].rd_en的i\*k级延迟

