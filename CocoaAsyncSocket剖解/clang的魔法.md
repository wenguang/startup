```objective-c
// OS_OBJECT_USE_OBJC	iOS6.0或MAC10.8以后才有这个宏，它可表示支持ARC，
// 只有在非ARC环境下，才用到dispatch_retan和dispatch_release管理GCD对象
// 在ARC环境下，GCD的对象一般用strong修饰，非ARC环境即用assign修饰

// clang diagnostic

#if !OS_OBJECT_USE_OBJC
dispatch_source_t theReadSource = readSource;
dispatch_source_t theWriteSource = writeSource;
#endif

dispatch_source_set_cancel_handler(readSource, ^{
#pragma clang diagnostic push
#pragma clang diagnostic warning "-Wimplicit-retain-self"

    LogVerbose(@"readCancelBlock");

    #if !OS_OBJECT_USE_OBJC
    LogVerbose(@"dispatch_release(readSource)");
    dispatch_release(theReadSource);
    #endif

    if (--socketFDRefCount == 0)
    {
        LogVerbose(@"close(socketFD)");
        close(socketFD);
    }

#pragma clang diagnostic pop
});
```



参考： [fuckingclangwarnings](http://fuckingclangwarnings.com/) 