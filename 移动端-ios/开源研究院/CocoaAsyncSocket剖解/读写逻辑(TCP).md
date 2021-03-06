**GCDAsyncReadPacket和GCDAsyncSocketPreBuffer相关的注释翻译已写入源码中** 



```objective-c
注意挂起readSource、writeSource的时机
```





**读写被阻塞** 

```objective-c
ssize_t result = write(socketFD, buffer, (size_t)bytesToWrite);
or
ssize_t result = read(....);
if (result < 0 && errno == EWOULDBLOCK) //...
```

**看不懂doWriteData这段** 

```objective-c
// This method is called by the writeSource via the socketQueue
if ((currentWrite == nil) || (flags & kWritesPaused))
{
    LogVerbose(@"No currentWrite or kWritesPaused");

    // Unable to write at this time

    if ([self usingCFStreamForTLS])
    {
        // CFWriteStream only fires once when there is available data.
        // It won't fire again until we've invoked CFWriteStreamWrite.
    }
    else
    {
        // If the writeSource is firing, we need to pause it
        // or else it will continue to fire over and over again.

        if (flags & kSocketCanAcceptBytes)
        {
            [self suspendWriteSource];
        }
    }
    return;
}
```



**maybeDequeueRead** 

```objective-c
虽然didConnect调用了maybeDequeueRead，但这时readQueue队列很可能还没有对象。
因为readDataXXX才会往readQueue添加读取请求，若用户不发起读取请求，那从socket接收的数据写在什么地方呢？
  
maybeDequeueRead方法的注释
/**
 * This method starts a new read, if needed.
 * 
 * It is called when:
 * - a user requests a read
 * - after a read request has finished (to handle the next request)
 * - immediately after the socket opens to handle any pending requests
 * 
 * This method also handles auto-disconnect post read/write completion.
**/
/** 
 * 如果有需要，该方法会开始新的读取操作
 *
 * 该方法在以下情况被调用
 * —— 外部调用readDataWithXXX请求读取操作
 * —— 一个读取操作完成，处理下个一个读取请求前
 * —— 一打开的socketFD的stream或gcd对socketFD的读取事件时
 *
 * 该方法还会处理也自动断开连接的读写收尾工作
 **/
- (void)maybeDequeueRead;
```









**读数据相关的疑问**  

1、iOS客户端：从didConnect方法看出，既开了GCD读写事件，又开了CFStream读写。不这冲突吗？

​     iOS服务器：doAccept方法看出，只是gcd source来监听socketFD的读取事件。



2、CFStream是在cfstreamThread中调度的，cfstreamThread是static的，这样设计有什么好处吗？cfstreamThread的实现看不懂~

3、当用户没有发起读取请求（即readQueue队列中没有对象）时，socket的GCD读取事件触发时调用doReadData，那其中从preBuffer或从socket读取数据的流程好像没有意义了？



**doReadData** 

光看doReadData方法的代码，那叫一个长，逻辑很多。

**read调用路径** 

1、readDataXXX—>maybeDequeueRead—>doReadData

2、didConnect—>maybeDequeueRead—>doReadData

3、CFReadStreamCallback—>cf_finishSSLHandshake—>maybeDequeueRead—>doReadData

4、maybeStartTLS—>ssl_startTLS—>ssl_continueSSLHandshake—>maybeDequeueRead—>doReadData

5、ssl_shouldTrustPeer—>ssl_continueSSLHandshake—>maybeDequeueRead—>doReadData

6、startTLS—>maybeDequeueRead—>doReadData

7、doReadData—>maybeDequeueRead—>doReadData



