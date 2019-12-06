module print(
	input [7:0]hour,minute,second,
	input CP,
	output reg [6:0]codeout,
	output reg [7:0]seg
);
wire [3:0]hour0,hour1,min0,min1,sec0,sec1;

reg [2:0]n;
wire [6:0]codeout1,codeout2,codeout3,codeout4,codeout5,codeout6;

assign hour0[3:0]=hour[7:4];
assign hour1[3:0]=hour[3:0];
assign min0[3:0]=minute[7:4];
assign min1[3:0]=minute[3:0];
assign sec0[3:0]=second[7:4];
assign sec1[3:0]=second[3:0];

Decoder47 Decoder1(.codeout(codeout1),.indec(hour0));
Decoder47 Decoder2(.codeout(codeout2),.indec(hour1));
Decoder47 Decoder3(.codeout(codeout3),.indec(min0));
Decoder47 Decoder4(.codeout(codeout4),.indec(min1));
Decoder47 Decoder5(.codeout(codeout5),.indec(sec0));
Decoder47 Decoder6(.codeout(codeout6),.indec(sec1));

always@(posedge CP)
begin
	if(n==3'b101)
			n<=3'b000;
	else
			n<=n+1;
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
	default:seg<=8'b00000000;
	endcase
end

endmodule
