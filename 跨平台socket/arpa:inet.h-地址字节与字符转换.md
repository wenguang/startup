### 地址字节与字符转换

*\<arpa/inet.h\>* 

*函数中，字母p和n分别代码presentation和numeric，地址的表达（presentation）格式通常是ASCII串，数值（numeric）格式则是存在于sockaddr中的二进制值。* 



**inet_addr、inet_aton和inet_ntoa只适用ip/v4** 

```c
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



**inet_ntop和inet_pton函数同时适用ip/v4和ip/v6** 

*inet_ntop函数* 

```c
// addrptr表示sockaddr_in或sockaddr_in6的sin_addr的地址
// 若成功，返回地址字符串指针；若出错，返回NULL
const char * inet_ntop(int family, const void * addrptr, char * strptr, size_t len);

// 例子
// 当转换ip/v4的地址时，addrBuf的长度为INET_ADDRSTRLEN
// 当转换ip/v6的地址时，addrBuf的长度为INET6_ADDRSTRLEN
char addr4Buf[INET_ADDRSTRLEN];
char addr6Buf[INET6_ADDRSTRLEN];
inet_ntop(AF_INET, &addr4->sin_addr, addr4Buf, (socklen_t)sizeof(addr4Buf)
inet_ntop(AF_INET, &addr6->sin_addr, addr6Buf, (socklen_t)sizeof(addr6Buf)
```

*inet_pton函数* 

```c
// addrptr表示sockaddr_in或sockaddr_in6的sin_addr的地址
// 返回：1——成功，0——输入不是有效的表达格式，-1——出错
int inet_pton(int family，const char * strptr，void * addrptr)；
  
// 例子
inet_pton(AF_INET, "127.0.0.1", &addrin.sin_addr);
```





