

```objective-c
// 从socketFD中创建stream
CFStreamCreatePairWithSocket(NULL, (CFSocketNativeHandle)socketFD, &readStream, &writeStream);
// 这里kCFStreamPropertyShouldCloseNativeSocket设置很关键
// 它让stream关闭释放时不会自动关闭释放掉对应的socket
CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanFalse);
// 设置回调函数	
CFReadStreamSetClient(readStream, readStreamEvents, &CFReadStreamCallback, &streamContext);
// 调度流
CFReadStreamScheduleWithRunLoop(asyncSocket->readStream, runLoop, kCFRunLoopDefaultMode);
// 打开流
// 用CFReadStreamGetStatus函数获取下当前的stream状态，有可能它已是打开状态了 
CFReadStreamOpen(readStream);
// 在CFReadStreamCallback中调用，在其中读取数据
CFReadStreamHasBytesAvailable(asyncSocket->readStream)
// 停止调度
CFReadStreamUnscheduleFromRunLoop(asyncSocket->readStream, runLoop, kCFRunLoopDefaultMode);
// 关闭流
CFReadStreamClose(readStream);
// 释放流
CFRelease(readStream);
// 置空
writeStream = NULL;
```

