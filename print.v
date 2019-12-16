/* 显示模块 */
module print(
	input [7:0] hour,		//5:4两位所显示数据的输入
	input [7:0] minute,	//3:2两位所显示数据的输入
	input [7:0] second,	//1:0两位所显示数据的输入
	input CP,				//触发位选信号切换的时钟脉冲
	input [1:0] NUM,		//最左位数码管显示的功能编号
	output reg [7:0] codeout,	//每一组位选信号所对应的数码管信号输出
	output reg [7:0] seg			//位选信号输出
);
wire [3:0]hour0,hour1,min0,min1,sec0,sec1;

reg [2:0]n;
wire [7:0]codeout0,codeout1,codeout2,codeout3,codeout4,codeout5,codeout6;

assign hour0[3:0]=hour[7:4];
assign hour1[3:0]=hour[3:0];
assign min0[3:0]=minute[7:4];
assign min1[3:0]=minute[3:0];
assign sec0[3:0]=second[7:4];
assign sec1[3:0]=second[3:0];


Decoder47 Decoder0(.codeout(codeout0),.indec({2'b00, NUM}));
Decoder47 Decoder1(.codeout(codeout1),.indec(hour0));
Decoder47 Decoder2(.codeout(codeout2),.indec(hour1));
Decoder47 Decoder3(.codeout(codeout3),.indec(min0));
Decoder47 Decoder4(.codeout(codeout4),.indec(min1));
Decoder47 Decoder5(.codeout(codeout5),.indec(sec0));
Decoder47 Decoder6(.codeout(codeout6),.indec(sec1));

always@(posedge CP) begin
	// if(n==3'b101)
	// 		n<=3'b000;
	// else
	n <= n+1;
end

always@(posedge CP)
begin
	case(n)
	3'b000:begin seg<=8'b00000001;codeout<=codeout6; end
	3'b001:begin seg<=8'b00000010;codeout<=codeout5; end
	3'b010:begin seg<=8'b00000100;codeout<=codeout4; end
	3'b011:begin seg<=8'b00001000;codeout<=codeout3; end
	3'b100:begin seg<=8'b00010000;codeout<=codeout2; end
	3'b101:begin seg<=8'b00100000;codeout<=codeout1; end
	3'b110:begin seg<=8'b00000000; end
	3'b111:begin seg<=8'b10000000;codeout<=codeout0; end
	default:seg<=8'b00000000;
	endcase
end

endmodule	//print	显示模块
