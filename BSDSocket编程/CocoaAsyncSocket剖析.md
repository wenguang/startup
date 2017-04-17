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
#import <sys/ioctl.h>	//I/O通道管理，驱动程序
#import <sys/poll.h>	//I/O多路复用
#import <sys/uio.h>
#import <sys/un.h>	// UNIX IPC 域相关的结构和常量定义
#import <unistd.h>	// 提供通用的文件、目录、程序及进程操作的函数，这里api众多
```



[sys/socket.h常用注释](https://github.com/wenguang/startup/blob/master/BSDSocket%E7%BC%96%E7%A8%8B/BSD-sys:socket.h%E6%B3%A8%E9%87%8A.md)  

[arpa/inet.h常用注释](https://github.com/wenguang/startup/blob/master/BSDSocket%E7%BC%96%E7%A8%8B/BSD-arpa:inet.h%E6%B3%A8%E9%87%8A.md) 

[sys/fnctl.h常用注释](https://github.com/wenguang/startup/blob/master/BSDSocket%E7%BC%96%E7%A8%8B/BSD-sys:fnctl.h%E6%B3%A8%E9%87%8A.md) 



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