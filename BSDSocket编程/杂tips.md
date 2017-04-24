CocoaAsyncSocket用缩写as表示

as有个cfstreamThread，但它不是对象持有，而是static的，

as实例持有连接定时器，dispatch_source_t类型



**as中的方法写的很严紧，值得借鉴** 

1、很多方法以BOOL为返回值，指示方法执行是否成功，特别是BSD Socket API很 函数的返回为int来指示成功与否，而返回数据以指针为输出参数完成，这种情况下，以BOOL为返回值的写法就更有用了。

2、即便一个小功能也有很多检测代码，包括对输入参数的检测、调用系统API返回值和输出参数的检测，还有实例变量的检测。

3、很多方法传入一个错误指针作为输出参数。



**as的代码写得简洁，值得借鉴** 

1、block的return只是退出block，非退出方法，为了区别用宏：return_from_block = return。



**队列使用的tips** 

```objective-c
// 有些方法中用以下代码
if (dispatch_get_specific(IsOnSocketQueueOrTargetQueueKey))
    block();
else
    dispatch_sync(socketQueue, block);

// 被以下block中调用到的方法中用以下代码
NSAssert(dispatch_get_specific(IsOnSocketQueueOrTargetQueueKey), @"Must be dispatched on socketQueue");
```



```objective-c
// 
long portL = strtol([[components objectAtIndex:1] UTF8String], NULL, 10);

/**
str 为要转换的字符串，endstr 为第一个不能转换的字符的指针，base 为字符串 str 所采用的进制，参数 base 范围从2 至36，或0。参数base 代表 str 采用的进制方式，如base 值为10 则采用10 进制，若base 值为16 则采用16 进制等。两点注意：
当 base 的值为 0 时，默认采用 10 进制转换，但如果遇到 '0x' / '0X' 前置字符则会使用 16 进制转换，遇到 '0' 前置字符则会使用 8 进制转换。
若endptr 不为NULL，则会将遇到的不符合条件而终止的字符指针由 endptr 传回；若 endptr 为 NULL，则表示该参数无效，或不使用该参数。
*/
long int strtol (const char* str, char** endptr, int base);


bzero(&saddr,sizeof(saddr)); 
```

