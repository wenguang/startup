#### CLOSE-WAIT问题

用netstat -at命令查看tcp端口，发现很多端口处于**CLOSE-WAIT**状态：

```shell
tcp        2      0 localhost:etlservicemgr 192.168.1.103:49182     CLOSE_WAIT 
tcp        3      0 localhost:etlservicemgr 192.168.1.103:65455     CLOSE_WAIT 
tcp        2      0 localhost:etlservicemgr 192.168.1.103:65339     CLOSE_WAIT 
tcp        1      0 localhost:etlservicemgr 192.168.1.103:65154     CLOSE_WAIT 
tcp        4      0 localhost:etlservicemgr 192.168.1.103:65499     CLOSE_WAIT 
tcp        2      0 localhost:etlservicemgr 192.168.1.103:65336     CLOSE_WAIT 
tcp        1      0 localhost:etlservicemgr 192.168.1.103:63172     CLOSE_WAIT 
tcp        1      0 localhost:etlservicemgr 192.168.1.103:65139     CLOSE_WAIT 
```

用wireshark抓包发现客户端close函数后，也只有4次挥手的中的2次：【FIN, ACK】和【ACK】，这时服务端处于**CLOSE-WAIT**状态，**原因是服务端没有调用close函数关掉通信链路，大量端口长期处于CLOSE-WAIT状态会使服务器Down掉。所以，服务端应该在客户端发出close请求或客户端超时时close掉链路**。 

若是服务端先主动调用了close函数，那CLOSE_WAIT状态就会出现在客户端。