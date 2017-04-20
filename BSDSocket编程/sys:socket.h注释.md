```objective-c
// 协议簇常用宏
#define	AF_UNIX		1		/* local to host (pipes) */
#define	AF_LOCAL	AF_UNIX		/* backward compatibility */
#define	AF_INET		2		/* internetwork: UDP, TCP, etc. */
#define	AF_INET6	30		/* IPv6 */





///---------------------------------------------------------------------------------------------//
int socketFD = socket(domain, SOCK_STREAM, 0);

/**
  * 创建一个socket
  *
  * @param domain 底层协议族，如：AF_INET、AF_INET6，详见socket.h
  * @param type 指定服务类型，如：SOCK_STREAM、SOCK_DGRAM、SOCK_RAW，详见socket.h
  * @param protocal 一般默认为0
  * @return 函数执行成功返回一个socket文件描述符，失败返回-1
  */
int socket(int domain, int type, int protocal)

// 实现父子进程双工通信
// 参考：http://liulixiaoyao.blog.51cto.com/1361095/533469/
//       http://www.cnblogs.com/keepsimple/archive/2013/05/20/3088248.html
// @sv 表示数组指针，存放返回的两个socket文件描述符的数组地址
int socketpair(int domain, int type, int protocol, int* sv);
  



///---------------------------------------------------------------------------------------------//
/// 设置本地socket地址可重用
int reuseOn = 1;
status = setsockopt(socketFD, SOL_SOCKET, SO_REUSEADDR, &reuseOn, sizeof(reuseOn));

// 阻止socket发SIGPIPE信号，当向一个关闭的socket写数据时，会得RST响应，若继续写操作就会收到SIGPIPE信号
// SIGPIPE信号的默认行为是终止进程。有两种方法可避免该情况，一是接收端不发SIGPIPE信号，以下就是；
// 二是全局忽略它，把它交给系统处理：signal(SIGPIPE, SIG_IGN);
// 详见:【socket SIGPIPE错误处理 参考】
int nosigpipe = 1;
setsockopt(childSocketFD, SOL_SOCKET, SO_NOSIGPIPE, &nosigpipe, sizeof(nosigpipe));

/**
  * 设置socket状态
  *
  * @param sockfd socket文件描述符
  * @param level 设置的网络层，如：SOL_SOCKET表示socket层，一般就用这个
  * @param optname 设置项名称，详见：socket.h
  * @param optval 设置项的值地址
  * @param optlen 设置值的长度，socklen_t定义在<sys/types.h>
  * @return 成功则返回0, 若有错误则返回-1
  */
int setsockopt(int sockfd, int level, int optname, const void * optval, socklen_t optlen);
// 获取socket状态值
int getsockopt(int sockfd, int level, int optname, const void * optval, socklen_t optlen);





///---------------------------------------------------------------------------------------------//
status = bind(socketFD, (const struct sockaddr *)[interfaceAddr bytes], (socklen_t)[interfaceAddr length]);

/**
  * socket绑定地址端口
  *
  * @param sockfd socket文件描述符
  * @param my_addr socket地址，sockaddr结构体定义见：socket.h
  * @param addrlen socket地址的长度
  * @return 函数执行成功返回0，失败返回-1
*/
 int bind(int sockfd, const stuct sockaddr *my_addr, socklen_t addrlen);




///---------------------------------------------------------------------------------------------//
status = listen(socketFD, 1024);

/**
  * 用来等待参数s 的socket 连线. 
  * 只适用SOCK_STREAM 或SOCK_SEQPACKET 的socket 类型
  * 参数backlog 指定同时能处理的最大连接要求
  * 如果连接数目达此上限则client端将收到ECONNREFUSED 的错误. 
  * Listen()并未开始接收连线, 只是设置socket 为listen 模式, 真正接收client 端连线的是accept(). 
  * 通常listen()会在socket(), bind()之后, 在accept()之前.
  *
  * @param sockfd socket文件描述符
  * @param backlog 指定同时能处理的最大连接要求
  * @return 函数执行成功返回0，失败返回-1
*/
int listen(int sockfd, int backlog);




///---------------------------------------------------------------------------------------------//
/// 服务端socket接受客户端的连接，连接成功客户端地址存放在addr中，地址长度存放在addrLen
/// 返回一个新socket句柄，新socket将进行与客户端的通信
childSocketFD = accept(parentSocketFD, (struct sockaddr *)&addr, &addrLen);

/**
  * 接受连接
  *
  * @param sockfd 上述listen函数指定的监听socket
  * @param addr   存放连接方（即客户端）地址
  * @param addrlen 存放客户端地址长度
  * @return 函数执行成功返回一个新的连接socket的描述符，失败返回-1
*/
int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);




///---------------------------------------------------------------------------------------------//
/**
  * 建立连接
  *
  * @param sockfd socket函数返回一个socket
  * @param server_addr  服务端地址
  * @param addrlen 服务端地址地址长度
  * @return 函数执行成功返回0，失败返回-1
*/
int connect(int sockfd, const struct sockaddr *server_addr, socklen_t *addrlen);




///---------------------------------------------------------------------------------------------//
/**
  * 关闭socket
  *
  * @param sockfd socket文件描述符
  * @return 函数执行成功返回0，失败返回-1
  */
int close(int sockfd);



///---------------------------------------------------------------------------------------------//
/**
  * 关闭socket
  *
  * @param sockfd socket文件描述符
  * @param how how=0 终止读取操作、how=1 终止传送操作、how=2 终止读取及传送操作
  *
  * @return 成功则返回0, 失败返回-1, 错误原因存于errno.
  */
int shutdown(int sockfd, int how);




///---------------------------------------------------------------------------------------------//
/**
  * 获取本地或远程socket的地址
  * TCP：getpeername只有在连接建立以后才调用，否则不能正确获得对方地址和端口，
  * 所以它的参数描述字一般是已连接描述字而非监听套接口描述字
  *
  * UDP：没有连接不能调用getpeername，但是可以调用getsockname
  * 
  * 需要这俩函数的理由如下：
  * 1、在一个没有调用bind的TCP客户上，connect成功返回后，
  *    getsockname用于返回由内核赋予该连接的本地IP地址和本地端口号。
  * 2、在以端口号为0调用bind（告知内核去选择本地临时端口号）后，
  *    getsockname用于返回由内核赋予的本地端口号。
  * 3、在一个以通配IP地址调用bind的TCP服务器上，与某个客户的连接一旦建立（accept成功返回），
  *    getsockname就可以用于返回由内核赋予该连接的本地IP地址。在这样的调用中，
  *    套接字描述符参数必须是已连接套接字的描述符，而不是监听套接字的描述符。
  * 4、当一个服务器的是由调用过accept的某个进程通过调用exec执行程序时，
  *    它能够获取客户身份的唯一途径便是调用getpeername。
  *
  *    第4种情况参考：http://www.cnblogs.com/zl-graduate/p/5934192.html
  *
  * @param sockfd
  * @param localaddr|peeraddr 存放本地或远端socket地址的指针
  * @param addrlen 地址内存的长度
  * @return 函数执行成功返回0，失败返回-1
  */
若成功则为0，失败则为-1
int getsockname(int sockfd,struct sockaddr* localaddr,socklen_t *addrlen);
int getpeername(int sockfd,struct sockaddr* peeraddr,socklen_t *addrlen);





///---------------------------------------------------------------------------------------------//
/**
  * 用来接收远端主机传来的数据, 
  * 并把数据存到由参数buf指向的内存空间, 参数len为可接收数据的最大长度.
  *
  * 在Unix系统下，如果recv函数在等待协议接收数据时网络断开了，
  * 那么调用recv的进程会接收到一个SIGPIPE信号，进程对该信号的默认处理是进程终止。
  *
  * @param sockfd 接收端socket文件描述符
  * @param buf  保存数据的内存地址
  * @param len  数据长度
  * @param flags 一般为0，也有如：MSG_WAITALL、MSG_NOSIGNAL，详见socket.h
  * flags参考：http://c.biancheng.net/cpp/html/367.html
  * 
  * @return 成功则返回接收到的字符数, 失败则返回-1, 错误原因存于errno 中.
  * 错误代码：
  * EBADF 参数s 非合法的socket 处理代码
  * EFAULT 参数中有一指针指向无法存取的内存空间
  * ENOTSOCK 参数s 为一文件描述词, 非socket.
  * EINTR 被信号所中断
  * EAGAIN 此动作会令进程阻断, 但参数s 的socket 为不可阻断
  * ENOBUFS 系统的缓冲内存不足.
  * ENOMEM 核心内存不足
  * EINVAL 传给系统调用的参数不正确.
  * 
*/
ssize_t recv(int sockfd, void *buf, int len, unsigned int flags);




///---------------------------------------------------------------------------------------------//
/**
  * 用来接收指定的远端主机传来的数据, 
  * 并把数据存到由参数buf指向的内存空间, 参数len为可接收数据的最大长度.
  *
  * @param sockfd 接收端socket文件描述符
  * @param buf  保存数据的内存地址
  * @param len  数据长度
  * @param flags 一般为0，也有如：MSG_WAITALL、MSG_NOSIGNAL，详见socket.h
  * flags参考：http://c.biancheng.net/cpp/html/367.html
  * @param from  远端地址 
  * @param fromlen  远端地址长度
  * 
  * @return 成功则返回接收到的字符数, 失败则返回-1, 错误原因存于errno 中.
  * 错误代码：
  * EBADF 参数s 非合法的socket 处理代码
  * EFAULT 参数中有一指针指向无法存取的内存空间
  * ENOTSOCK 参数s 为一文件描述词, 非socket.
  * EINTR 被信号所中断
  * EAGAIN 此动作会令进程阻断, 但参数s 的socket 为不可阻断
  * ENOBUFS 系统的缓冲内存不足.
  * ENOMEM 核心内存不足
  * EINVAL 传给系统调用的参数不正确.
*/
ssize_t recvfrom(int sockfd, void *buf, int len, unsigned int flags, struct sockaddr *from, int *fromlen);



///---------------------------------------------------------------------------------------------//
/**
  * 用来接收远程主机传来的数据. 
  * 
  * @param sockfd 接收端已连线的socket文件描述符,如果利用UDP协议则不需经过连线操作.
  * @param 参数msg 指向欲连线的数据结构内容, msghdr结构体的定义在socket.h中
  * @param 参数flags一般设0
  * 
  * @return 成功则返回接收到的字符数, 失败则返回-1, 错误原因存于errno 中.
  * 错误代码：
  * EBADF 参数s 非合法的socket 处理代码
  * EFAULT 参数中有一指针指向无法存取的内存空间
  * ENOTSOCK 参数s 为一文件描述词, 非socket.
  * EINTR 被信号所中断
  * EAGAIN 此动作会令进程阻断, 但参数s 的socket 为不可阻断
  * ENOBUFS 系统的缓冲内存不足.
  * ENOMEM 核心内存不足
  * EINVAL 传给系统调用的参数不正确.
  */
ssize_t recvmsg(int sockfd, struct msghdr *msg, unsigned int flags);




///---------------------------------------------------------------------------------------------//
/**
  * 读数据
  *
  * @param sockfd 发送端建立好连接的socket描述符，若为UDP则无需要连线
  * @param buff  存放要发送数据的缓冲区
  * @param nbytes 实际要发送的数据的字节数
  * @param flags 一般设置为0
  * 
  * @return 成功则返回接收到的字符数, 失败则返回-1, 错误原因存于errno 中.
  * 错误代码：
  * EBADF 参数s 非合法的socket 处理代码
  * EFAULT 参数中有一指针指向无法存取的内存空间
  * ENOTSOCK 参数s 为一文件描述词, 非socket.
  * EINTR 被信号所中断
  * EAGAIN 此动作会令进程阻断, 但参数s 的socket 为不可阻断
  * ENOBUFS 系统的缓冲内存不足.
  * ENOMEM 核心内存不足
  * EINVAL 传给系统调用的参数不正确.
*/
ssize_t send(int sockfd, const void *buff, size_t nbytes, int flags);

// @param 参数msg 指向欲连线的数据结构内容, msghdr结构体的定义在socket.h中
// 其他和send函数一样
ssize_t sendmsg(int sockfd, const strcut msghdr *msg, unsigned int flags);




///---------------------------------------------------------------------------------------------//
/**
  * 读数据
  *
  * @param sockfd 发送端建立好连接的socket描述符，若为UDP则无需要连线
  * @param buff  存放要发送数据的缓冲区
  * @param len 实际要发送的数据的字节数
  * @param toaddr  目标端地址
  * @param tolen 地址长度
  * @param flags 一般设置为0
  * 
  * @return 成功则返回接收到的字符数, 失败则返回-1, 错误原因存于errno 中.
  * 错误代码：
  * EBADF 参数s 非合法的socket 处理代码
  * EFAULT 参数中有一指针指向无法存取的内存空间
  * ENOTSOCK 参数s 为一文件描述词, 非socket.
  * EINTR 被信号所中断
  * EAGAIN 此动作会令进程阻断, 但参数s 的socket 为不可阻断
  * ENOBUFS 系统的缓冲内存不足.
  * ENOMEM 核心内存不足
  * EINVAL 传给系统调用的参数不正确.
*/
ssize_t sendto(int sockfd, const void * buff, int len, unsigned int flags, const struct sockaddr * toaddr, int tolen);
```

