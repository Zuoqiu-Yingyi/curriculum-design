module Decoder47(codeout,indec);     //4-7译码管 8421码转为七段译码管显示
  input[3:0] indec;
  output[6:0] codeout;
  reg[6:0] codeout;

  always@(indec)
  begin
    case(indec)
    4'd0:codeout=8'b01111110;
    4'd1:codeout=8'b00110000;
    4'd2:codeout=8'b01101101;
    4'd3:codeout=8'b01111001;
    4'd4:codeout=8'b00110011;
    4'd5:codeout=8'b01011011;
    4'd6:codeout=8'b01011111;
    4'd7:codeout=8'b01110000;
    4'd8:codeout=8'b01111111;
    4'd9:codeout=8'b01111011;
    default:  codeout=8'b00000000;
    endcase
  end
endmodule
