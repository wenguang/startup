### NSData与地址结构相互转换



**CocoaAsyncSocket中的地址数据是以NSData类型在方法之间传递的** 



**地址结构转NSData** 
很简单，NSData本就有从void *初始化的方法，void *为任何类型的指针，即任意一块内存地址，nativeAddr可是sockaddr、sockaddr_in或sockadd_in6中的任意结构

```c
NSData *address = [NSData dataWithBytes:&nativeAddr length:sizeof(nativeAddr)];
```



**NSData转地址结构** 
也很简单，硬转就行，address为NSData*类型

```c
const struct sockaddr *sockaddrX = [address bytes];
```

再转为sockaddr_in或sockaddr_in6时要先判断下字节长度

```c
if (sockaddrX->sa_family == AF_INET && [address length] >= sizeof(struct sockaddr_in))
{
  struct sockaddr_in sockaddr4;
  memcpy(&sockaddr4, sockaddrX, sizeof(sockaddr4));
}
```



