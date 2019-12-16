/* 方波产生器 */
module square_wave_generator (
   input CP,         //脉冲输入
   output reg SQW    //方波输出
);
   initial SQW = 0;

   always @ (posedge CP) begin
      SQW <= ~SQW;
   end

endmodule   //square_wave_generator 方波产生器