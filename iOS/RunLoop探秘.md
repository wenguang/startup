runloop是基于pthread管理的，与pthread一一对应，pthread刚创建是没有runloop，这从CFRunLoop.c源码中可看出

```c
// should only be called by Foundation
// t==0 is a synonym for "main thread" that always works
CF_EXPORT CFRunLoopRef _CFRunLoopGet0(pthread_t t) {
    if (pthread_equal(t, kNilPthreadT)) {
	t = pthread_main_thread_np();
    }
    __CFLock(&loopsLock);
    if (!__CFRunLoops) {
        __CFUnlock(&loopsLock);
	CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorSystemDefault, 0, NULL, &kCFTypeDictionaryValueCallBacks);
	CFRunLoopRef mainLoop = __CFRunLoopCreate(pthread_main_thread_np());
	CFDictionarySetValue(dict, pthreadPointer(pthread_main_thread_np()), mainLoop);
	if (!OSAtomicCompareAndSwapPtrBarrier(NULL, dict, (void * volatile *)&__CFRunLoops)) {
	    CFRelease(dict);
	}
	CFRelease(mainLoop);
        __CFLock(&loopsLock);
    }
    CFRunLoopRef loop = (CFRunLoopRef)CFDictionaryGetValue(__CFRunLoops, pthreadPointer(t));
    __CFUnlock(&loopsLock);
    if (!loop) {
	CFRunLoopRef newLoop = __CFRunLoopCreate(t);
        __CFLock(&loopsLock);
	loop = (CFRunLoopRef)CFDictionaryGetValue(__CFRunLoops, pthreadPointer(t));
	if (!loop) {
	    CFDictionarySetValue(__CFRunLoops, pthreadPointer(t), newLoop);
	    loop = newLoop;
	}
        // don't release run loops inside the loopsLock, because CFRunLoopDeallocate may end up taking it
        __CFUnlock(&loopsLock);
	CFRelease(newLoop);
    }
    if (pthread_equal(t, pthread_self())) {
        _CFSetTSD(__CFTSDKeyRunLoop, (void *)loop, NULL);
        if (0 == _CFGetTSD(__CFTSDKeyRunLoopCntr)) {
            _CFSetTSD(__CFTSDKeyRunLoopCntr, (void *)(PTHREAD_DESTRUCTOR_ITERATIONS-1), (void (*)(void *))__CFFinalizeRunLoop);
        }
    }
    return loop;
}
```



苹果不允许直接创建RunLoop



Runloop的每一次loop只能运行一种mode，要切换mode就得退出loop，再指定一种mode重新进入loop



Runloop有若干mode，每个mode下有\<set\>Source、\<Array\>Timer、\<Array\>Observer ，Source/Timer/Observer 被统称为 **mode item**，一个 item 可以被同时加入多个 mode，从代码定义中可看出

```c
struct __CFRunLoopMode {
    CFStringRef _name;            // Mode Name, 例如 @"kCFRunLoopDefaultMode"
    CFMutableSetRef _sources0;    // Set
    CFMutableSetRef _sources1;    // Set
    CFMutableArrayRef _observers; // Array
    CFMutableArrayRef _timers;    // Array
    ...
};
 
struct __CFRunLoop {
    CFMutableSetRef _commonModes;     // Set
    CFMutableSetRef _commonModeItems; // Set<Source/Observer/Timer>
    CFRunLoopModeRef _currentMode;    // Current Runloop Mode
    CFMutableSetRef _modes;           // Set
    ...
};
```



无论是CFRunLoopSourceRef、CFRunLoopTimerRef 还是 CFRunLoopObserverRef，都含有一个回调，

当RunLoop被唤醒时会执行这个回调



source0和source1是啥不同？

timer被加入RunLoop时，RunLoop会注册一个时间点，当到点时RunLoop被唤醒，对repeat的timer，RunLoop是怎样注册时间点的呢？

observer好理解，RunLoop本身有各种状态，当到达不同状态时，RunLoop通过回调参数告知observer，这些状态有：

```c
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
    kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
    kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
    kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
    kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
    kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
};
```



当RunLoop所有mode下都没有mode item时，RunLoop就会退出了。怎样启动一个RunLoop呢？



“CommonMode” 概念，

> 场景：如果想一个timer有RunLoop有不同mode都能响应，一是把timer在不同mode下都加入一次，二就是CommonMode了，就相当于把多个不同的mode属到同一类，那些同一类的mode就都能咱就timer了。比如主线程下的kCFRunLoopDefaultMode和UITrackingRunLoopMode被标为"CommonMode"，在scroll滚动时也能响应倒计时。



未完待续...



参考：[深入理解RunLoop](http://blog.ibireme.com/2015/05/18/runloop/) 