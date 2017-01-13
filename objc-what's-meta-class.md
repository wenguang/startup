## 搞懂 meta-class

**我以前一直搞不懂这张图**

![](https://raw.githubusercontent.com/wenguang/startup/master/imgs/object-class-metaclass.png)

	+ (void)testmetaClass {
	    Class newClass =
	    objc_allocateClassPair([NSError class], "RuntimeErrorSubclass", 0);
	    class_addMethod(newClass, @selector(report), (IMP)ReportFunction, "v@:");
	    objc_registerClassPair(newClass);
	    
	    id instanceOfNewClass =
	    [[newClass alloc] initWithDomain:@"someDomain" code:0 userInfo:nil];
	    [instanceOfNewClass performSelector:@selector(report)];
	}
	
	void ReportFunction(id self, SEL _cmd)
	{
	    NSLog(@"This object is %p.", self);
	    NSLog(@"Class is %@, and super is %@.", [self class], [self superclass]);
	    
	    Class currentClass = [self class];
	    for (int i = 1; i < 5; i++)
	    {
	        NSLog(@"Following the isa pointer %d times gives %p name %@", i, currentClass, NSStringFromClass(currentClass));
	        if (class_isMetaClass(currentClass)) {
	            NSLog(@"MetaClass %@ 's super class name %@", NSStringFromClass(currentClass), NSStringFromClass(class_getSuperclass(currentClass)));
	        }
	        currentClass = object_getClass(currentClass);
	    }
	    
	    NSLog(@"NSObject's class is %p", [NSObject class]);
	    NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));
	}
	
**下面是输出，这样就可以看懂了**

	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] This object is 0x100106440.
	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] Class is RuntimeErrorSubclass, and super is NSError.
	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] Following the isa pointer 1 times gives 0x100106a30 name RuntimeErrorSubclass
	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] Following the isa pointer 2 times gives 0x100106290 name RuntimeErrorSubclass
	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] MetaClass RuntimeErrorSubclass 's super class name NSError
	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] Following the isa pointer 3 times gives 0x7fff77581118 name NSObject
	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] MetaClass NSObject 's super class name NSObject
	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] Following the isa pointer 4 times gives 0x7fff77581118 name NSObject
	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] MetaClass NSObject 's super class name NSObject
	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] NSObject's class is 0x7fff775810f0
	2017-01-13 15:04:59.623 ZPRuntimeTry[58126:3674515] NSObject's meta class is 0x7fff77581118
	

参考：**[Objective-C 中的 Meta-class 是什么？](http://www.cocoachina.com/industry/20131210/7508.html)**