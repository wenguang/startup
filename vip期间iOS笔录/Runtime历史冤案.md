## Runtime 历史冤案

### 历史冤案一

**[obj class] 和 object_getClass(obj)，what! 它们有不同吗？来人...**

先来看下这段代码及其输出

```Objective-c
// [self class] 和 object_getClass() 的不同
Class obj = [NSObject class];
Class cls = object_getClass(obj);
Class cls2 = [obj class];
NSLog(@"cls [%p] is %@meta class", cls, class_isMetaClass(cls) ? @"" : @"not ");
NSLog(@"cls [%p] is %@meta class", cls2, class_isMetaClass(cls2) ? @"" : @"not ");

//输出：
2017-02-06 14:08:37.876 ZPRuntimeTry[83324:5481171] cls [0x7fff77581118] is meta class
2017-02-06 14:08:37.877 ZPRuntimeTry[83324:5481171] cls2 [0x7fff775810f0] is not meta class
```

objc的对象模型有一个关系：object ——> class ——> meta class。

* obj为对象时，[obj class] 指向 class层面
* **obj为class时，[obj class] 指向 class层面**
* **obj为meta class时，[obj class] 指向 meta class层面**
* obj为对象时，object_getClass(obj) 指向 class层面
* obj为class时，object_getClass(obj) 指向 meta class层面
* **obj为meta class时，object_getClass(obj) 指向 meta class层面，NSObject 的 meta class 指向自己，最终都指定 NSObject，object_getClass就是返回isa指针**


### 历史冤案二

来看看冤案是怎样发生的，来人、上代码

```Objective-c
// isKindOfClass 与 isMemberOfClass 的不同
BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
BOOL res3 = [(id)[TestObj class] isKindOfClass:[TestObj class]];
BOOL res4 = [(id)[TestObj class] isMemberOfClass:[TestObj class]];
NSLog(@"%hhd, %hhd, %hhd, %hhd", res1, res2, res3, res4);

//输出
2017-02-06 14:51:09.902 ZPRuntimeTry[83408:5499259] 1, 0, 0, 0
```

**其实冤案二也是由冤案一引起的，what?** 我们来看下runtime中关于isKindOfClass和isMemberOfClass的实现就明白了。

```Objective-c
+ (BOOL)isMemberOfClass:(Class)cls {
    return object_getClass((id)self) == cls;
}

- (BOOL)isMemberOfClass:(Class)cls {
    return [self class] == cls;
}

+ (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = object_getClass((id)self); tcls; tcls = class_getSuperclass(tcls)) {
        if (tcls == cls) return YES;
    }
    return NO;
}

- (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = [self class]; tcls; tcls = class_getSuperclass(tcls)) {
        if (tcls == cls) return YES;
    }
    return NO;
}
```

看完后，是不是有种喊‘破喉咙’都没人理的感觉，哈哈哈...
