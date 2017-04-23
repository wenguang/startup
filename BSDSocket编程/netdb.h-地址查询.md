**Socket的地址查询函数有很多, 分为主机(host), 网络(net), 协议(proto)和服务(serv), 这些函数完成各种地址查询功能. POSIX.1定义了两个新的函数: getaddrinfo和getnameinfo, 前者把主机名字和服务名字映射到一个地址, 后者将地址转换成主机名或服务器名.    这些函数返回的网络配置信息可能存放在许多地方. 它们可以保存在静态文件中(如/etc/hosts, /etc/services等), 或者可以由命名服务器(如DNS, NIS).**  

```objective-c

//***************** getaddrinfo函数：通过主机名和服务名获得ipv4或ipv6地址 ***********************//
//--------------------------------------------------------------------------------------------//
1. 概述
getaddrinfo解决了把主机名和服务名转换成套接口地址结构的问题。
IPv4中使用gethostbyname()函数完 成主机名到地址解析，这个函数仅仅支持IPv4，且不允许调用者指定所需地址类型的任何信息，返回的结构只包含了用于存储IPv4地址的空间。IPv6中 引入了getaddrinfo()的新API，它是协议无关的，既可用于IPv4也可用于IPv6。getaddrinfo函数能够处理名字到地址以及服 务到端口这两种转换，返回的是一个addrinfo的结构（列表）指针而不是一个地址清单。这些addrinfo结构随后可由套接口函数直接使用。如此以 来，getaddrinfo函数把协议相关性安全隐藏在这个库函数内部。应用程序只要处理由getaddrinfo函数填写的套接口地址结构。该函数在 POSIX规范中定义了。


2. 函数说明

包含头文件
#include<netdb.h>

函数原型
int getaddrinfo( const char *hostname, const char *service, const struct addrinfo *hints, struct addrinfo **result );

参数说明
hostname:一个主机名或者地址串(IPv4的点分十进制串或者IPv6的16进制串)
service：服务名可以是十进制的端口号，也可以是已定义的服务名称，如ftp、http等
hints：可以是一个空指针，也可以是一个指向某个addrinfo结构体的指针，调用者在这个结构中填入关于期望返回的信息类型的暗示。举例来说：如果指定的服务既支持TCP也支持UDP，那么调用者可以把hints结构中的ai_socktype成员设置成SOCK_DGRAM使得返回的仅仅是适用于数据报套接口的信息。
result：本函数通过result指针参数返回一个指向addrinfo结构体链表的指针。
返回值：0——成功，非0——出错


3. 参数设置

在getaddrinfo函数之前通常需要对以下6个参数进行以下设置：nodename、servname、hints的ai_flags、ai_family、ai_socktype、ai_protocol。
在6项参数中，对函数影响最大的是nodename，sername和hints.ai_flag，而ai_family只是有地址为v4地址或v6地址的区别。ai_protocol一般是为0不作改动。
  
addrinfo结构中的ai_flags有以下几种值:
AI_ADDRCONFIG: 查询配置的地址类型(IPv4或IPv6).
AI_ALL: 查找IPv4和IPv6地址(仅用于AI_V4MAPPED).
AI_CANONNAME: 需要一个规范名(而不是别名).
AI_NUMERICHOST: 以数字格式返回主机地址.
AI_NUMERICSERV: 以端口号返回服务.
AI_PASSIVE: socket地址用于监听绑定.
AI_V4MAPPED: 如果没有找到IPv6地址, 则返回映射到IPv6格式的IPv6地址.

getaddrinfo在实际使用中的几种常用参数设置
一般情况下，client/server编程中，server端调用bind（如果面向连接的还需要listen），client则不用掉bind函数，解析地址后直接connect（面向连接）或直接发送数据（无连接）。因此，比较常见的情况有
（1）    通常服务器端在调用getaddrinfo之前，ai_flags设置AI_PASSIVE，用于bind；主机名nodename通常会设置为NULL，返回通配地址[::]。
（2）    客户端调用getaddrinfo时，ai_flags一般不设置AI_PASSIVE，但是主机名nodename和服务名servname（更愿意称之为端口）则应该不为空。
（3）    当然，即使不设置AI_PASSIVE，取出的地址也并非不可以被bind，很多程序中ai_flags直接设置为0，即3个标志位都不设置，这种情况下只要hostname和servname设置的没有问题就可以正确bind。

上述情况只是简单的client/server中的使用，但实际在使用getaddrinfo和参考国外开源代码的时候，曾遇到一些将servname（即端口）设为NULL的情况(当然，此时nodename必不为NULL，否则调用getaddrinfo会报错)。
以下分情况进行了测试：
（1）    如果nodename是字符串型的IPv6地址，bind的时候会分配临时端口；
（2）    如果nodename是本机名，servname为NULL，则根据操作系统的不同略有不同，本文仅在WinXP和Win2003上作了测试。
a)    WinXP系统（SP2）返回loopback地址[::1]
b)    Win2003则将本机的所有IPv6地址列表加以返回。因为通常一台IPv6主机都有可能不止一个IPv6地址，比如fe80::1（本机 loopback地址）、fe80::***的Link-Local地址、3ffe:***的全局地址等等。这种情况下调用getaddrinfo会将这 些地址全部返回，调用者应该注意如何使用这些地址。另外要注意的是，对于fe80::的地址在绑定的时候必须标明接口地址，即使用 fe80::20d:60ff:fe78:51c2%4或fe80::1%1这样的地址格式，通过getaddrinfo直接取出fe80地址好像无法直 接bind。


4. 使用细节

如果本函数返回成功，那么由result参数指向的变量已被填入一个指针，它指向的是由其中的ai_next成员串联起来的addrinfo结构链表。可以导致返回多个addrinfo结构的情形有以下2个：
1.    如果与hostname参数关联的地址有多个，那么适用于所请求地址簇的每个地址都返回一个对应的结构。
2.    如果service参数指定的服务支持多个套接口类型，那么每个套接口类型都可能返回一个对应的结构，具体取决于hints结构的ai_socktype成员。

我们必须先分配一个hints结构，把它清零后填写需要的字段，再调用getaddrinfo，然后遍历一个链表逐个尝试每个返回地址。



其中，如果getaddrinfo出错，那么返回一个非0的错误值。
#include<netdb.h>
const char *gai_strerror( int error );
该函数以getaddrinfo返回的非0错误值的名字和含义为他的唯一参数，返回一个指向对应的出错信息串的指针。

由getaddrinfo返回的所有存储空间都是动态获取的，这些存储空间必须通过调用freeaddrinfo返回给系统。
#include< netdb.h >
void freeaddrinfo( struct addrinfo *ai );
ai参数应指向由getaddrinfo返回的第一个addrinfo结构。这个连表中的所有结构以及它们指向的任何动态存储空间都被释放掉。
//********************************************************************************************//
  
  
 								     /*以下简略，待续*/ 
  
  
//-------------------------------------------------------------------------------------------//  
getnameinfo函数:
原型: int getnameinfo(const struct sockaddr *restrict addr, socklen_t alen,
char *restrict host, socklen_t hostlen,
char *restrict service, socklen_t servlen,
unsigned int flags);
头文件: <sys/socket.h> <netdb.h>
参数:
addr: socket地址.
alen: socket地址长度.
host: 主机名.
hostlen: 主机名长度.
service: 服务名.
servlen: 服务名长度.
flags: 指定转换的控制方式. 可以有如下几种:
NI_DGRAM: 服务基于数据报而非基于流.
NI_NAMEREQD: 如果找不到主机名字, 将其作为一个错误对待.
NI_NOFQDN: 对于本地主机, 仅返回完全限定域名的节点名部分.
NI_NUMERICHOST: 以数字形式而非名字返回主机地址.
NI_NUMERICSERV: 以数字形式而非名字返回服务地址(即端口号).
说明: 如果host或service非空, 它(们)将指向洋长度问该len字节的缓冲区用于存储返回的名. 如果为空则不返回该名.
//-------------------------------------------------------------------------------------------//  
 
  
//************************************* 主机信息查询 ******************************************//
//--------------------------------------------------------------------------------------------//
/*
 * Structures returned by network data base library.  All addresses are
 * supplied in host order, and returned in network order (suitable for
 * use in system calls).
 */
struct hostent {
	char	*h_name;	/* official name of host */
	char	**h_aliases;	/* alias list */
	int	h_addrtype;	/* host address type */
	int	h_length;	/* length of address */
	char	**h_addr_list;	/* list of addresses from name server */
#if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
#define	h_addr	h_addr_list[0]	/* address, for backward compatibility */
#endif /* (!_POSIX_C_SOURCE || _DARWIN_C_SOURCE) */
};

函数原型:
struct hostent *gethostent();
void sethostent(int stayopen);
void endhostent();
说明:
gethostent: 打开数据文件, 如果数据文件打开则返回文件的下一个条目.
sethostent: 打开文件, 如果文件已打开, 将其回绕.
endhostent: 关闭文件.
//********************************************************************************************//
  
 
  
//********************************** 网络名字和网络号查询 **************************************//
//--------------------------------------------------------------------------------------------//
/*
 * Assumption here is that a network number
 * fits in an unsigned long -- probably a poor one.
 */
struct netent {
	char		*n_name;	/* official name of net */
	char		**n_aliases;	/* alias list */
	int		n_addrtype;	/* net address type */
	uint32_t	n_net;		/* network # */
};
函数原型:
struct netent *getnetbyaddr(uint32_t net, int type);
struct netent *getnetbyname(const char *name);
struct netent *getnetent();
void setnetent(int stayopen);
void endnetent();
//********************************************************************************************//



//********************************** 协议名字和协议号查询 **************************************//
//--------------------------------------------------------------------------------------------//
struct protoent {
	char	*p_name;	/* official protocol name */
	char	**p_aliases;	/* alias list */
	int	p_proto;	/* protocol # */
};
函数原型:
struct protoent *getprotobyname(const char *name);
struct protoent *getprotobynumber(int proto);
struct protoent *getprotoent();
void setprotoent(int stayopen);
void endprotoent();
//********************************************************************************************//



//************************************** 服务查询 *********************************************//
//--------------------------------------------------------------------------------------------//
struct servent {
	char	*s_name;	/* official service name */
	char	**s_aliases;	/* alias list */
	int	s_port;		/* port # */
	char	*s_proto;	/* protocol to use */
};
函数原型:
struct servent *getservbyname(const char *name, const char *proto);
struct servent *getservbyport(int port, const char *proto);
struct servent *getservent();
void setservent(int stayopen);
void endservent();
//********************************************************************************************//
```



参考：[Socket的地址查询函数](http://blog.sina.com.cn/s/blog_988c054b010139e3.html) 