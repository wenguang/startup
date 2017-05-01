```objective-c

///--------------------------------- GCD事件监听处理步骤 -------------------------------------//

// 例子：监听socket4FD上的读事件，socket4FD是调用了listen函数，但还未调用accept函数socket描述符
dispatch_source_t accept4Source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, socket4FD, 0, socketQueue);
/**
创建一个监听事件

@param type 要监听的事件类型
@param handle 可以理解为句柄、索引或文件描述符，如：socket描述符、进程号
@param mask 根据参数2，可以理解为描述，提供更详细的描述，让它知道具体要监听什么
@param queue：当事件发生时，将block添加至哪个队列来执行，这个block用dispatch_source_set_event_handler函数来调用
@return 返回 dispatch_source_t
 */
dispatch_source_t dispatch_source_create(dispatch_source_type_t type,  uintptr_t handle,  unsigned long mask, dispatch_queue_t queue);  

// 监听的事件类型如下
DISPATCH_SOURCE_TYPE_TIMER        定时响应
DISPATCH_SOURCE_TYPE_SIGNAL      接收到UNIX信号时响应
DISPATCH_SOURCE_TYPE_READ   	IO操作，如对文件的操作、socket操作的读响应
DISPATCH_SOURCE_TYPE_WRITE     IO操作，如对文件的操作、socket操作的写响应   
DISPATCH_SOURCE_TYPE_VNODE    文件状态监听，文件被删除、移动、重命名
DISPATCH_SOURCE_TYPE_PROC  		进程监听,如进程的退出、创建一个或更多的子线程、进程收到UNIX信号
DISPATCH_SOURCE_TYPE_MACH_SEND
DISPATCH_SOURCE_TYPE_MACH_RECV   上面2个都属于Mach相关事件响应
DISPATCH_SOURCE_TYPE_DATA_ADD
DISPATCH_SOURCE_TYPE_DATA_OR     上面2个都属于自定义的事件，并且也是有自己来触发
 

/**设置事件*/
  
// 当事件发生时的block
dispatch_source_set_event_handler(accept4Source, ^{ @autoreleasepool {}});
// dispatch源取消时调用的block，一般用于关闭文件或socket、释放相关资源
dispatch_source_set_cancel_handler(accept4Source, ^{});
// 如果dispatch_source_t是定时器，还得用dispatch_source_set_timer方法设置下定时器的启动时间、fire间隔、和leeway，fire间隔用 DISPATCH_TIME_FOREVER 表示 ‘a short time’
dispatch_source_set_timer(connectTimer, tt, DISPATCH_TIME_FOREVER, 0);

/**
 启动事件监听
 
 参数是dispatch_object_t
 所以它可以是dispatch_queue_t、dispatch_source_t、dispatch_timer_t，也可是其他对象
 dispatch对象内部维护着一挂起记数，dispatch_suspend增加这个记数，dispatch_resume则相反，当记数清0时，
 事件block就进入调度之中，dispatch_resume和dispatch_activate一样，用dispatch_resume为了向前兼容，
 新代码建议使用dispatch_activate
 */
void dispatch_suspend(dispatch_object_t object);
void dispatch_resume(dispatch_object_t object);
void dispatch_activate(dispatch_object_t object);

/**
 读取事件数据
 
 这个函数对于监听不同的事件，读取的值是不同的
 对于以socketFD，listen()之后，accept()之前，读到的值为  numPendingConnections到底是什么意思？
 对已经和远程建立好连接的socketFD，读取的值是客户端发来可读数据字节数，从CocoaAsyncSocket上看是这样的
 */
unsigned long dispatch_source_get_data(dispatch_source_t source);

unsigned long i = 0;
unsigned long numPendingConnections = dispatch_source_get_data(acceptSource);
LogVerbose(@"numPendingConnections: %lu", numPendingConnections);
while ([strongSelf doAccept:socketFD] && (++i < numPendingConnections));

// 关闭事件监听
// 它会触发dispatch_source_set_cancel_handler中设置的handler
// 关闭后记得请空事件 source=NULL
dispatch_source_cancel(source);
source = NULL;
```



```objective-c
// 保证代码在指定的queue执行，设置这个标识
// 指定队列里面设置一个标识
dispatch_queue_set_specific(dispatch_queue_t queue, const void *key,
	void *_Nullable context, dispatch_function_t _Nullable destructor);

// 获取queue标识
dispatch_queue_get_specific(dispatch_queue_t queue, const void *key);
// 获取当前queue标识
dispatch_get_specific(const void *key);
```





参考：[dispatch source 重要函数](http://blog.doorxp.com/archives/78/)、[dispatch_source学习](http://www.jianshu.com/p/2f6eed90bb9d) 