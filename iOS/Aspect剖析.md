## Aspects 剖析

### 核心机制
**Aspects是利用_objc_msgForward机制实现的。**

我们知道当**_objc_msgSend**找到方法的IMP时，runtime就会调用**_objc_msgForword**进行消息转发，而在_objc_msgForword**中执行**resolveInstanceMethod、forwardingTargetForSelector、methodSiguatureForSelector都没能得到IMP后，会调用到**forwardInvocation**，当**forwardInvocation**也得不到IMP，那就能调用**doesNotRecognizeSelector**并抛出异常了（详见[消息转发](https://github.com/wenguang/startup/blob/master/objc-message-forwarding.md)）。

**Aspects**做的事就是把**_objc_msgForward**的最后一步**forwardInvocation**的IMP指向了ASPECTS_ARE_BEING_CALLED__函数，再把原始调用的selector的IMP指向_objc_msgForward函数，也就是调用原始方法会被强行进行消息转发，而会执行____ASPECTS_ARE_BEING_CALLED__函数。而____ASPECTS_ARE_BEING_CALLED__最终会执行我们指定的一个block来替代SEL原先的实现。

***以上实现要在selector所在类的子类，参考 aspect_hookClass***

### 调用串连
**指定的block和forwardInvocation原始的NSInvocation是怎样串连起来的？**

我们在aspect_hookSelector方法的第3个参数指定一个block来替代第2个参数SEL的实现，**Aspects规定block的参数>=1，第1个参数必须为id\<AspectInfo\>**，block的第2参数对应SEL的第1参数，以此类推。**block中定义的参数得由Aspects内部提供的**，id\<AspectInfo\>是个保存着从forwardInvocation的原始NSInvocation中得到调用对象和调用参数的对象。那调用的序列大致是以下步骤：

1、Aspects保存从我们定义的block，且获取到block的方法签名（**NSMethodSignature**）并保存着。**(如何获取block的方法签名，下面我们会讲到）**。


2、原始方法被调用，代码会执行到**___ASPECTS_ARE_BEING_CALLED**函数（这个上面讲到）。我们知道**IMP**的定义为：**typedef id (*IMP)(id, SEL, ...)**，参数中的id为调用对象，SEL为调用的selector，因为__ASPECTS_ARE_BEING_CALLED_是替代了forwardInvocation:的实现，所以第3个数就是原始的NSInvocation。从而可以取得原始调用对象、原始调用的参数值。 **（如何从NSInvocation中取参数值下面会讲到）**

3、用步骤1中的block方法签名生成一个NSInvocation，再把从原始NSInvocation中取得的参数值赋值给block的NSInvocation **（NSInvocation的参数赋值下面会讲到）**，最后调用 **[blockInvocation invokeWithTarget:self.block];** 这样就完成了给我们定义的block的调用。

### 获取block的方法签名

我们知道block是一个对象，它的内部结构可参考 [Block Implementation Specification](https://clang.llvm.org/docs/Block-ABI-Apple.html)，[Block深究浅析(上篇)-Block本质](http://1gcode.com/2015/10/03/notes-iOS-Block01/)，它的结构是这样的：

	struct Block_literal_1 {
	    void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
	    int flags;
	    int reserved;
	    void (*invoke)(void *, ...);
	    struct Block_descriptor_1 {
	    	unsigned long int reserved;         // NULL
	        unsigned long int size;         // sizeof(struct Block_literal_1)
	        // optional helper functions
	        void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
	        void (*dispose_helper)(void *src);             // IFF (1<<25)
	        // required ABI.2010.3.16
	        const char *signature;                         // IFF (1<<30)
	    } *descriptor;
	    // imported variables
	};

可以看到 const char *signature，它就是block签名指针了。Aspects定义了AspectBlockRef结构体，它就是对应block的结构，Aspects把我们定义的block赋值给这个结构体，于是用以下代码找到block中方法签名的指针：
​	
	//layout是个AspectBlockRef结构体
	void *desc = layout->descriptor;
	desc += 2 * sizeof(unsigned long int);
	if (layout->flags & AspectBlockFlagsHasCopyDisposeHelpers) {
		desc += 2 * sizeof(void *);
	}
	...
	const char *signature = (*(const char **)desc);
	return [NSMethodSignature signatureWithObjCTypes:signature];

### NSInvocation参数的取值与赋值

来看到下面几个方法定义

	//NSMethodSignature
	- (const char *)getArgumentTypeAtIndex:(NSUInteger)idx
	
	//NSInvocation
	- (void)getArgument:(void *)argumentLocation atIndex:(NSInteger)idx;
	- (void)setArgument:(void *)argumentLocation atIndex:(NSInteger)idx;

可以看到getArgument是把取得第idx的参数值写到argumentLocation指向的内存中，而setArgument是把argumentLocation指向的内存数据赋值给第idx的参数。

**所以argumentLocation的内存空间是要手动分配的，且分配的内存大小要能满足第idx的参数类型的需要**。就要用到getArgumentTypeAtIndex取得参数的类型，它的返回是**const char ***，是个指针，类型编码请参考 ：[Type Encodings](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html)。**通常这样判断类型编码：strcmp(argType, @encode(unsigned int)) == 0**

对于数值类型或char *类型，可这样简单地读值：**type val = 0; [self getArgument:&val atIndex:(NSInteger)index];**

但NSInvocation的参数中若有block、SEL、Class、id，可这样读值：

	if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
		__autoreleasing id returnObj;
		[self getArgument:&returnObj atIndex:(NSInteger)index];
		return returnObj;
	} else if (strcmp(argType, @encode(SEL)) == 0) {
	       SEL selector = 0;
	       [self getArgument:&selector atIndex:(NSInteger)index];
	       return NSStringFromSelector(selector);
	   } else if (strcmp(argType, @encode(Class)) == 0) {
	       __autoreleasing Class theClass = Nil;
	       [self getArgument:&theClass atIndex:(NSInteger)index];
	       return theClass;
	} else if (strcmp(argType, @encode(void (^)(void))) == 0) {
		__unsafe_unretained id block = nil;
		[self getArgument:&block atIndex:(NSInteger)index];
		return [block copy];
	}

**也可以这样读值：**

	const char *argType;
	NSUInteger argSize;
	NSGetSizeAndAlignment(argType, &argSize, NULL);
	void *argBuf = NULL;
	argBuf = reallocf(argBuf, argSize)
	return [NSValue valueWithBytes:argBuf objCType:argType];

我们注意到这样一个函数：**const char *NSGetSizeAndAlignment(const char *typePtr, NSUInteger * _Nullable sizep, NSUInteger * _Nullable alignp);** 把类型的大小读到argSize中，然后reallocf分配一块内存来存储NSInvocation读取出的参数值。

