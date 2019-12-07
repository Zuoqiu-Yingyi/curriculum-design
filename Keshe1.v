module Keshe1 (input CP,
               input CE,
               input PE,
               input CR,
               input HU,
               input HD,
               input MU,
               input MD,
               input SU,
               input SD,
            //    input CP_TEST,
               output [7:0] Q_H,  //计数输出
               output [7:0] Q_M,  //计数输出
               output [7:0] Q_S,  //计数输出
               output [7:0] codeout,
               output [7:0] D_H,
               output [7:0] D_M,
               output [7:0] D_S,
               output TC_H,           //进位输出�? 23�?
               output TC_M,           //进位输出�? 59�?
               output TC_S,           //进位输出�? 59�?
               output [7:0] seg,
               output AUDIO
               );
    wire[7:0]codeout1, codeout2;
    wire[7:0]seg1,seg2;

    parameter HIGH = 1'b1;
    
    /* 调用分频模块 */
    frequency_divider d1(
    .CP_50M(CP),
    .CP_1M(CLK1M),
    .CP_500_SQW(SCLK500hz),
    .CP_1K_SQW(SCLK1000hz),
    .CP_10K(CLK10K),
    .CP_1(CLK1hz)
    );

    /* 调用计时模块 */
    timer t1(.CP(CLK1hz),
    .CE(HIGH),
    .PE(~CE),
    .CR(CR),
    .D_H(D_H),
    .D_M(D_M),
    .D_S(D_S),
    .Q_H(Q_H),
    .Q_M(Q_M),
    .Q_S(Q_S)
    );

    /* 调用显示模块 */
    print pp1(
    .hour(Q_H),
    .minute(Q_M),
    .second(Q_S),
    .CP(CLK10K),
    .codeout(codeout1),
    .seg(seg1)
    );
    print pp2(
    .hour(D_H),
    .minute(D_M),
    .second(D_S),
    .CP(CLK10K),
    .codeout(codeout2),
    .seg(seg2)
    );

    /* 报时模块 */
    chronopher c1(
    .CP_500(SCLK500hz),
    .CP_1K(SCLK1000hz),
    .TIME_M(Q_M),
    .TIME_S(Q_S),
    .AUDIO(AUDIO)
    );

    /* 校时模块 */
    timing timing(
    .CP_1(CLK1hz),
    // .CP_1(CP_TEST),
    .PE(PE),
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
    
    assign codeout = (CE)?codeout1:codeout2;
    assign seg     = (CE)?seg1:seg2;
    
    /*timing timing1(.CP_1(CLK1hz),
     .H_UP(HU),.H_DOWN(HD),.M_UP(MU),.M_DOWN(MD),.S_UP(SU),.S_DOWN(SD),
     .PE(),
     .D_H(),.D_M(),.D_S(),
     .Q_H(),.Q_M(),.Q_S());
     //调用校时模块*/
    
    
endmodule
