### NSString与地址字节相互转换



**从地址结构得到NSString类型的IP** 
上面的那些地址结构，没有很直观的ip字符串字段，sockaddr中的char sa_data[14]; 14个字符似乎不够储存ip(xxx.xx.xx.xxx)长度，char与short int的长度一样，会不会是xxx当数字用short int表示呢？
sockaddr_in中的sin_addr in_addr;	sockaddr_in6中sin6_addr in6_addr；是表示ip的。这些结构又怎样转换才能得到熟悉的NSString类型的ip字符串呢？先想到inet_ntop函数，将IP网络字节序的二进制地址转换成文本字符串。
若pSockaddr4是一个sockaddr_in结构指针，那pSockaddr4->sin_addr就是表示ip的结构，
那&pSockaddr4->sin_addr就是指向in_addr结构内存地址的指针，即IP网络字节序的二进制地址

```c
char addrBuf[INET_ADDRSTRLEN]; // INET_ADDRSTRLEN = 16; INET6_ADDRSTRLEN = 64

if (inet_ntop(AF_INET, &pSockaddr4->sin_addr, addrBuf, (socklen_t)sizeof(addrBuf)) == NULL)

{

	addrBuf[0] = '\0';	//为什么在第一个字符为空？与网络序有关？有待验证

}

return [NSString stringWithCString:addrBuf encoding:NSASCIIStringEncoding];

```



**NSString类型的IP或字符** 
先把NSString转为char C字符串，再为inet_pton函数转换
int inet_pton(int af，const char *src，void *dst)；