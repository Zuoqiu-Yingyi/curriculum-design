module Keshe1 (
   input CP,         	//时钟信号
   input CE,         	//使能信号,高电平有效,低电平时计数器状态保持不变
   input PE,				//同步置数,高电平有效
   input CR,         	//异步清零端,高电平有效
   input HU,HD,MU,MD,SU,SD,
   output  wire[7:0] Q_H,  //计数输出端 时
   output  wire[7:0] Q_M,  //计数输出端 分
   output wire [7:0] Q_S,  //计数输出端 秒
	output [6:0] codeout,
	output [7:0] D_H, D_M,D_S,
   output   TC_H,    //进位输出端 23时
   output   TC_M,    //进位输出端 59分
   output   TC_S,     //进位输出端 59秒
	output [7:0]seg,
	output AUDIO
);
wire[6:0]codeout1,codeout2;
wire[7:0]seg1,seg2;

frequency_divider d1(.CP_50M(CP),.CP_1M(CLK1M),.CP_500_SQW(SCLK500hz),.CP_1K_SQW(SCLK1000hz),.CP_10K(CLK10K),.CP_1(CLK1hz));
//调用分频模块
timer t1(.CP(CLK1hz),.CE(CE),.PE(~CE),.CR(CR),.D_H(D_H),.D_M(D_M),.D_S(D_S),.Q_H(Q_H),.Q_M(Q_M),.Q_S(Q_S),);
//调用计时模块
print pp1(.hour(Q_H),.minute(Q_M),.second(Q_S),.CP(CLK10K),.codeout(codeout1),.seg(seg1));
print pp2(.hour(D_H),.minute(D_M),.second(D_S),.CP(CLK10K),.codeout(codeout2),.seg(seg2));
//调用显示模块
chronopher (.CP_500(SCLK500hz),.CP_1K(SCLK1000hz),.TIME_M(Q_M),.TIME_S(Q_S),.AUDIO(AUDIO));
//报时器
timing timing(.CP_1(CLK1hz),.PE(PE),.H_UP(HU),.H_DOWN(HD),.M_UP(MU),.M_DOWN(MD),.S_UP(SU),.S_DOWN(SD),
				  .Q_H(D_H),.Q_M(D_M),.Q_S(D_S));

assign codeout=(CE)?codeout1:codeout2;
assign seg=(CE)?seg1:seg2;
//校时模块

/*timing timing1(.CP_1(CLK1hz),
        .H_UP(HU),.H_DOWN(HD),.M_UP(MU),.M_DOWN(MD),.S_UP(SU),.S_DOWN(SD),
        .PE(),
        .D_H(),.D_M(),.D_S(),
        .Q_H(),.Q_M(),.Q_S());
//调用校时模块*/ 


endmodule
