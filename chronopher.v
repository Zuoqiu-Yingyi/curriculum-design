/**已测试
 * 报时器
 * TODO: 每逢59分51秒、53秒、57秒时输出500Hz低音频信号，59分59秒时输出1kHz高音频信号，输出音频信号的持续时间为1秒
 */
module chronopher (
   input CP_500,        //500Hz方波
   input CP_1K,         //1KHz方波
   input[7:0] TIME_M,   //分钟输入
   input[7:0] TIME_S,   //秒输入
   output AUDIO         //蜂鸣器信号输出
);

   parameter LOW = 0;
   reg[1:0] CE = 2'b00; //00&&11:不发声 01:500Hz信号 10:1KHz信号

   always @ (TIME_M, TIME_S) begin  //条件判断
      if (TIME_M == 8'h59) begin
         case (TIME_S)
            8'h51: CE <= 2'b01;
            8'h53: CE <= 2'b01;
            8'h55: CE <= 2'b01;
            8'h57: CE <= 2'b01;
            8'h59: CE <= 2'b10;
            default: CE <= 2'b00;
         endcase
      end
      else begin
         CE <= 2'b00;
      end
   end

   assign AUDIO = CE[0] & CP_500 | CE[1] & CP_1K;  //选择输出的频率

   // always @ (TIME_S, TIME_M, CE) begin //状态转移
   //    case (CE)
   //       2'b01: AUDIO <= CP_500;
   //       2'b10: AUDIO <= CP_1K;
   //       default: AUDIO <= LOW;
   //    endcase
   // end

endmodule   //chronopher   报时器
