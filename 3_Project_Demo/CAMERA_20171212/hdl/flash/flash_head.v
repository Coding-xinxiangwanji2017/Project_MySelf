/////////////////////
`define idle  	3'd0
`define erase   3'd1
`define write  	3'd2
`define lock  	3'd3
`define unlock 	3'd4
`define read  	3'd5

/////clk 10ns ///////
`define tRST   16  //   min 150ns
`define tVLVH  1   //   min 7ns   
`define tWLWH  5	 //   min 40ns
`define tDVWH  5   //   min 40ns
`define tWHWL  3	 //   min 20ns
`define tWHEL  1   //   min 9ns
`define tVLVHC 2   //   min 2CLK  
`define tEHEL  1   //   min 7ns 
`define tAVQV  10  //   max 96ns  

`define nBLOCK 33  //   33 block