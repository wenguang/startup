



[send或者write socket遭遇SIGPIPE信号](http://l241002209.iteye.com/blog/1506681) ：这里提到SYN、ACK、RST、FIN，需加深对TCP连接过程的理解

```tex
如果不判断read , write函数的返回值，就不知道服务器是否响应了RST, 此时客户端如果向接收了RST的套接口进行写操作时，内核给该进程发一个SIGPIPE信号。此信号的缺省行为就是终止进程，所以，进程必须捕获它以免不情愿地被终止。
对于socket的SIGPIPE信号问题，有待研究结合实践写一篇详细的文字。
```

