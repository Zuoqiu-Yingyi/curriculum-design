/* 数码管显示选择器 */
module digital_tube_display_selector(
   input [1:0] FUN,
   input [7:0] codeout0,
   input [7:0] codeout1,
   input [7:0] codeout2,
   input seg0,
   input seg1,
   input seg2,
   output reg [7:0] codeout, //译码管最终译码
   output reg [7:0] seg      //选位
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

endmodule
