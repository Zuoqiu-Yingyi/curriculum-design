//具有模仿电台整点报时功能
//即每逢59分51秒、53秒、57秒时输出500Hz低音频信号
//59分59秒时输出1kHz高音频信号
//输出音频信号的持续时间为1秒 高音频信号结束时正好是整点
module Ring(
	input [7:0]minute,second,
	input CP_1Khz,
	output reg Low_sound,High_sound
);

always@(posedge CP_1Khz)
begin
	Low_sound<=1'b0;
	High_sound<=1'b0;
	if(minute==8'b01011001)
	begin
		if(second==8'b01010001|second==8'b01010011|second==8'b01010111)
			Low_sound<=1'b1;
		else if(second==8'b01011001)
			High_sound<=1'b1;
	end
end
endmodule
