用 位或(OR) 叠加状态，如：kSocketStarted | kConnected （0…011）

flags &= ~kReadSourceSuspended	//表示去掉指定的叠加位

kSocketStarted = 1 << 0;（0…001） kConnected = 1 << 1; （0…010）

~ 位反（NOT）；&位与（AND）| 位或（OR）；^位异或（XOR）；<<左移位；>>右移位；详见[位操作](https://zh.wikipedia.org/wiki/%E4%BD%8D%E6%93%8D%E4%BD%9C) 



从创建socket代码看出，即使在一个方法内，代码也被组织成block（有自定义block，也有dispatch_block），再让block代码运行在指定的dispatch_queue中，这样的写法有借鉴。把写法、边界代码先忽略，我们来看下，服务端和客户端创建socket的关键步骤

```objective-c
//
int parentSocketFD = socket(AF_INET, SOCK_STREAM, 0);
// 设置为非阻塞I/O模式
status = fcntl(parentSocketFD, F_SETFL, O_NONBLOCK);
//
status = setsockopt(parentSocketFD, SOL_SOCKET, SO_REUSEADDR, &reuseOn, sizeof(reuseOn));
// 如何获取pSocketFD的绑定地址是很关键的一步，端口是指定的，地址则是网卡IP，地址问题可独立开一篇
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





pSocket：服务端监听连接的socket

cSocket：pSocket从accept得到的与客户端通信的socket

每产生一个cSocket就新创建一个与之对应的GCDAsynSocket。但这个新创建的GCDAsyncSocket的delegate、delegateQueue是和parentSocketFD的GCDAsynSocket的一样，只有socketQueue是通过delegate新生成的。



pSocket在listen()之后，dispatch_source的监听读取事件中调用dispatch_source_get_data得到的是等待连接的数量，之后调用与等待连接数等同的accept。

cSocket在dispatch_source的监听读取事件调用dispatch_source_get_data得到的是客户端发来可读数据字节数。



asyncSocket的读与写流程没有用到BSD中的read函数和write函数，而是CFStreamCreatePairWithSocket从socketFD中获取一个CFReadStreamRef和一个CFWriteStreamRef，通过CFStream相关API实现socket的读写功能。CFStream是通过RunLoop来调度的，这是CFStream的工作模式，再次，从dispatch_source_create的参数看得出，GCD是不能为CFStream对象创建dispatch_source_t的。



调度CFStream的RunLoop所有线程是个独立的线程，这个线程的创建运行有点看不懂~~



CFStream API工作模式（关键步骤）

```objective-c
//步骤1	以后步骤只以readStream为例
CFStreamCreatePairWithSocket(NULL, (CFSocketNativeHandle)socketFD, &readStream, &writeStream);
//步骤2	这里kCFStreamPropertyShouldCloseNativeSocket设置很关键
//它让stream关闭释放时不会自动关闭释放掉对应的socket
CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanFalse);
//步骤3	
CFReadStreamSetClient(readStream, readStreamEvents, &CFReadStreamCallback, &streamContext)
//步骤4	
CFReadStreamScheduleWithRunLoop(asyncSocket->readStream, runLoop, kCFRunLoopDefaultMode);
//步骤5 打开stream前，用CFReadStreamGetStatus函数获取下当前的stream状态，有可能它已是打开状态了 
CFReadStreamOpen(readStream);
//步骤6	在CFReadStreamCallback中调用，在其中读取数据
CFReadStreamHasBytesAvailable(asyncSocket->readStream)
//步骤7
CFReadStreamUnscheduleFromRunLoop(asyncSocket->readStream, runLoop, kCFRunLoopDefaultMode);

```



