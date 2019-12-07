/**
 * 开关模块, 一个input上升沿导通,另一个input上升沿关断
 */
module switch (
   input ON,   //上升沿触发"开"状态
   input OFF,  //上升沿触发"关"状态
   input D,    //开关入口
   output Q     //开关出口
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

endmodule