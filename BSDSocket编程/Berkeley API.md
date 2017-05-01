

```objective-c
// 创建socket
int parentSocketFD = socket(AF_INET, SOCK_STREAM, 0);
// 设置为非阻塞I/O模式
status = fcntl(parentSocketFD, F_SETFL, O_NONBLOCK);
// 让处于TIME_WAIT状态（等待CLOSED状态）的端口可复用监听，这步不可或缺
status = setsockopt(parentSocketFD, SOL_SOCKET, SO_REUSEADDR, &reuseOn, sizeof(reuseOn));
// 绑定地址端口
status = bind(parentSocketFD, (const struct sockaddr *)[interfaceAddr bytes], (socklen_t)[interfaceAddr length]);
// accept接受一个连接，那listen做了什么，listen和accept之间发生了什么？
status = listen(parentSocketFD, 1024);


// 这步真正得到一个和客户端通信的socket，也返回了这个socket的本地地址
childSocketFD = accept(parentSocketFD, (struct sockaddr *)&addr, &addrLen);
// 设置为非阻塞I/O模式
int result = fcntl(childSocketFD, F_SETFL, O_NONBLOCK);
// 阻止SIGPIPE信号：http://l241002209.iteye.com/blog/1506681
setsockopt(childSocketFD, SOL_SOCKET, SO_NOSIGPIPE, &nosigpipe, sizeof(nosigpipe));
```

