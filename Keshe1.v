module Keshe1 (input CP,  //输入实验箱50mhz赫兹
               input PE,    //高电平时校准时间
               input S1,S0, //菜单选择
               input End,  //关闹钟
               input Set,  //设置闹钟时间
               input HU,  //小时+
               input HD,  //小时-
               input MU,  //分钟+
               input MD,  //分钟-
               input SU,  //秒+
               input SD,  //秒-
               output [7:0] Q_H, output [7:0] Q_M, output [7:0] Q_S,  //计数输出
               output TC_H, output TC_M, output TC_S,     //进位输出
               output reg [7:0] codeout, //译码管最终译码
               output reg [7:0] seg,     //选位
               output AUDIO          //蜂鸣器
               );
					
    wire[7:0]D_H,D_M,D_S;
    wire[7:0]N_H,N_M,N_S;
    wire [7:0]codeout0, codeout1,codeout2;
    wire[7:0]seg0,seg1,seg2;
    

    parameter HIGH = 1'b1;
	 parameter LOW = 1'b0;
    
    /* 调用分频模块 */
    frequency_divider d1(
    .CP_50M(CP),            //输入试验箱50Mhz
    .CP_1M(CLK1M),          //得到1Mhz
    .CP_500_SQW(SCLK500hz), //得到500hz方波
    .CP_1K_SQW(SCLK1000hz), //得到1000hz方波
    .CP_10K(CLK10K),        //得到10Khz
    .CP_1(CLK1hz)           //得到1hz
    );

    /* 调用计时模块 */
    timer t1(
    .CP(CLK1hz),  //输入时钟脉冲1hz
    .CE(HIGH),    //始终进行计数+
    .PE(PE),      //PE高电平时开始置数    
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
	 .NUM(0),
    .codeout(codeout0),
    .seg(seg0)
    );
    print pp2(      //将设定时间计算为codeout1
    .hour(D_H),
    .minute(D_M),
    .second(D_S),
    .CP(CLK10K),
	 .NUM(1),
    .codeout(codeout1),
    .seg(seg1)
    );
    print pp3(      //将闹钟时间计算为codeout2
    .hour(N_H),
    .minute(N_M),
    .second(N_S),
    .CP(CLK10K),
	 .NUM(2),
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

    /* 校时模块 */
    timing timing1(
    .CP_1(CLK1hz),
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
    .Q_H(D_H),
    .Q_M(D_M),
    .Q_S(D_S)
    );
	 
	/* 闹钟设置时间模块 */
    timing timing2(
    .CP_1(CLK1hz),
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
    
    /*闹钟模块*/
   alarm alarm( 
   .CP_1(CLK1hz),       //1Hz时间信号
   .CS(End),         //控制信号,在闹钟响(CE==1)时上升沿触发后闹钟停止响铃(CE==0)
   .PE(Set),         //置数信号,高电平时闹钟置数

   .TIME_H(Q_H),  //时间信号,时
   .TIME_M(Q_M),  //时间信号,分
   .TIME_S(Q_S),  //时间信号,秒
   
   .D_H(N_H),  //置数数据输入,时
   .D_M(N_M),  //置数数据输出,分
   .D_S(N_S),  //置数数据输出,秒

   .CE(CE)     //使能,铃声控制信号
   );
   /*闹铃音频发生器*/
   alarm_sound_generator g(   
   .CE(CE),         //使能信号,高电平有效
   .CP_1(CLK1hz),       //1Hz脉冲输入
   .CP_500(SCLK500hz),     //500Hz方波输入
   .CP_1K(SCLK1000hz),      //1KHz方波输入
   .AUDIO(AUDIO_2)  //音频输出
);

	assign AUDIO=(CE&AUDIO_2)|(~CE&AUDIO_1);

    always@(*)
    begin
        case({S1,S0})
        2'b00:begin codeout<=codeout0;seg<=seg0;end
        2'b01:begin codeout<=codeout1;seg<=seg1;end
        2'b10:begin codeout<=codeout2;seg<=seg2;end
        default:seg=8'b00000000;
        endcase
    end
    
endmodule

