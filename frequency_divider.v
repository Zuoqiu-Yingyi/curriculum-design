module frequency_divider (
   input CP_50M,
   output CP_1M,
   output CP_10K,
   output CP_1K,
   output CP_500,
   output CP_10,
   output CP_1
);
   
   parameter HIGH = 1;
   parameter MOD_10 = 8'h09;
   parameter MOD_20 = 8'h19;
   parameter MOD_50 = 8'h49;
   parameter MOD_100 = 8'h99;
   // parameter 

	counter_8421_2b	FD1_50M_1M( //分频 50MHz->1MHz
      .CP(CP_50M), //时钟信号
      .CE(HIGH), //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH), //正计数端,高电平有效
      .MAX(MOD_50), //MAX数据(最大值)输入端
      .TC(CP_1M) //进位输出端
	);

	counter_8421_2b	FD1_1M_10K( //分频 1MHz->1KHz
      .CP(CP_1M), //时钟信号
      .CE(HIGH), //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH), //正计数端,高电平有效
      .MAX(MOD_100), //MAX数据(最大值)输入端
      .TC(CP_10K) //进位输出端
	);

	counter_8421_2b	FD1_10K_1K( //分频 10KHz->1KHz
      .CP(CP_10K), //时钟信号
      .CE(HIGH), //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH), //正计数端,高电平有效
      .MAX(MOD_10), //MAX数据(最大值)输入端
      .TC(CP_1K) //进位输出端
	);

	counter_8421_2b	FD1_10K_500( //分频 10KHz->500Hz
      .CP(CP_10K), //时钟信号
      .CE(HIGH), //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH), //正计数端,高电平有效
      .MAX(MOD_20), //MAX数据(最大值)输入端
      .TC(CP_500) //进位输出端
	);

	counter_8421_2b	FD1_500_10( //分频 500Hz->10Hz
      .CP(CP_500), //时钟信号
      .CE(HIGH), //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH), //正计数端,高电平有效
      .MAX(MOD_50), //MAX数据(最大值)输入端
      .TC(CP_10) //进位输出端
	);

	counter_8421_2b	FD1_10_1( //分频 10Hz->1Hz
      .CP(CP_10), //时钟信号
      .CE(HIGH), //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH), //正计数端,高电平有效
      .MAX(MOD_10), //MAX数据(最大值)输入端
      .TC(CP_1) //进位输出端
	);

endmodule