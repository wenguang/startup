**I/O复用** 

```objective-c
struct pollfd pfd[1];
pfd[0].fd = socketFD;
pfd[0].events = POLLOUT;
pfd[0].revents = 0;

poll(pfd, 1, 0);

/**
fd：每一个 pollfd 结构体指定了一个被监视的文件描述符，可以传递多个结构体，指示 poll() 监视多个文件描述符。
events：指定监测fd的事件（输入、输出、错误），每一个事件有多个取值
revents：revents 域是文件描述符的操作结果事件，内核在调用返回时设置这个域。events 域中请求的任何事件都可能在 revents 域中返回.
注意：每个结构体的 events 域是由用户来设置，告诉内核我们关注的是什么，而 revents 域是返回时内核设置的，以说明对该描述符发生了什么事件
*/
struct pollfd
{
    int     fd;	
    short   events;
    short   revents;
};
typedef unsigned int nfds_t;


/**
监视并等待多个文件描述符的属性变化
@param fds:指向一个结构体数组的第0个元素的指针，每个数组元素都是一个struct pollfd结构，用于指定测试某个给定的fd的条件
@param nfds:用来指定第一个参数数组元素个数
@param timeout: 指定等待的毫秒数，无论 I/O 是否准备好，poll() 都会返回
	-1：永远等待，0：立即返回，>0：等待指定数目的毫秒数

成功时，poll() 返回结构体中 revents 域不为 0 的文件描述符个数；如果在超时前没有任何事件发生，poll()返回 0；失败时，poll() 返回 -1 并设置 errno 为下列值之一：
EBADF：一个或多个结构体中指定的文件描述符无效。
EFAULT：fds 指针指向的地址超出进程的地址空间。
EINTR：请求的事件之前产生一个信号，调用可以重新发起。
EINVAL：nfds 参数超出 PLIMIT_NOFILE 值。
ENOMEM：可用内存不足，无法完成请求。
*/
int poll(struct pollfd *fds, nfds_t nfds, int timeout); 


```



**pollfd中的events和revents可设置的值：这些常量也都定义在sys/poll.h中** 

![](https://github.com/wenguang/startup/blob/master/BSDSocket%E7%BC%96%E7%A8%8B/pollfd-event.png?raw=true)





参考：[I/O复用之poll函数](http://blog.csdn.net/lianghe_work/article/details/46534029) 

