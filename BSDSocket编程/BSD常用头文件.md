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

