module Keshe1 (
  input CP,  //输入实验箱50mhz赫兹
  // input PE,    //高电平时校准时间
  input CR,   //清零
  input S1,S0, //菜单选择
  input CS,  //关闹钟(上升沿)
  input HU,  //小时+
  input HD,  //小时-
  input MU,  //分钟+
  input MD,  //分钟-
  input SU,  //秒+
  input SD,  //秒-
  input LEAD,  //导入按钮
  input EXPORT,  //导出按钮
  // output [7:0] Q_H, output [7:0] Q_M, output [7:0] Q_S,  //时钟输出
  // output TC_H, output TC_M, output TC_S,     //进位输出
  output [7:0] codeout, //译码管最终译码
  output [7:0] seg,     //选位
  output COLON,         //冒号
  output AUDIO          //蜂鸣器
);
		wire [7:0] Q_H, Q_M, Q_S; //时钟模块timer数据输出,接数据选择器,pp1与闹钟时间输入
		wire [7:0] T_H, T_M, T_S; //闹钟模块alarm数据输出,接数据选择器
		wire [7:0] S_H, S_M, S_S; //数据选择器数据输出,接时间设置模块timing1数据输入
    wire [7:0] D_H, D_M, D_S; //时间设置模块timing1的数据输出,接timer与alarm的数据输入
    wire [7:0] N_H, N_M, N_S; //倒计时设置模块timing2的数据输出,接countdown的数据输入
    wire [7:0] C_H, C_M, C_S; //倒计时模块countdown1的数据输出,接
    wire [7:0] codeout0, codeout1, codeout2;
    wire [7:0] seg0, seg1, seg2;
    wire TC_alarm, TC_countdown;
    wire LEAD_timer, LEAD_alarm, start;
    wire EXPORT_timer, EXPORT_alarm, pause;
    wire PE_countdown, CE_countdown;
    wire AUDIO_1, AUDIO_2;

    wire CLK1M, SCLK500hz, SCLK1000hz, CLK10K, CLK1hz;
    

    parameter HIGH = 1'b1;
	  parameter LOW = 1'b0;

 	  assign AUDIO = ~CS & ((TC_alarm | TC_countdown) & AUDIO_2)|(~(TC_alarm | TC_countdown) & AUDIO_1);

    /* 两个冒号闪烁 */
    square_wave_generator blink (
      .CP(CLK1hz),
      .SQW(COLON)
    );

    /* 导入导出信号选择 */
    data_distributor_2b menu(
      .FUN({S1, S0}),
      .IN({LEAD, EXPORT}),
      .OUT_1({LEAD_timer, EXPORT_timer}),
      .OUT_2({LEAD_alarm, EXPORT_alarm}),
      .OUT_3({start, pause})
    );

    /* 导入导出数据选择 */
    data_selector_24b data(
      .FUN({S1, S0}),
      .OUT({S_H, S_M, S_S}),
      .IN_1({Q_H, Q_M, Q_S}),
      .IN_2({T_H, T_M, T_S}),
      .IN_3({24'h00_00_00})
    );


    
    /* 调用分频模块 */
    frequency_divider d1(
      .CP_50M(CP),            //输入试验箱50Mhz
      // .CP_1M(CLK1M),          //得到1Mhz
      .CP_500_SQW(SCLK500hz), //得到500hz方波
      .CP_1K_SQW(SCLK1000hz), //得到1000hz方波
      .CP_10K(CLK10K),        //得到10Khz
      .CP_1(CLK1hz)           //得到1hz
    );

    /* 调用计时模块 */
    timer t1(
      .CP(CLK1hz),  //输入时钟脉冲1hz
      .CE(HIGH),    //始终进行计数+
      .PE(LEAD_timer),      //PE高电平时开始置数    
      .CR(CR),
      .D_H(D_H),
      .D_M(D_M),
      .D_S(D_S),
      .Q_H(Q_H),
      .Q_M(Q_M),
      .Q_S(Q_S)
    );

    /* 调用显示模块 */
    print pp1(      //将时钟时间计算为codeout0
      .hour(Q_H),
      .minute(Q_M),
      .second(Q_S),
      .CP(CLK10K),
      .NUM(2'b00),
      .codeout(codeout0),
      .seg(seg0)
    );
    print pp2(      //将设定时间计算为codeout1
      .hour(D_H),
      .minute(D_M),
      .second(D_S),
      .CP(CLK10K),
      .NUM({S1, S0}),
      .codeout(codeout1),
      .seg(seg1)
    );
    print pp3(      //将倒计时显示为codeout2
      .hour(C_H),
      .minute(C_M),
      .second(C_S),
      .CP(CLK10K),
      .NUM(2'b11),
      .codeout(codeout2),
      .seg(seg2)
    );

    /* 报时模块 */
    chronopher c1(
      .CP_500(SCLK500hz),
      .CP_1K(SCLK1000hz),
      .TIME_M(Q_M),
      .TIME_S(Q_S),
      .AUDIO(AUDIO_1)
    );

    /* 时间设置模块 */
    timing timing1(
      .CP_1(CLK1hz),

      .CR(CR),

      .PE(EXPORT_timer | EXPORT_alarm),
      .D_H(S_H),
      .D_M(S_M),
      .D_S(S_S),

      .H_UP(HU),
      .H_DOWN(HD),

      .M_UP(MU),
      .M_DOWN(MD),

      .S_UP(SU),
      .S_DOWN(SD),

      .Q_H(D_H),
      .Q_M(D_M),
      .Q_S(D_S)
    );
	 
    
    /*闹钟模块*/
    alarm alarm1( 
      .CP_1(CLK1hz),       //1Hz时间信号
      .CS(CS),         //控制信号,在闹钟响(CE==1)时上升沿触发后闹钟停止响铃(CE==0)
      .PE(LEAD_alarm),         //置数信号,高电平时闹钟置数

      .TIME_H(Q_H),  //时间信号,时
      .TIME_M(Q_M),  //时间信号,分
      .TIME_S(Q_S),  //时间信号,秒
      
      .D_H(D_H),  //置数数据输入,时
      .D_M(D_M),  //置数数据输出,分
      .D_S(D_S),  //置数数据输出,秒

      .BFM_H(T_H),   //闹钟寄存器,时
      .BFM_M(T_M),   //闹钟寄存器,分
      .BFM_S(T_S),   //闹钟寄存器,秒      

      .TC(TC_alarm)     //使能,铃声控制信号
    );
    
    /*闹铃音频发生器*/
    alarm_sound_generator g(   
      .CE(TC_alarm | TC_countdown),         //使能信号,高电平有效
      .CP_1(CLK1hz),       //1Hz脉冲输入
      .CP_500(SCLK500hz),     //500Hz方波输入
      .CP_1K(SCLK1000hz),      //1KHz方波输入
      .AUDIO(AUDIO_2)  //音频输出
    );

	  /* 倒计时设置时间模块 */
    timing timing2(
      .CP_1(CLK1hz),

      .CR(CR),
      //.PE(PE),
      .H_UP(HU),
      .H_DOWN(HD),
      .M_UP(MU),
      .M_DOWN(MD),
      .S_UP(SU),
      .S_DOWN(SD),
      /*.D_H(DHnew),
      .D_M(DMnew),
      .D_S(DSnew),*/
      .Q_H(N_H),
      .Q_M(N_M),
      .Q_S(N_S)
    );
	 
    switch s1(
      .ON(&{S1, S0}),
      .OFF(start),
      .D(HIGH),
      .Q(PE_countdown)
    );
    /* 倒计时模块 */
    countdown countdown1(
      .CP(CLK1hz),         	//时钟信号
      .CS(CS),    //控制信号,在闹钟响(TC==1)时上升沿触发后闹钟停止响铃(TC==0)
      .CE(~pause),         	//使能信号,高电平有效,低电平时计数器状态保持不变
      .PE(PE_countdown),		      //异步置数,高电平有效
      .CR(CR),    //异步清零

      .D_H(N_H),	//异步置数数据 时
      .D_M(N_M),	//异步置数数据 分
      .D_S(N_S),	//异步置数数据 秒

      .Q_H(C_H),  //计数输出端 时
      .Q_M(C_M),  //计数输出端 分
      .Q_S(C_S),  //计数输出端 秒
      
      .TC(TC_countdown)   //时间到触发
    );

    /* 数码管显示选择器 */
    digital_tube_display_selector selector1(
      .FUN({S1, S0}),
      .codeout0(codeout0),
      .codeout1(codeout1),
      .codeout2(codeout2),
      .seg0(seg0),
      .seg1(seg1),
      .seg2(seg2),
      .codeout(codeout), //译码管最终译码
      .seg(seg)      //选位
    );

endmodule