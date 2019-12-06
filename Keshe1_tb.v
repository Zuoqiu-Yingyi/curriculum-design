module Keshe1_tb;
   reg CP;
   reg CE;
   wire [7:0] D_M;

   Keshe1 k1(
      .CP_TEST(CP),
      .CE(CE),
      .D_M(D_M)
   );

   initial begin
      #0 CP = 0;
         CE = 0;
      forever begin
         #10 ;
      end
   end
endmodule