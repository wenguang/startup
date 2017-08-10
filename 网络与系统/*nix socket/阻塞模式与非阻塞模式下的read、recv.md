### 阻塞模式与非阻塞模式下的read、recv

```c
/*
解阻塞与非阻塞recv返回值没有区分，都是
<0 出错
=0 连接关闭
>0 接收到数据大小
特别：返回值<0时并且(errno == EINTR || errno == EWOULDBLOCK || errno == EAGAIN)的情况下认为连接是正常的，继续接收。
只是阻塞模式下recv会阻塞着接收数据，非阻塞模式下如果没有数据会返回，不会阻塞着读，因此需要循环读取）。

失败返回-1，errno被设为以下的某个值
EAGAIN：套接字已标记为非阻塞，而接收操作被阻塞或者接收超时
EBADF：sock不是有效的描述词
ECONNREFUSE：远程主机阻绝网络连接
EFAULT：内存空间访问出错
EINTR：操作被信号中断
EINVAL：参数无效
ENOMEM：内存不足
ENOTCONN：与面向连接关联的套接字尚未被连接上
ENOTSOCK：sock索引的不是套接字
*/
ssize_t recv(int sockfd, void *buf, size_t nbytes, int flags);

/*
返回值
>=0: copy到发送缓冲区的数据
-1: 出错，非阻塞模式下，errno为EAGAIN或EWOULDBLOCK时，表示发送缓冲区已满

错误代码：
   EBADF 参数s 非合法的socket 处理代码.
   EFAULT 参数中有一指针指向无法存取的内存空间
   ENOTSOCK 参数s 为一文件描述词, 非socket.
   EINTR 被信号所中断.
   EAGAIN 此操作会令进程阻断, 但参数s 的socket 为不可阻断.
   ENOBUFS 系统的缓冲内存不足
   ENOMEM 核心内存不足
   EINVAL 传给系统调用的参数不正确.
*/
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



**阻塞模式下recv** 

**非阻塞模式下recv** 



[有关send()，recv()函数的理解](http://www.cnblogs.com/aixingfou/archive/2011/07/29/2120956.html) 

[linux recv返回值与linux socket错误分析](http://www.cnblogs.com/yunsicai/p/3514160.html) 