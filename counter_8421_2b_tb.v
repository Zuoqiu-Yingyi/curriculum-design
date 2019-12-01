module counter_8421_2b_tb;   //模9可逆同步置数异步清零计数器
   reg CE;        //使能信号,高电平有效,低电平时计数器状态保持不变
   reg CR;      	//异步清零端,高电平有效
   reg PE;       	//同步置数端,高电平有效
   reg UP;        //正计数端,高电平有效
   reg CP;        //时钟信号
   reg [7:0] D;   //并行预置数据输入端
	reg [7:0] MAX;	//最大值
	
   wire [7:0] Q;  //计数输出端
   wire TC;       //进位输出端


   counter_8421_2b C1 (	.CP(CP), 
								.CE(CE), 
								.PE(PE), 
								.UP(UP),
								.CR(CR),
								.D(D), 
								.MAX(MAX),
								.Q(Q), 
								.TC(TC)
	);

   initial begin
      forever begin
         #10 CP = ~CP;
         #10 CP = ~CP;
      end

   end

   initial begin
      /* 初始化 */
		PE = 0;
		CP = 0;
		CE = 1;
		UP = 1;
		CR = 0;
		MAX = 8'b0100_0000;
		D = 8'b0000_0101;
		forever begin
			#180 PE = 1;
			#20	PE = 0;
		end
		// $stop ; 
   end

   
endmodule // M9_counter_tb 