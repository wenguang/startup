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

​	**待续** -_-/ 



KVO二次remove

UITableView或者UICollectionView的代理方法中返回空的cell