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
 获取网卡的IP和MAC地址。getifaddrs函数有个特点，就是获取地址时以链表方式返回，且每个链表节点要么是IP，要       么是MAC，所以如果要将网卡的IP和MAC地址同时返回的话，需要对对返回链表进行查找和重新组合。
*/
int getifaddrs(struct ifaddrs **ifa);
// 释放getifaddrs返回的链表
void freeifaddrs(struct ifaddrs *ifa);
int getifmaddrs(struct ifmaddrs **ifm);
void freeifmaddrs(struct ifmaddrs *ifm);
```

