/**已测试
 * 闹铃音频发生器
 * TODO: 闹铃信号为500Hz和1kHz的方波型号，两种信号交替输出，均持续1秒
 */
module alarm_sound_generator (   //闹铃音频发生器
   input CE,         //使能信号,高电平有效
   input CP_1,       //1Hz脉冲输入
   input CP_500,     //500Hz方波输入
   input CP_1K,      //1KHz方波输入
   output AUDIO      //音频输出
);
   reg temp = 0;

   parameter LOW = 0;

   always @ (posedge CP_1) begin //状态转移条件判断
      temp <= ~temp;
   end

   assign AUDIO = CE & (temp & CP_500 | ~temp & CP_1K);

   // always @ (CP_500, CP_1K, CE, temp) begin  //状态转移
   //    if (CE) begin
   //       if (temp) begin
   //          AUDIO <= CP_500;
   //       end
   //       else begin
   //          AUDIO <= CP_1K;
   //       end
   //    end
   //    else begin
   //       AUDIO <= LOW;
   //    end
   // end

endmodule   //alarm_sound_generator 闹铃音频发生器