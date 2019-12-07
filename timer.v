module timer (
   input CP,         	//时钟信号
   input CE,         	//使能信号,高电平有效,低电平时计数器状态保持不变
   input PE,		//异步置数,高电平有效
   input CR,         	//异步清零端,高电平有效
   input [7:0] D_H,	//异步置数数据 时
   input [7:0] D_M,	//异步置数数据 分
   input [7:0] D_S,	//异步置数数据 秒
	
   output  [7:0] Q_H,  //计数输出端 时
   output  [7:0] Q_M,  //计数输出端 分
   output  [7:0] Q_S,  //计数输出端 秒
	
   output   TC_H,    //进位输出端 23时
   output   TC_M,    //进位输出端 59分
   output   TC_S     //进位输出端 59秒
);
   parameter HIGH   = 1;
   parameter MOD_60 = 8'h59;
   parameter MOD_24 = 8'h23;
   // parameter 

	counter_8421_2b	second( //秒计数
      .CP(CP),          //时钟信号
      .CE(CE),          //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH),        //正计数端,高电平有效
      .PE(PE),          //异步置位信号
      .D(D_S),          //异步置数数据
      .MAX(MOD_60),     //MAX数据(最大值)输入端
      .Q(Q_S),          //数据输出端
      .TC(TC_S) 	      //进位输出端
	);

	counter_8421_2b	minute( //分计数
      .CP(~TC_S),       //时钟信号
      .CE(CE),          //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH),        //正计数端,高电平有效
      .PE(PE),          //异步置位信号
      .D(D_M),          //异步置数数据
      .MAX(MOD_60),     //MAX数据(最大值)输入端
      .Q(Q_M),          //数据输出端
      .TC(TC_M) 	      //进位输出端
	);

	counter_8421_2b	hour( //时计数
      .CP(~TC_M),       //时钟信号
      .CE(CE),          //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH),        //正计数端,高电平有效
      .PE(PE),          //异步置位信号
      .D(D_H),          //异步置数数据
      .MAX(MOD_24),     //MAX数据(最大值)输入端
      .Q(Q_H),          //数据输出端
      .TC(TC_H) 	      //进位输出端
	);

endmodule