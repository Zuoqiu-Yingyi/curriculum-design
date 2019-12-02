/**已测试
 * 增加闹钟功能，最长闹铃时间为1分钟。闹钟的闹铃时刻可任意设置（只要求对时、分设置）。
 * 设置一个停止闹铃的按键，可以停止闹铃输出。 
 */

module alarm ( //闹钟
   input CP_1,       //1Hz时间信号
   input CS,         //控制信号,在闹钟响(CE==1)时上升沿触发后闹钟停止响铃(CE==0)
   input PE,         //置数信号,高电平时闹钟置数

   input [7:0] TIME_H,  //时间信号,时
   input [7:0] TIME_M,  //时间信号,分
   input [7:0] TIME_S,  //时间信号,秒
   
   input [7:0] D_H,  //置数数据输入,时
   input [7:0] D_M,  //置数数据输出,分
   input [7:0] D_S,  //置数数据输出,秒

   output reg [7:0] BFM_H,   //闹钟寄存器,时
   output reg [7:0] BFM_M,   //闹钟寄存器,分
   output reg [7:0] BFM_S,   //闹钟寄存器,秒

   output reg CE     //使能,铃声控制信号
);

   wire TC_counter;  //计数器的进位输出信号
   wire TRGI_counter;//计数器触发信号


   reg CE_counter = 1'b0;  //计数器的使能信号
   reg CR_counter = 1'b1;  //计数器异步清零信号
   reg CR = 1'b0; //计时器清零信号

   parameter LOW = 1'b0;
   parameter HIGH = 1'b1;
   parameter MOD_60 = 8'h59;

   initial begin
      CE = 0;
      BFM_H = 8'h00;
      BFM_M = 8'h00;
      BFM_S = 8'h00;
   end

   assign TRGI_counter = {TIME_H, TIME_M, TIME_S} == {BFM_H, BFM_M, BFM_S};

   always @ (PE) begin  //置数
      if (PE) begin
         BFM_H <= D_H;
         BFM_M <= D_M;
         BFM_S <= D_S;
      end
      else begin
         BFM_H <= BFM_H;
         BFM_M <= BFM_M;
         BFM_S <= BFM_S;
      end
   end

   counter_8421_2b counter_60s(  //计时器
      .CP(CP_1),
      .CE(CE_counter),
      .CR(CR_counter),
      .PE(LOW),
      .UP(HIGH),
      .MAX(MOD_60),
      .TC(TC_counter)
   );

   /* TRGI_counter开启响铃,CS上升沿触发/计数器计时一分钟关闭响铃 */
   always @ (posedge TRGI_counter, posedge CS, negedge TC_counter) begin
      if (CS) begin   //手动关闭响铃
         /* 计数器置零,不再工作,关闭响铃 */
         CR_counter <= HIGH;
         CE_counter <= LOW;
         CE <= LOW;
      end
      else if (TRGI_counter) begin  //闹铃响
         CR_counter <= LOW;  //计数器不再清零
         CE_counter <= HIGH;  //计数器开始工作
         CE <= HIGH;          //闹钟响铃
      end
      else begin  //响铃一分钟,关闭响铃
         CR_counter <= HIGH; 
         CE_counter <= LOW;
         CE <= LOW;
      end
   end


endmodule