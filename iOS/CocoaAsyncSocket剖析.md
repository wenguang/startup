```objective-c
// BSDSocket编程常用系统文件
#import <TargetConditionals.h>
#import <arpa/inet.h>	//地址转换
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



[sys/socket.h常用注释](https://github.com/wenguang/startup/blob/master/iOS/BSD-sys:socket.h%E6%B3%A8%E9%87%8A.md)  



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



【arpa/inet.h注释】

```objective-c
///---------------------------------------------------------------------------------------------//
// 当转换ip/v4的地址时，addrBuf的长度为INET_ADDRSTRLEN
// 当转换ip/v6的地址时，addrBuf的长度为INET6_ADDRSTRLEN
char addr4Buf[INET_ADDRSTRLEN];
char addr6Buf[INET6_ADDRSTRLEN];
inet_ntop(AF_INET, &pSockaddr4->sin_addr, addr4Buf, (socklen_t)sizeof(addr4Buf)
inet_ntop(AF_INET, &pSockaddr6->sin_addr, addr6Buf, (socklen_t)sizeof(addr6Buf)

/**
  * 将网络字节序的二进制地址转换成文本字符串，af为协议簇
  * 若成功，返回地址字符串指针；若出错，返回NULL;
  */
const char	*inet_ntop(int af, const void *src, char *dst, socklen_t cnt);
          
/**
  * 用于将文本字符串格式转换成网络字节序二进制地址，af为协议簇
  * 若成功，返回1；若格式无效，返回0；若出错，返回-1;
  */
int inet_pton(int af，const char *src，void *dst)；
          
inet_ntop和inet_pton函数同时适用ip/v4和ip/v6
inet_addr、inet_aton和inet_ntoa只适用ip/v4

// 将点分十进制IP地址转换成网络字节序IP地址
// 如果正确执行将返回一个无符号长整数型数。如果传入的字符串不是一个合法的IP地址，将返回INADDR_NONE;
in_addr_t inet_addr(const char *cp);
          
// 用于将点分十进制IP地址转换成网络字节序IP地址
// 如果这个函数成功，函数的返回值非零，如果输入地址不正确则会返回零
int inet_aton(const char *string, struct in_addr *addr);

// 用于网络字节序IP转化点分十进制IP
// 若无错误发生，inet_ntoa()返回一个字符指针。否则的话，返回NULL
char *inet_ntoa (struct in_addr);
```







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