# curriculum-design
数字电子技术课程设计

课程设计选题3—数字时钟
设计一个具有时、分、秒显示的数字钟，按24小时计时。
1. 数字钟的具体要求如下：
   1. 输出时、分、秒的BCD码，并用数码管显示，计时输入脉冲频率1Hz。
   2. 具有时、分校时功能，校时输入脉冲频率1Hz。
   3. 具有模仿电台整点报时功能，即每逢59分51秒、53秒、57秒时输出500Hz低音频信号，59分59秒时输出1kHz高音频信号，输出音频信号的持续时间为1秒，高音频信号结束时正好是整点。
   4. 增加闹钟功能，最长闹铃时间为1分钟。闹钟的闹铃时刻可任意设置（只要求对时、分设置），闹铃信号为500Hz和1kHz的方波型号，两种信号交替输出，均持续1秒。设置一个停止闹铃的按键，可以停止闹铃输出。
   5. 采用分层次、分模块的设计方法。

2. 报告内容（严格按以下顺序撰写报告！）
   1. 小组成员分工（每人负责完成的工作）
   2. 完成该设计所用时间
   3. 设计原理，设计思路，电路，状态机等等（分层次分模块介绍）
   4. 仿真结果的波形图及相应的分析说明
   5. 引脚分配列表，说明电路的输入输出分别用试验箱上的哪些资源（开关或LED）表示，各开关如何操作
   6. 运行结果照片
   7. Verilog HDL代码（要求加必要的注释）。
