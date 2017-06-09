### 网卡接口信息

*\<ifaddrs.h\>* 

```objective-c
struct ifaddrs {
    struct ifaddrs  *ifa_next;
    char		*ifa_name;
    unsigned int	 ifa_flags;
    struct sockaddr	*ifa_addr;
    struct sockaddr	*ifa_netmask;	//子网掩码
    struct sockaddr	*ifa_dstaddr;
    void		*ifa_data;
};
struct ifmaddrs {
    struct ifmaddrs	*ifma_next;
    struct sockaddr	*ifma_name;
    struct sockaddr	*ifma_addr;
    struct sockaddr	*ifma_lladdr;
};

struct ifaddrs *addrs;
getifaddrs(&addrs);

/**
 获取网卡的IP和MAC地址。getifaddrs函数有个特点，就是获取地址时以链表方式返回，且每个链表节点要么是IP地址，要么是MAC地址，所以如果要将网卡的IP和MAC地址同时返回的话，需要对对返回链表进行查找和重新组合。
*/
int getifaddrs(struct ifaddrs **ifa);
// 释放getifaddrs返回的链表
void freeifaddrs(struct ifaddrs *ifa);
int getifmaddrs(struct ifmaddrs **ifm);
void freeifmaddrs(struct ifmaddrs *ifm);
```



**getifaddrs获取的数据对应ifconfig命令打印出的信息**

ifconfig得到的网卡接口号：lo0、gif0、stf0、en0、en1、en2、bridge0、p2p0、awdl0、utun0
代码断点看到lo0有4个ifaddrs地址，en0有3个、utun0有2个，其他1个。这些地址中，暂时只用到AF_INET和AF_INET6地址，其他协议簇地址有什么用现在搞不太清楚，有待研究~~~，
很奇怪，在内置系统信息应用中查硬件信息看到：这台电脑似乎没有安装任何 PCI 以太网卡。-_-？

lo：  回环接口(loop back) 或者 本地主机(localhost)
gif： 通用 IP-in-IP隧道(RFC2893)
stf： 6to4连接(RFC3056)
en：	 以太网或802.11接口
bridge： 第2层桥接
p2p： Point-to-Point 协议
awdl：airdrop peer to peer(一种mesh network), apple airdrop设备特有
utun：不知道干啥的
fw：IP over FireWire(IEEE-1394)

lo0: flags=8049\<UP,LOOPBACK,RUNNING,MULTICAST\> mtu 16384
UP：网卡已经启用，LOOPBACK：支持环路，RUNNING：网卡正在运行，MULTICAST：支持广播
mtu：最大传输单元为16384字节

有断点中，ifa_addr->sa_family的值是'\x1e'，表示2位十六进制数，它=30，表示AF_INET6。
更多转义字符参考：http://blog.csdn.net/sdustliyang/article/details/6594254