# PE模块开发

## PE计算单元

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