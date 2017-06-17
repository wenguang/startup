### 阻塞模式与非阻塞模式下的read、recv

```c
ssize_t recv(int sockfd, void *buf, size_t nbytes, int flags);
ssize_t send(int sockfd, const void *buf, size_t nbytes, int flags);
```

flags参数说明

| flags         | 说明                  | recv | send |
| ------------- | ------------------- | ---- | ---- |
| MSG_DONTROUTE | 告知目标地址是本地地址，不用去查路由表 |      | •    |
| MSG_DONTWAIT  | 仅限本次操作为非阻塞          | •    | •    |
| MSG_OOB       | 发送或接收带外数据           | •    | •    |
| MSG_PEEK      | 窥看外来消息              | •    |      |
| MSG_WAITALL   | 等待所有数据              | •    |      |



**send仅仅是把数据copy到socket的发送缓冲区中，真正的发送数据的工作是内核协议栈来完成的；recv仅仅是把socket的接收缓冲区的数据copy到buf，真正的接收数据的工作也是内核协议栈完成的**。

发送缓冲区大小：3个值分别是最小值、默认值、最大值

> [root@localhost ~]# cat /proc/sys/net/ipv4/tcp_wmem
>
> 4096	16384	4194304

接收缓冲区大小：3个值分别是最小值、默认值、最大值

> [root@localhost ~]# cat /proc/sys/net/ipv4/tcp_rmem
>
> 4096	87380	6291456



**阻塞模式下send** 

1、发送缓冲区空间 >= 待copy的数据量，send把数据copy到缓冲区后，函数返回。

2、发送缓冲区空间 < 待copy的数据量，send把数据缓冲区copy满，send阻塞，协议一边传数据，发送缓冲区有空间后send继续copy数据，待数据全部copy完，函数返回。

**非阻塞模式下send** 

1、发送缓冲区有空间，只计算待copy数据量与缓冲区大小，立即返回可copy的大小，而不是copy完成数据才返回，这点要注意。

2、发送缓冲区已满，返回-1，errno为EAGAIN或EWOULDBLOCK



[有关send()，recv()函数的理解](http://www.cnblogs.com/aixingfou/archive/2011/07/29/2120956.html) 