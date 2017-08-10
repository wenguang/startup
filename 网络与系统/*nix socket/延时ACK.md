### 延时ACK

为了减少网络的阻塞，TCP栈接收到数据包后不立刻回应ACK，而是会等待一段时间，如果有数据要发给对端，才会捎带着把ACK发出。延时ACK是通过Nagle算法实现的。

延迟ACK好处：

(1) 避免糊涂窗口综合症

(2) 发送数据的时候将ack捎带发送，不必单独发送ack

(3) 如果延迟时间内有多个数据段到达，那么允许协议栈发送一个ack确认多个报文段

延迟ACK坏处：数据报文的响应会有些延时



通过以下方法设置：

```c
int nodelay = 1;
socklen_t len = (socklen_t)sizeof(nodelay);
setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &nodelay, &len);
```



是否开启ACK延时要看应用的特性而定