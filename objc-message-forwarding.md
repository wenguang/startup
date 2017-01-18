## 消息转发 —— 补坑的机会到了

### 搞懂这张图，避免出现 *Unrecognized selector sent to instance xxx* 崩溃

![](https://raw.githubusercontent.com/wenguang/startup/master/imgs/message-forwarding.png)

**图中可以看出——在runtime在类及父类找不到对应IMP到doesNotRecognizeSelector抛出异常中间这段时间，runtime给了我们几次补坑的机会**

### 1、resoveInstanceMethod
这个NSObject的类方法，它返回一个BOOL类型，指示是否动态为SEL提供一个IMP。在这里补坑就是重载这个方法，用class_addMethod为SEL提供一个IMP，返回YES。

	void _dynamic_method_imp(id self, SEL _cmd) {
	    NSLog(@"%@的%@方法缺IMP，resolveInstanceMethod动态补坑", [self class], NSStringFromSelector(_cmd));
	}
	
	+ (BOOL)resolveInstanceMethod:(SEL)sel {
	    BOOL resolved = [super resolveInstanceMethod:sel];
	    if (!resolved) {
	        //动态一个实现_dynamic_method_imp来处理消息
	        class_addMethod([self class], sel, (IMP)_dynamic_method_imp, "v@:");
	        resolved = YES;
	    }
	    return resolved;
	}
	
	//调用
	TestObj *obj = [TestObj new];
	[obj performSelector:@selector(tt)];
	
	//输出
	2017-01-18 15:53:28.131 ZPRuntimeTry[69771:4444210] TestObj的tt方法缺IMP，resolveInstanceMethod动态补坑
	
class_addMethod最后一个参数为runtime类型编码：[Type Encodings](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1)

### 2、forwardingTargetForSelector
如果resoveInstanceMethod没动态指定一个IMP，返回NO，这时forwardingTargetForSelector（NSObject对象方法）被调用，是否指示另一个对象来执行SEL，当然指定的对象得实现这个SEL。

	- (id)forwardingTargetForSelector:(SEL)aSelector {
	    id target = [super forwardingTargetForSelector:aSelector];
	    if (!target) {
	        //指定另一对象执行SEL，当然它得实现了SEL
	        ForwardingTarget *ft = [ForwardingTarget new];
	        return ft;
	    }
	    return target;
	}
	
	@interface ForwardingTarget : NSObject
	- (void)tt;
	@end
	
	@implementation ForwardingTarget
	- (void)tt {
	    NSLog(@"%@ 的 %@ 被调用", [self class], NSStringFromSelector(_cmd));
	}
	@end
	
	//输出
	2017-01-18 16:43:25.926 ZPRuntimeTry[69840:4494676] ForwardingTarget 的 tt 被调用