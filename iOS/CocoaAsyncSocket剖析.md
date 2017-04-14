```objective-c
// CocoaAsyncSocket用到系统文件
#import <TargetConditionals.h>
#import <arpa/inet.h>
#import <fcntl.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <netinet/in.h>
#import <net/if.h>
#import <sys/socket.h>
#import <sys/types.h>
#import <sys/ioctl.h>
#import <sys/poll.h>
#import <sys/uio.h>
#import <sys/un.h>
#import <unistd.h>
```





【BSD Socket知识】

```c
// socket4FD，FD（file descriptor），在BSD socket中socket句柄被当作文件，对socket的读写相当对文件读写
int socket4FD;
int socket6FD;
int socketUN;
```



【地址相关的struct】

```objective-c
// <sys/socket.h>
struct sockaddr {
	__uint8_t	sa_len;		/* total length */
	sa_family_t	sa_family;	/* [XSI] address family */
	char		sa_data[14];	/* [XSI] addr value (actually larger) */
};
// <netinet/in.h>
struct sockaddr_in {
	__uint8_t	sin_len;
	sa_family_t	sin_family;
	in_port_t	sin_port;
	struct	in_addr sin_addr;
	char		sin_zero[8];
};
// <netinet6/in6.h>
struct sockaddr_in6 {
	__uint8_t	sin6_len;	/* length of this struct(sa_family_t) */
	sa_family_t	sin6_family;	/* AF_INET6 (sa_family_t) */
	in_port_t	sin6_port;	/* Transport layer port # (in_port_t) */
	__uint32_t	sin6_flowinfo;	/* IP6 flow information */
	struct in6_addr	sin6_addr;	/* IP6 address */
	__uint32_t	sin6_scope_id;	/* scope zone index */
};
// <sys/un.h>
struct	sockaddr_un {
	unsigned char	sun_len;	/* sockaddr len including null */
	sa_family_t	sun_family;	/* [XSI] AF_UNIX */
	char		sun_path[104];	/* [XSI] path name (gag) */
};
```





【sys/socket.h注释】



【sys/fnctl.h注释】

```objective-c
///---------------------------------------------------------------------------------------------//
/// 把socket的句柄(文件描述符)状态标志设置为非延迟
/// 就是把socket设置为非阻塞式，这是socket编程常用到的函数
status = fcntl(socketFD, F_SETFL, O_NONBLOCK);

/**
  * 操作文件描述词的一些特性
  *
  * @param fd 文件描述符，socketFD即socket句柄，也是个文件描述符，上面讲过
  * @param cmd 操作命令，如：F_SETFL，详见：fnctl.h
  * @param arg 如：O_NONBLOCK，表示非延迟，详见：fnctl.h
  * 
  * 参数详细参考：http://c.biancheng.net/cpp/html/233.html
  *
  * @return 成功则返回0, 若有错误则返回-1
  */
int fcntl(int fd, int cmd, long arg);
```





【GCD知识】

```objective-c
// 保证代码在指定的queue执行，设置这个标识
// 指定队列里面设置一个标识
dispatch_queue_set_specific(dispatch_queue_t queue, const void *key,
	void *_Nullable context, dispatch_function_t _Nullable destructor);

// 获取queue标识
dispatch_queue_get_specific(dispatch_queue_t queue, const void *key);
// 获取当前queue标识
dispatch_get_specific(const void *key);



// 
readTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, socketQueue);
dispatch_source_set_event_handler(readTimer ^{});
dispatch_source_set_cancel_handler(readTimer, ^{});
dispatch_source_set_timer(readTimer, tt, DISPATCH_TIME_FOREVER, 0);
```



[C语言标准函数库说明](http://c.biancheng.net/cpp/u/hanshu/) （有些函数和特定系统有些出入）

[Linux socket 编程入门](http://cw.hubwiz.com/card/c/56f9ee765fd193d76fcc6c17/1/1/1/) （和 BSD socket编程有共通处）

[有关send()，recv()函数的理解](http://www.cnblogs.com/aixingfou/archive/2011/07/29/2120956.html)]（阻塞和非阻塞模式下，缓冲区大小、异常关闭等情况下的理解）



【socket SIGPIPE错误处理 参考】 

 [Avoiding Common Networking Mistakes](https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/CommonPitfalls/CommonPitfalls.html) 

[send或者write socket遭遇SIGPIPE信号](http://l241002209.iteye.com/blog/1506681) ：这里提到SYN、ACK、RST、FIN，需加深对TCP连接过程的理解