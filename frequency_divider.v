/**已测试
 * 分频器
 * TODO: 1KHz方波, 500Hz方波, 1Hz脉冲波
 */
module frequency_divider (
   input CP_50M,
   output CP_1M,
   output CP_10K,
   output CP_1K_SQW,
   output CP_500_SQW,
   output CP_10,
   output CP_1
);
   wire CP_1K, CP_2K;
   
   parameter HIGH = 1;
   parameter MOD_5 = 8'h04;
   parameter MOD_10 = 8'h09;
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

   counter_8421_2b	FD1_10K_2K( //分频 10KHz->2KHz
      .CP(CP_10K), //时钟信号
      .CE(HIGH), //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH), //正计数端,高电平有效
      .MAX(MOD_5), //MAX数据(最大值)输入端
      .TC(CP_2K) //进位输出端
   );

   square_wave_generator sqw_2K_1K( //将2KHz的脉冲波转化为1KHz的方波
      .CP(CP_2K),       //2K脉冲波输入
      .SQW(CP_1K_SQW)   //1K方波输出
   );

   counter_8421_2b	FD1_10K_1K( //分频 10KHz->1KHz
      .CP(CP_10K), //时钟信号
      .CE(HIGH), //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH), //正计数端,高电平有效
      .MAX(MOD_10), //MAX数据(最大值)输入端
      .TC(CP_1K) //进位输出端
   );

   square_wave_generator sqw_1K_500( //将1KHz的脉冲波转化为500Hz的方波
      .CP(CP_1K),       //1K脉冲波输入
      .SQW(CP_500_SQW)   //500方波输出
   );

   counter_8421_2b	FD1_1K_10( //分频 1KHz->10Hz
      .CP(CP_1K), //时钟信号
      .CE(HIGH), //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH), //正计数端,高电平有效
      .MAX(MOD_100), //MAX数据(最大值)输入端
      .TC(CP_10) //进位输出端
   );

   counter_8421_2b	FD1_10_1( //分频 10Hz->1Hz
      .CP(CP_10), //时钟信号
      .CE(HIGH), //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(HIGH), //正计数端,高电平有效
      .MAX(MOD_10), //MAX数据(最大值)输入端
      .TC(CP_1) //进位输出端
   );

endmodule   //frequency_divider  分频器
