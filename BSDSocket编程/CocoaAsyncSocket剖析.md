```objective-c
// BSDSocket编程常用系统文件
#import <TargetConditionals.h>
#import <arpa/inet.h>	//地址转换
#import <fcntl.h>	//文件描述符操作
#import <ifaddrs.h>	//获取网卡ip和mac地址
#import <netdb.h>	//域名、地址和协议相关
#import <netinet/in.h>
#import <net/if.h>
#import <sys/socket.h>
#import <sys/types.h>
#import <sys/ioctl.h>	//I/O通道管理
#import <sys/poll.h>
#import <sys/uio.h>
#import <sys/un.h>
#import <unistd.h>
```



[sys/socket.h常用注释](https://github.com/wenguang/startup/blob/master/BSDSocket%E7%BC%96%E7%A8%8B/BSD-sys:socket.h%E6%B3%A8%E9%87%8A.md)  

[arpa/inet.h常用注释](https://github.com/wenguang/startup/blob/master/BSDSocket%E7%BC%96%E7%A8%8B/BSD-arpa:inet.h%E6%B3%A8%E9%87%8A.md) 

[sys/fnctl.h常用注释](https://github.com/wenguang/startup/blob/master/BSDSocket%E7%BC%96%E7%A8%8B/BSD-sys:fnctl.h%E6%B3%A8%E9%87%8A.md) 







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
// <netdb.h>
struct addrinfo {
	int	ai_flags;	/* AI_PASSIVE, AI_CANONNAME, AI_NUMERICHOST */
	int	ai_family;	/* PF_xxx */
	int	ai_socktype;	/* SOCK_xxx */
	int	ai_protocol;	/* 0 or IPPROTO_xxx for IPv4 and IPv6 */
	socklen_t ai_addrlen;	/* length of ai_addr */
	char	*ai_canonname;	/* canonical name for hostname */
	struct	sockaddr *ai_addr;	/* binary address */
	struct	addrinfo *ai_next;	/* next structure in linked list */
};
// ai_flags可取的值
AI_ADDRCONFIG		//查询配置的地址类型(IPv4或IPv6)
AI_ALL				//查找IPv4和IPv6
AI_CANONNAME		//需要一个规范名
AI_NUMERICHOST		//以数字格式返回主机地址
AI_NUMERICSERV		//以端口号返回服务
AI_PASSIVE			//套接字地址用于监听绑定
AI_V4MAPPED			//如果没有找到IPv4地址，则返回映射到IPv6格式

// <ifaddrs.h>
struct ifaddrs {
  struct ifaddrs  *ifa_next;
  char		*ifa_name;
  unsigned int	 ifa_flags;
  struct sockaddr	*ifa_addr;
  struct sockaddr	*ifa_netmask;
  struct sockaddr	*ifa_dstaddr;
  void		*ifa_data;
};

/*
* This may have been defined in <net/if.h>.  Note that if <net/if.h> is
* to be included it must be included before this header file.
*/
#ifndef	ifa_broadaddr
#define	ifa_broadaddr	ifa_dstaddr	/* broadcast address interface */
#endif

struct ifmaddrs {
  struct ifmaddrs	*ifma_next;
  struct sockaddr	*ifma_name;
  struct sockaddr	*ifma_addr;
  struct sockaddr	*ifma_lladdr;
};

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



【close函数和shutdown函数有什么不同】

[socket close()和shutdown()区别](http://www.jianshu.com/p/eecab8d50697) ：以server调用close为例，分析client端如何知道已经接收到RST报文