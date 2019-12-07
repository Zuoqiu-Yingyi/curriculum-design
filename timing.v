/**已测试
 * 校时功能:时、分校时功能，校时输入脉冲频率1Hz。
 * 校时时:      异步置数位接timer模块的计数输出端
 * 设置闹钟时:  时钟时异步置数位接alarm模块的寄存器端
 */

module timing (   //校时模块
   input CP_1,    //时钟脉冲 1Hz

   input H_UP,    //小时位+
   input H_DOWN,  //小时位-
   input M_UP,    //分钟位+
   input M_DOWN,  //分钟位-
   input S_UP,    //秒位+
   input S_DOWN,  //秒位-

   input PE,		//异步置数,高电平有效
   input [7:0] D_H,	//异步置数数据 时
   input [7:0] D_M,	//异步置数数据 分
   input [7:0] D_S,	//异步置数数据 秒

   output  [7:0] Q_H,  //计数输出端 时
   output  [7:0] Q_M,  //计数输出端 分
   output  [7:0] Q_S   //计数输出端 秒 
);

   parameter MOD_60 = 8'h59;
   parameter MOD_24 = 8'h23;

   wire CP_S, CP_M, CP_H;
   wire CE_S, CE_M, CE_H;

      /* +1 -1调整信号只有一个为1时才有效 */
      assign CE_S = S_UP ^ S_DOWN | PE;
      assign CE_M = M_UP ^ M_DOWN | PE;
      assign CE_H = H_UP ^ H_DOWN | PE;
      /* 调整信号有效时将时钟脉冲接入计数器 */
      assign CP_S = CE_S & CP_1;
      assign CP_M = CE_M & CP_1;
      assign CP_H = CE_H & CP_1;

	counter_8421_2b	second( //秒计数
      .CP(CP_S),        //时钟信号
      .CE(CE_S),        //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(S_UP),        //正计数端,高电平有效
      .PE(PE),          //异步置位信号
      .D(D_S),          //异步置数数据
      .MAX(MOD_60),     //MAX数据(最大值)输入端
      .Q(Q_S)           //数据输出端
	);

	counter_8421_2b	minute( //分计数
      .CP(CP_M),        //时钟信号
      .CE(CE_M),        //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(M_UP),        //正计数端,高电平有效
      .PE(PE),          //异步置位信号
      .D(D_M),          //异步置数数据
      .MAX(MOD_60),     //MAX数据(最大值)输入端
      .Q(Q_M)           //数据输出端
	);

	counter_8421_2b	hour( //时计数
      .CP(CP_H),        //时钟信号
      .CE(CE_H),        //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(H_UP),        //正计数端,高电平有效
      .PE(PE),          //异步置位信号
      .D(D_H),          //异步置数数据
      .MAX(MOD_24),     //MAX数据(最大值)输入端
      .Q(Q_H)           //数据输出端
	);


endmodule