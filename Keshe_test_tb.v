/* 整体功能测试用testbeach */
module Keshe_test_tb;

   reg SCLK500hz, SCLK1000hz, CLK10K, CLK1hz;
   reg CS, CR;
   reg HU, HD, MU, MD, SU, SD;
   reg LEAD, EXPORT;
   reg [1:0] S;

   wire [23:0] Q;
   wire [23:0] D;
   wire [23:0] C;

   Keshe_test K(
      .SCLK500hz(SCLK500hz),
      .SCLK1000hz(SCLK1000hz),
      .CLK10K(CLK10K),
      .CLK1hz(CLK1hz),

      .S1(S[1]),
      .S0(S[0]),

      .CS(CS),

      .HU(HU),
      .HD(HD),
      .MU(MU),
      .MD(MD),
      .SU(SU),
      .SD(SD),

      .LEAD(LEAD),
      .EXPORT(EXPORT),

      .COLON(COLON),
      .AUDIO(AUDIO),

      .Q_H(Q[23:16]),
      .Q_M(Q[15:8]),
      .Q_S(Q[7:0]),
      .D_H(D[23:16]),
      .D_M(D[15:8]),
      .D_S(D[7:0]),
      .C_H(C[23:16]),
      .C_M(C[15:8]),
      .C_S(C[7:0]) 
   );

   initial begin  //时钟
      CLK1hz = 1'b0;
      CLK10K = 1'b0;
      SCLK1000hz = 1'b0;
      SCLK500hz = 1'b0;

      forever begin
         #1 SCLK1000hz = ~SCLK1000hz;

         #1 SCLK1000hz = ~SCLK1000hz;
            SCLK500hz = ~SCLK500hz;

         #1 SCLK1000hz = ~SCLK1000hz;

         #1 SCLK1000hz = ~SCLK1000hz;
            SCLK500hz = ~SCLK500hz;
            CLK10K = ~CLK10K;

         #1 SCLK1000hz = ~SCLK1000hz;

         #1 SCLK1000hz = ~SCLK1000hz;
            SCLK500hz = ~SCLK500hz;

         #1 SCLK1000hz = ~SCLK1000hz;

         #1 SCLK1000hz = ~SCLK1000hz;
            SCLK500hz = ~SCLK500hz;
            CLK10K = ~CLK10K;
            CLK1hz = ~CLK1hz;
      end
   end

   initial begin
      S = 2'b00;
      CS = 1'b0;
      CR = 1'b0;
      LEAD = 1'b0;
      EXPORT = 1'b0;
      {HD, HU, MD, MU, SD, SU} = 6'b00_00_00;

      #8    CS = 1'b1;  //铃声初始化
            CR = 1'b1;  //所有的计数器初始化
      #8    CS = 1'b0;  //铃声初始化
            CR = 1'b0;  //所有的计数器初始化

      #80   //让时钟从00:00:00开始跑一段时间

      #0    S = 2'b01;  //切换至时间设置模式
            {HD, HU, MD, MU, SD, SU} = 6'b10_10_01;   //时间设置

      #16   {HD, HU, MD, MU, SD, SU} = 6'b10_00_01;   //分钟设置为59分,用于测试整点报时

      #48   {HD, HU, MD, MU, SD, SU} = 6'b00_00_00; //调整至一个时间后停止调整

      #16   LEAD = 1'b1;   //将时间导入

      #8    LEAD = 1'b0;   //导入信号复位

      #60   EXPORT = 1'b1; //将时钟模块中的时间导出至时间设置模块
      #16   EXPORT = 1'b0; //导出信号复位
            S = 2'b10;     //切换至闹钟设置模式

      #8    {HD, HU, MD, MU, SD, SU} = 6'b01_01_00;   //闹钟设置为下一分钟
            
      #16   {HD, HU, MD, MU, SD, SU} = 6'b00_00_00;  //调整至一个时间后停止调整

      #16   LEAD = 1'b1;   //导入闹钟
      #16   LEAD = 1'b0;   //导入信号复位

      #1040 CS = 1'b1;     //手动触发停止响铃
      #16   CS = 1'b0;     //停止响铃复位

      #16   S = 2'b11;     //切换至倒计时模式

      #16   {HD, HU, MD, MU, SD, SU} = 6'b00_00_01;   //倒计时设置
            
      #160  {HD, HU, MD, MU, SD, SU} = 6'b00_00_00;  //调整至一个时间后停止调整

      #48   LEAD = 1'b1;   //触发倒计时,倒计时开始
      #16   LEAD = 1'b0;   //倒计时开始触发信号复位

      #80   EXPORT = 1'b1; //倒计时暂停
      #80   EXPORT = 1'b0; //倒计时继续

      #1200 ;  //响铃60s

      $stop;

   end


endmodule   //Keshe_test_tb