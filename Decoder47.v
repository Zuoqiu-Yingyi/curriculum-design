module Decoder47(codeout,indec);     //4-7译码管 8421码转为七段译码管显示
  input[3:0] indec;
  output[7:0] codeout;
  reg[7:0] codeout;

  always@(indec)
  begin
    case(indec)
    4'd0:codeout=8'b0111_1110;
    4'd1:codeout=8'b0011_0000;
    4'd2:codeout=8'b0110_1101;
    4'd3:codeout=8'b0111_1001;
    4'd4:codeout=8'b0011_0011;
    4'd5:codeout=8'b0101_1011;
    4'd6:codeout=8'b0101_1111;
    4'd7:codeout=8'b0111_0000;
    4'd8:codeout=8'b0111_1111;
    4'd9:codeout=8'b0111_1011;
    default:  codeout=8'b0000_0000;
    endcase
  end
endmodule
