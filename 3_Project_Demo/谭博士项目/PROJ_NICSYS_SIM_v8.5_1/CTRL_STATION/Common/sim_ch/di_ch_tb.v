`timescale 1ns/1ps

module di_channel_feedback_tb(
                             din       ,
                             test_open ,
                             test_close
                             );
output reg    din            ;
input         test_open      ;
input         test_close     ;

//input
reg           clk            ;
reg           in             ; 
reg           temp           ;
integer i;
parameter clk_cycle = 5'd20;

initial
begin
  clk = 0;
  forever
    begin
    #(clk_cycle/2) clk = ~clk;
    end
end
initial begin   
    in          = 0  ;
    temp        = 0  ;
    #(100*clk_cycle) 
    for(i=0;i<10;i = i+1)begin
      temp = ~temp;
      repeat(99) begin 
		//  @(posedge clk)
        in = {$random}%2;
        #(5000*clk_cycle);
		end
   in = temp;
    #(5000000*clk_cycle);
	 end
	 #(1000*clk_cycle)	
	 in = 0;
	 #(60000000*clk_cycle);//50000000*clk_cycle=1min
	 in = 1;
   #(60000000*clk_cycle);//50000000*clk_cycle=1min 
	 in = 0; 
end

always @ (in or test_close or test_open) begin
 case({in,test_close,test_open})
  //  3'bx00: in <= ;//wrong
	 3'b011: din <= 1; //com
	 3'b111: din <= 0; //com
	 3'b001: din <= 0; //feedback_close   close if right change 1-0-1
	 3'b101: din <= 0; //no change
	 3'b010: din <= 1; //feedback_open  no change
	 3'b110: din <= 1; // change	 0-1-0
	 default: begin
	          din <= in;
	          $display("no allow action");
				 end
endcase
end

endmodule 