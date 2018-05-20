np811_console_data.txt-----维护数据
维护数据下发两包。

np811_flash_data.txt-----flash下装，
flash需要下装314K字节，需要发送314k/128=2512包

np811_fram_data.txt-----fram下装文
fram需要下装31k字节，需要发送31k/128=248包

发送时每次从文件中读取连续的138字节数据写入发送缓冲区，并给出发送使能和发送数据长度138