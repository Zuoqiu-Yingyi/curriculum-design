/**
 * 开关模块, 一个input上升沿导通,另一个input上升沿关断
 */
module switch (   //开关模块
   input ON,   //上升沿触发"开"状态
   input OFF,  //上升沿触发"关"状态
   input D,    //信号输入
   output Q    //信号输出
);

   reg state = 0;

   always @ (posedge ON, posedge OFF) begin
      if (OFF) begin
         state <= 1'b0;
      end
      else begin
         state <= 1'b1;
      end
   end

   assign Q = state & D;

endmodule   //switch 开关模块