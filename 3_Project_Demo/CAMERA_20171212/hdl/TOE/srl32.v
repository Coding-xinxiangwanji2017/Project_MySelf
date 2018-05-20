module srl32
(
    //reset active low
    input                     rst_n     ,
    //glbl clk
    input                     clk       ,
    //data_in
    input        [7:0]        data_in   ,
    input                     data_valid,
    //data_out           
    output       [15:0]       sdata             
);

//reg 
reg   [31:0]buff;

always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      buff <= 32'd0;
    else  if(data_valid)
      buff <= {buff[23:0],data_in};
  end

assign sdata = buff[15:0];

endmodule
