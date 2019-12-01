module square_wave_generator (   //方波发生器
   input CP,         //时间脉冲
   output reg SQW    //方波输出
);
   initial SQW = 0;

   always @ (posedge CP) begin
      SQW <= ~SQW;
   end

endmodule