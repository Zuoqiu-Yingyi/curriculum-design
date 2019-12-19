/* 数码管显示信号选择器 */
module digital_tube_display_selector(
   input [1:0] FUN,        //模式选择信号
   input [7:0] codeout0,   //数码管信号0输入
   input [7:0] codeout1,   //数码管信号1输入
   input [7:0] codeout2,   //数码管信号2输入
   input [7:0] seg0,    //位选信号0输入
   input [7:0] seg1,    //位选信号1输入
   input [7:0] seg2,    //位选信号2输入
   output reg [7:0] codeout, //数码管最终控制信号
   output reg [7:0] seg      //位选信号
);
   initial begin
      codeout = 8'b0000_0000;
      seg = 8'b0000_0000;
   end

   always@(*)
   begin
      case(FUN)
      2'b00:begin codeout<=codeout0;seg<=seg0;end
      2'b01:begin codeout<=codeout1;seg<=seg1;end
      2'b10:begin codeout<=codeout1;seg<=seg1;end
      2'b11:begin codeout<=codeout2;seg<=seg2;end
      default:seg=8'b00000000;
      endcase
   end

endmodule   //digital_tube_display_selector  数码管显示信号选择器
