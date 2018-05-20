`timescale 1ns/1ps

module do_channel_feedback_tb( 
fp_channel    ,
fd_channel    ,//1'b0

din_feedback  ,

);
 
input          fp_channel    ;
input          fd_channel    ;

output  reg    din_feedback  ;   



always @ (fd_channel or fp_channel) begin
  case({fd_channel,fp_channel})
  //  2'bx00: in <= ;//wrong
	 2'b00: #10 din_feedback = 0; //com
	 2'b01: #10 din_feedback = 1; //com
	 2'b11: #10 din_feedback = 1; //com
	 2'b10: #10 din_feedback = 1; //com
  endcase
end

endmodule 