 clear
 clc
 format long
 mem_size = 8;%8MB
 flash_data=(zeros(1,mem_size*1024*1024));
 np811_type = 16;
 falsh_rev  = [1 0 1 0];
 AI = [80 4 12]';
 DI = [64 2 32]';
 AO = [112 2 8]';
 DO = [96  1 16]';
 CRC_fix =zeros(1,4);
 %%
 board_num  = 4;
 board_I_ID  =  [25 26]; 
 board_I_config = [AI DI ];
 board_O_ID  =  [27 28];
 board_O_config = [AO DO];
 console_mid_length = 10;
 %%
 
 board =cat(2,board_I_config,board_O_config);
 ID=cat(2,board_I_ID,board_O_ID);
  console_in_length = 1024*2+sum(board_I_config(2,1:end).*board_I_config(3,1:end))*2 + 6;%6 = 2 length + 4 crc32
  console_in_addr  =   0;
  console_out_length = sum(board_O_config(2,1:end).*board_O_config(3,1:end))*2 + 6;%6 = 2 length + 4 crc32
  console_out_addr  =  console_in_length + console_in_addr;
  console_var_length = console_mid_length + 6;%6 = 2 length + 4 crc32
  console_var_addr  =  console_out_length + console_out_addr;
 console =...
 [
ceil(console_in_length/128)-16 ...
console_in_addr ...
ceil(console_out_length/128) ...%6 = 2 length + 4 crc32
console_in_length + console_in_addr ...
ceil((console_mid_length + 6)/128) ...
console_out_length + console_out_addr ...
0 ...
]; 
CRC_console_in =zeros(1,4);

xfer_in_addr =1088;
xfer_in_length = 6*(sum(board_I_config(3,1:end)));
xfer_out_addr =xfer_in_length +xfer_in_addr +4;
xfer_out_length = 6*(sum(board_O_config(3,1:end)));
xfer_net_addr = xfer_out_length + xfer_out_addr +4;
xfer_net_length =0;
xfer =...
    [...
    xfer_in_length ...
    xfer_in_addr ...
    xfer_out_length ...
    xfer_out_addr ...
    xfer_net_length ...
    xfer_net_addr ...
    0 ...
    ];
CRC_console_out =zeros(1,4);
%%

xfer_in = zeros(4,sum(board_I_config(3,1:end)));
    temp = 2;
array_length = size(board_I_config);
   AA=0;
for i=1:array_length(1,2)
    for j=1:board_I_config(3,i);
    xfer_in(1,AA+j) = board_I_config(2,i)-1;
    xfer_in(2,AA+j) = (board_I_ID(i)-25)*64 +768;
    xfer_in(3,AA+j) = 96+board_I_config(2,i)-1;
    xfer_in(4,AA+j) = temp;
    temp=temp+board_I_config(2,i);
    end
    AA=AA+j;
end
CRC_xfer_in =zeros(1,4);

xfer_out= zeros(4,sum(board_O_config(3,1:end)));
    temp = temp+6;
array_length = size(board_O_config);
    AA=0;
for i=1:array_length(1,2)
    for j=1:board_O_config(3,i);
    xfer_in(1,AA+j) = board_O_config(2,i)-1+112;
    xfer_in(2,AA+j) = temp;
    xfer_in(3,AA+j) = 16+board_O_config(2,i)-1;
    xfer_in(4,AA+j) = (board_O_ID(i)-25)*16+ 768;
    temp=temp+board_O_config(2,i);
    end   
    AA=AA+j;
end
CRC_xfer_out =zeros(1,4);
%%
flash_data(1,1)=np811_type;
flash_data(1,5:8)=falsh_rev;
flash_data(1,1021:1024)=CRC_fix;
for i=1:7
    flash_data(1,1025+(i-1)*4:1025+i*4-1)=[bitand(console(1,i),61440)/2096 bitand(console(1,i),3840)/256 bitand(console(1,i),240)/16 bitand(console(1,i),15)];
end
flash_data(1053:1056)= CRC_console_in;
for i=1:7
    flash_data(1,1057+(i-1)*4:1057+i*4-1)=[bitand(xfer(1,i),61440)/2096 bitand(xfer(1,i),3840)/256 bitand(xfer(1,i),240)/16 bitand(xfer(1,i),15)];
end
flash_data(1,1085:1088)= CRC_console_out;
% % % % % 
for i=1:sum(board_I_config(3,1:end))
    flash_data(1,1089+(i-1)*6:1089+i*6-1)=[bitand(xfer_in(1,i),15) bitand(xfer_in(2,i),240)/16 bitand(xfer_in(2,i),15) bitand(xfer_in(3,i),15) bitand(xfer_in(4,i),240)/16 bitand(xfer_in(4,i),15)];
end
flash_data(1,1089+sum(board_I_config(3,1:end))*6:1089+sum(board_I_config(3,1:end))*6+3)= CRC_xfer_in;
% % % % 
for i=1:sum(board_O_config(3,1:end))
    flash_data(1,1089+sum(board_I_config(3,1:end))*6+4+(i-1)*6:1089+sum(board_I_config(3,1:end))*6+4+i*6-1)=...
    [bitand(xfer_out(1,i),15) bitand(xfer_out(2,i),240)/16 bitand(xfer_out(2,i),15) bitand(xfer_out(3,i),15) bitand(xfer_out(4,i),240)/16 bitand(xfer_out(4,i),15)];
end
flash_data(1,1089+sum(board_I_config(3,1:end))*6+4+sum(board_O_config(3,1:end))*6:1089+sum(board_I_config(3,1:end))*6+4+sum(board_O_config(3,1:end))*6+3)= CRC_xfer_out;
for i=1:board_num
    flash_data(1,320513+(i-1)*4:320513+i*4-1)=[1 board(1,i) ID(i) 0];
end
CRC_ID=[0 0 0 0];
flash_data =uint8(flash_data);
%%
m_bus_data=zeros(1,mem_size*1024*1024/128*142);
for i=1:mem_size*1024*1024/128
    m_bus_data((i-1)*142+1:i*142) = [0 254 96 2 1 mod(i,256)  bitand((i-1)*128,15) bitand((i-1)*128,240)/16 bitand((i-1)*128,3840)/256 np811_type flash_data(1,(i-1)*128+1:i*128) 255 255 255 255];
end
% % % % % % 
% g=[1 0 0 1 1];
% R=length(g)-1;
% [q,r]=deconv([a(1:100) zeros(1,R)],g);
% r=mod(r(end-R+1:end),2);
% a=uint8(a);
% % % % % % % % 
fid = fopen('d:\np811_flash_data.txt','w');
fprintf(fid, '%X\n',m_bus_data );
fclose(fid);
%%
 a=(zeros(1,31744));
 a(1171:1186)=[0.0 0 12 32 15 64 160 32 195  64  80 32 01 16 4 16];
a=uint8(a);
m_bus_data=zeros(1,248*142);
for i=1:248
    m_bus_data((i-1)*142+1:i*142) = [0 254 96 2 1 mod(i,256) bitand((i-1)*128,15) bitand((i-1)*128,240)/16 bitand((i-1)*128,3840)/256 np811_type a(1,(i-1)*128+1:i*128) 255 255 255 255];
end
fid = fopen('d:\np811_fram_data.txt','w');
fprintf(fid, '%X\n',m_bus_data );
fclose(fid);
%%
a=(zeros(1,128));
a(9)=1;
a(10)=1*16+1;%写入
a(11)=4;
a(12)=1*16+2;% 模式切换时接续 强制
a(13)=8;
a(14)=1*16+3;%强制 模式切换时释放 
a(15)=16;
a(16)=1*16+4;%保存
a=uint8(a);
m_bus_data=[0 254 96 2 1 1 bitand(2048,15) bitand(2048,240)/16 bitand(2048,3840)/256 np811_type a 255 255 255 255];

fid = fopen('d:\np811_console_data.txt','w');
fprintf(fid, '%X\n',m_bus_data );
fclose(fid);