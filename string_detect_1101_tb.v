module string_detect_1101_tb;
   reg CP;
   reg RST;
   reg D;
   wire Q;
   wire nest_Q;
   wire [1:0] cruuent_status;
   wire [1:0] nest_status;
   
   string_detect_1101 S1 (
      .CP(CP),
      .RST(RST),
      .D(D),
      .Q(Q),
      .nest_Q(nest_Q),
      .cruuent_status(cruuent_status),
      .nest_status(nest_status)
   );

   initial begin
      forever begin
         #10 CP = ~CP;
         #10 CP = ~CP;
      end
   end

   initial begin
      /* 初始化 */
		CP = 0;
      RST = 0;
      #5 D = 0;
      /* 110110110110 */
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;

      /* 1110 1110 1110 1110 */
      #20 D = 1;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;

      /* 10110 10110 10110 10110 */
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 0;
      #20 D = 1;
      #20 D = 1;
      #20 D = 0;
		$stop ; 
   end

endmodule