/**
 *倒计时器,时间到TC拉高
 */
module countdown (
   input CP,         	//时钟信号
   input CE,         	//使能信号,高电平有效,低电平时计数器状态保持不变
   input PE,		      //异步置数,高电平有效
   input CR,         	//异步清零端,高电平有效
   input [7:0] D_H,	//异步置数数据 时
   input [7:0] D_M,	//异步置数数据 分
   input [7:0] D_S,	//异步置数数据 秒
	
   output  [7:0] Q_H,  //计数输出端 时
   output  [7:0] Q_M,  //计数输出端 分
   output  [7:0] Q_S,  //计数输出端 秒
	output test,
   output reg TC   //时间到触发
);
   parameter LOW    = 1'b0;
   parameter MOD_60 = 8'h59;
   parameter MOD_24 = 8'h23;

   reg CE_counter;   //计数器用

   assign test = CE_counter;
   
   initial begin
      TC = 1'b0;
		CE_counter = 1'b0;
   end

   wire TC_S, TC_M, TC_H;
   // parameter 

   always @ (Q_H, Q_M, Q_S, CE, PE) begin
      if (PE) begin
         TC <= 1'b0;
      end
      // else if ({Q_H, Q_M, Q_S} == 24'h00_00_00 && CE_counter == 1'b0 && CE == 1'b0) begin
      //    TC <= 1'b0;
      // end
      else if ({Q_H, Q_M, Q_S} == 24'h00_00_00) begin
         TC <= 1'b1;
         CE_counter <= 1'b0;
      end
      else begin
         CE_counter <= CE;
      end
   end

	counter_8421_2b	second( //秒计数
      .CP(CP),          //时钟信号
      .CE(CE_counter),  //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(LOW),         //正计数端,高电平有效
      .PE(PE),          //异步置位信号
      .D(D_S),          //异步置数数据
      .MAX(MOD_60),     //MAX数据(最大值)输入端
      .Q(Q_S),          //数据输出端
      .TC(TC_S) 	      //进位输出端
	);

	counter_8421_2b	minute( //分计数
      .CP(~TC_S),       //时钟信号
      .CE(CE_counter),  //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(LOW),         //正计数端,高电平有效
      .PE(PE),          //异步置位信号
      .D(D_M),          //异步置数数据
      .MAX(MOD_60),     //MAX数据(最大值)输入端
      .Q(Q_M),          //数据输出端
      .TC(TC_M) 	      //进位输出端
	);

	counter_8421_2b	hour( //时计数
      .CP(~TC_M),       //时钟信号
      .CE(CE_counter),  //使能信号,高电平有效,低电平时计数器状态保持不变
      .UP(LOW),         //正计数端,高电平有效
      .PE(PE),          //异步置位信号
      .D(D_H),          //异步置数数据
      .MAX(MOD_24),     //MAX数据(最大值)输入端
      .Q(Q_H),          //数据输出端
      .TC(TC_H) 	      //进位输出端
	);

endmodule