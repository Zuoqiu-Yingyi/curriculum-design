/* 数据选择(24位) */
module data_selector_24b(
   input [1:0] FUN,    //选择输出端
   input [23:0] IN_1, //信号输入1
   input [23:0] IN_2, //信号输入2
   input [23:0] IN_3,  //信号输入3
   output reg [23:0] OUT     //信号输出
);
   initial OUT = 24'h00_00_00;

   always @ (FUN, IN_1, IN_2, IN_3) begin
      case  (FUN)
         2'b01: OUT <= IN_1;
         2'b10: OUT <= IN_2;
         2'b11: OUT <= IN_3;
         default: OUT <= 24'h00_00_00;
      endcase
   end
   

endmodule
