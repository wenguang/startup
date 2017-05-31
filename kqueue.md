kqueue是FreeBSD、MacOS的多路复用机制，定义在头文件\<sys/event.h\>中。

kqueue 支持多种类型的文件描述符，包括 socket、信号、定时器、AIO、VNODE、PIPE。

kqueue只有1个结构和2个重要函数：kqueue()、struct kevent、kevent()

```c
 struct kevent { 
     uintptr_t ident;        /* 事件 ID 一般是文件描述符*/ 
     short     filter;       /* 事件过滤器 */ 
     u_short   flags;        /* 行为标识 */ 
     u_int     fflags;       /* 过滤器标识值 */ 
     intptr_t  data;         /* 过滤器数据 */ 
     void      *udata;       /* 应用透传数据 */ 
 }; 
在一个 kqueue 中，{ident, filter} 确定一个唯一的事件。
```



- `ident`事件的 id，实际应用中，一般设置为文件描述符。

- `filter` 

  可以将 kqueue filter 看作事件。内核检测 ident 上注册的 filter 的状态，状态发生了变化，就通知应用程序。kqueue 定义了较多的 filter，本文只介绍 Socket 读写相关的 filter。
  - EVFILT_READ

    TCP 监听 socket，如果在完成的连接队列 ( 已收三次握手最后一个 ACK) 中有数据，此事件将被通知。收到该通知的应用一般调用 accept()，且可通过 data 获得完成队列的节点个数。 流或数据报 socket，当协议栈的 socket 层接收缓冲区有数据时，该事件会被通知，并且 data 被设置成可读数据的字节数。

  - EVFILT_WRIT

    当 socket 层的写入缓冲区可写入时，该事件将被通知；data 指示目前缓冲区有多少字节空闲空间。


- `flags`EV_ADD指示加入事件到 kqueue。
  - EV_DELETE

    指示将传入的事件从 kqueue 中移除。

  - EV_ENABLE

    过滤器事件可用，注册一个事件时，默认是可用的。

  - EV_DISABLE

    过滤器事件不可用，当内部描述可读或可写时，将不通知应用程序。第 5 小节有这个 flag 的用法介绍。

  - EV_ERROR

    一个输出参数，当 changelist 中对应的描述符处理出错时，将输出这个 flag。应用程序要判断这个 flag，否则可能出现 kevent 不断地提示某个描述符出错，却没将这个描述符从 kq 中清除。处理 EV_ERROR 类似下面的代码： if (events[i].flags & EV_ERROR) close(events[i].ident); fflags 过滤器相关的一个输入输出类型标识，有时候和 data 结合使用。


- `data` 

  过滤器相关的数据值，请看 EVFILT_READ 和 EVFILT_WRITE 描述。


- `udata` 

  应用自定义数据，注册的时候传给 kernel，kernel 不会改变此数据，当有事件通知时，此数据会跟着返回给应用。



struct kevent 的初始化的辅助操作：EV_SET

```c
 EV_SET(&kev, ident, filter, flags, fflags, data, udata);
 
 struct kevent ke;
 EV_SET(&ke, fd, EVFILT_READ, EV_DELETE, 0, 0, NULL);
```





```c
int kqueue(void)
```

生成一个内核事件队列，返回该队列的文件描述索。其它 API 通过该描述符操作这个 kqueue。生成的多个 kqueue 的结构类



```c
int kevent(int kq, 							//kqueue结构的文件描述符
	       const struct kevent *changelist,   //要注册 / 反注册的事件数组
           int nchanges,					//changelist 的元素个数
	       struct kevent *eventlist, 		 //满足条件的通知事件数组
           int nevents,						//eventlist 的元素个数
	       const struct timespec *timeout);   //timeout: 等待事件到来时的超时时间，0，立刻返回；NULL，一直等待；有一个具体值，等待 timespec 时间值

//返回值：可用事件的个数
```







参考：[使用 kqueue 在 FreeBSD 上开发高性能应用服务器](https://www.ibm.com/developerworks/cn/aix/library/1105_huangrg_kqueue/) 

​           Unix网络编程卷1—14.9.2章节 kqueue接口