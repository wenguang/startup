```objective-c

// <arpa/inet.h> 主要是地址转换函数

// inet_ntop和inet_pton函数同时适用ip/v4和ip/v6
// inet_addr、inet_aton和inet_ntoa只适用ip/v4

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
          

///---------------------------------------------------------------------------------------------//
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

