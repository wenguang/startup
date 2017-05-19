**epoll之所有优秀的原理及实现请多多阅读：[【Linux学习】epoll详解](http://blog.csdn.net/xiajun07061225/article/details/9250579) ** 

\<sys/epoll.h\> 

**struct epoll_event结构** 

```c
//保存触发事件的某个文件描述符相关的数据（与具体使用方式有关）  
  
typedef union epoll_data {  
    void *ptr;  
    int fd;  
    __uint32_t u32;  
    __uint64_t u64;  
} epoll_data_t;  
 //感兴趣的事件和被触发的事件  
struct epoll_event {  
    __uint32_t events; /* Epoll events */  
    epoll_data_t data; /* User data variable */  
};  
```

events可以是以下几个宏的集合：

- EPOLLIN ：表示对应的文件描述符可以读（包括对端SOCKET正常关闭）；
- EPOLLOUT：表示对应的文件描述符可以写；
- EPOLLPRI：表示对应的文件描述符有紧急的数据可读（这里应该表示有带外数据到来）；
- EPOLLERR：表示对应的文件描述符发生错误；
- EPOLLHUP：表示对应的文件描述符被挂断；
- EPOLLET： 将EPOLL设为边缘触发(Edge Triggered)模式，这是相对于水平触发(Level Triggered)来说的。
- EPOLLONESHOT：只监听一次事件，当监听完这次事件之后，如果还需要继续监听这个socket的话，需要再次把这个socket加入到EPOLL队列里



**epoll只有epoll_create,epoll_ctl,epoll_wait 3个系统调用** 

**1. int epoll_create(int size);** 

创建一个epoll的句柄。自从linux2.6.8之后，size参数是被忽略的。需要注意的是，当创建好epoll句柄后，它就是会占用一个fd值，在linux下如果查看/proc/进程id/fd/，是能够看到这个fd的，所以在使用完epoll后，必须调用close()关闭，否则可能导致fd被耗尽。

**2. int epoll_ctl(int epfd, int op, int fd, struct epoll_event \*event);** 

epoll的**事件注册函数**，它不同于select()是在监听事件时告诉内核要监听什么类型的事件，而是在这里先注册要监听的事件类型。

第一个参数是epoll_create()的返回值。

第二个参数表示动作，用三个宏来表示：

* EPOLL_CTL_ADD：注册新的fd到epfd中；
* EPOLL_CTL_MOD：修改已经注册的fd的监听事件；
* EPOLL_CTL_DEL：从epfd中删除一个fd； 

第三个参数是需要监听的fd。

第四个参数是告诉内核需要监听什么事

**3. int epoll_wait(int epfd, struct epoll_event \* events, int maxevents, int timeout);**

收集在epoll监控的事件中已经发送的事件。参数events是分配好的epoll_event结构体数组，epoll将会把发生的事件赋值到events数组中（events不可以是空指针，内核只负责把数据复制到这个events数组中，不会去帮助我们在用户态中分配内存）。maxevents告之内核这个events有多大，这个 maxevents的值不能大于创建epoll_create()时的size，参数timeout是超时时间（毫秒，0会立即返回，-1将不确定，也有说法说是永久阻塞）。如果函数调用成功，返回对应I/O上已准备好的文件描述符数目，如返回0表示已超时。



**Epoll的2种工作方式-水平触发（LT）和边缘触发（ET）** 

**LT(level triggered)是epoll缺省的工作方式**，并且同时支持block和no-block socket.在这种做法中，内核告诉你一个文件描述符是否就绪了，然后你可以对这个就绪的fd进行IO操作。如果你不作任何操作，内核还是会继续通知你 的，所以，这种模式编程出错误可能性要小一点。传统的select/poll都是这种模型的代表．

**ET (edge-triggered)是高速工作方式**，只支持no-block socket，它效率要比LT更高。ET与LT的区别在于，当一个新的事件到来时，ET模式下当然可以从epoll_wait调用中获取到这个事件，可是如果这次没有把这个事件对应的套接字缓冲区处理完，在这个套接字中没有新的事件再次到来时，在ET模式下是无法再次从epoll_wait调用中获取这个事件的。而LT模式正好相反，只要一个事件对应的套接字缓冲区还有数据，就总能从epoll_wait中获取这个事件。

因此，LT模式下开发基于epoll的应用要简单些，不太容易出错。而在ET模式下事件发生时，如果没有彻底地将缓冲区数据处理完，则会导致缓冲区中的用户请求得不到响应。

**Nginx默认采用ET模式来使用epoll** 



**epoll的优点** 

* **支持一个进程打开大数目的socket描述符(FD)** 
* **IO效率不随FD数目增加而线性下降** 
* **使用mmap加速内核与用户空间的消息传递** 
* **内核微调（这是linux的优点）**



**epoll比select/poll的优越之处：**因为后者每次调用时都要传递你所要监控的所有socket给select/poll系统调用，这意味着需要将用户态的socket列表copy到内核态，如果以万计的句柄会导致每次都要copy几十几百KB的内存到内核态，非常低效。而我们调用epoll_wait时就相当于以往调用select/poll，但是这时却不用传递socket句柄给内核，因为内核已经在epoll_ctl中拿到了要监控的句柄列表。



**epoll之所有优秀的原理及实现请多多阅读：[【Linux学习】epoll详解](http://blog.csdn.net/xiajun07061225/article/details/9250579) ** 