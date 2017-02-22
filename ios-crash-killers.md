### Crash处理

1、**NSInvalidArgumentException** 

* 如NSDictionary、NSMutableDictionary的key为nil，解决方案：用runtime把NSDictionary的initWithObjects:forKeys:count: 及 dictionaryWithObjects:forKeys:count: 的实现替换，在替换方法中做检测保护 

* JSON序列化

* an unrecognized selector  也是其中的一种

  参考 [NSDictionary-NilSafe](https://github.com/allenhsu/NSDictionary-NilSafe) 

2、**SIGSEGV** 

​	当去访问没有被开辟的内存或者已经被释放的内存时，就会发生这样的异常。另外，在低内存的时候，也可能会产生这样的异常。

剖析facebook的组件（[FBRetainCycleDetector](https://github.com/facebook/FBRetainCycleDetector), [FBAllocationTracker](https://l.facebook.com/l.php?u=https%3A%2F%2Fgithub.com%2Ffacebook%2FFBAllocationTracker&h=ATP53K5ZoJaVf_5Ul-Nu_xLW-PinhXWQRaNt7s_ERISgYWfw2RQ7EKi1JXVmLVlQxjady8OdAd7QagFPb3m5ZIuoaI_8KJFRQffAJkx6peKR7mjwutwNJAjMsBfMaa0njQ&s=1),  [FBMemoryProfiler](https://l.facebook.com/l.php?u=https%3A%2F%2Fgithub.com%2Ffacebook%2FFBMemoryProfiler&h=ATOPGozjBqXHXNmJFn5_XG_1whYY9rDPElLjjSik1dtCFxAWS3lGW3D_vcq6eDiCZpjDTZntBfMaeGn09OaFwi25QfHHvOj3AUOPVwu15e5LysufidwB0qcNRl06HUkk5g&s=1).）**待续** -_-/ 

3、**NSRangeException** 

利用runtime的Swizzle Method做保护，\_\_NSArray0、\_\_NSArray1、\_\_NSArrayM

4、**EXC_BAD_ACCESS** 

​	**待续** -_-/ 

5、**SIGPIPE**

​	**待续** -_-/ 

6、**SIGABRT**

bugly如下描述：

SIG是信号名的通用前缀。ABRT是abort program的缩写。

当操作系统发现不安全的情况时，它能够对这种情况进行更多的控制，必要的话，它能要求进程进行清理工作。在调试造成此信号的底层错误时，并没有什么妙招。 如 cocos2d 或 UIKit 等框架通常会在特定的前提条件没有满足或一些糟糕的情况出现时调用 C 函数 abort （由它来发送此信号）。

发生在UIApplication WillTerminate 时，是主动退出应用时发生的，所以对用户没什么实际影响。

​	**待续** -_-/ 

参考 [**iOS Crash 杀手排名**](https://gold.xitu.io/entry/586d00ef1b69e60062c8d745) 

KVO二次remove

UITableView或者UICollectionView的代理方法中返回空的cell