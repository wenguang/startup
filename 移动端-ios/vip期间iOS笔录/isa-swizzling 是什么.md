## isa-swizzling 是什么

method-swizzling 我们都知道是什么，那isa-swizzling双是什么呢？把isa换掉？它有什么用呢？好好奇。

上代码，看isa-swizzling装B


```Objective-c
@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

- (void)printInfo;

@end

@implementation Person

- (void)printInfo {
    NSLog(@"isa:%@, supper class:%@", NSStringFromClass(object_getClass(self)), class_getSuperclass(object_getClass(self)));
    NSLog(@"self:%@, [self superclass]:%@", self, [self superclass]);
    NSLog(@"age setter function pointer:%p", class_getMethodImplementation(object_getClass(self), @selector(setAge:)));
    NSLog(@"name setter function pointer:%p", class_getMethodImplementation(object_getClass(self), @selector(setName:)));
    NSLog(@"printInfo function pointer:%p", class_getMethodImplementation(object_getClass(self), @selector(printInfo)));
    
}

@end

// 既然是KVO嘛，那我们就来模拟一个虚假的KVO的情况，并且打印对应的信息
Person *person = [[Person alloc] init];
NSLog(@"Before add observer--------------------------------------------------------------------------");
[person printInfo];
[person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:NULL];
NSLog(@"After add observer--------------------------------------------------------------------------");
[person printInfo];
[person removeObserver:self forKeyPath:@"age"];
NSLog(@"After remove observer--------------------------------------------------------------------------");
[person printInfo];

//输出
2017-02-06 16:09:49.439 ZPRuntimeTry[83594:5539518] Before add observer--------------------------------------------------------------------------
2017-02-06 16:09:49.440 ZPRuntimeTry[83594:5539518] isa:Person, supper class:NSObject
2017-02-06 16:09:49.440 ZPRuntimeTry[83594:5539518] self:<Person: 0x100100280>, [self superclass]:NSObject
2017-02-06 16:09:49.440 ZPRuntimeTry[83594:5539518] age setter function pointer:0x100001180
2017-02-06 16:09:49.440 ZPRuntimeTry[83594:5539518] name setter function pointer:0x100001120
2017-02-06 16:09:49.440 ZPRuntimeTry[83594:5539518] printInfo function pointer:0x100000fc0
2017-02-06 16:09:49.441 ZPRuntimeTry[83594:5539518] After add observer--------------------------------------------------------------------------
2017-02-06 16:09:49.441 ZPRuntimeTry[83594:5539518] isa:NSKVONotifying_Person, supper class:Person
2017-02-06 16:09:49.441 ZPRuntimeTry[83594:5539518] self:<Person: 0x100100280>, [self superclass]:NSObject
2017-02-06 16:09:49.441 ZPRuntimeTry[83594:5539518] age setter function pointer:0x7fff9a8a9711
2017-02-06 16:09:49.441 ZPRuntimeTry[83594:5539518] name setter function pointer:0x100001120
2017-02-06 16:09:49.441 ZPRuntimeTry[83594:5539518] printInfo function pointer:0x100000fc0
2017-02-06 16:09:49.441 ZPRuntimeTry[83594:5539518] After remove observer--------------------------------------------------------------------------
2017-02-06 16:09:49.441 ZPRuntimeTry[83594:5539518] isa:Person, supper class:NSObject
2017-02-06 16:09:49.441 ZPRuntimeTry[83594:5539518] self:<Person: 0x100100280>, [self superclass]:NSObject
2017-02-06 16:09:49.441 ZPRuntimeTry[83594:5539518] age setter function pointer:0x100001180
2017-02-06 16:09:49.442 ZPRuntimeTry[83594:5539518] name setter function pointer:0x100001120
2017-02-06 16:09:49.442 ZPRuntimeTry[83594:5539518] printInfo function pointer:0x100000fc0
```

**添加Observer**

* 通过runtime偷偷实现了一个子类，并且以NSKVONotifying_+类名来命名，以上的isa指向的类名变了。
* 将之前那个对象的isa指针指向了这个子类。以上super class 由NSObject变成了Person。
* 重写了观察的对象setter方法，并且在重写的中添加了willChangeValueForKey:以及didChangeValueForKey: 。以上的age的实现函数地址变了。

**移除Observer**

* 只是简单的将其的isa指向原来的类对象中。


**所以还有个额外的提醒：不要用isa来判断继承关系，而是用[xx class]来判断。**