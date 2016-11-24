## Go接口赋值 提示

先看下代码段

	type Integer int	func (a Integer) Less(b Integer) bool { 
		return a < b	}	func (a *Integer) Add(b Integer) { 
		*a += b	}
		type LessAdder interface { 		Less(b Integer) bool 
		Add(b Integer)	}
	var a Integer = 1	var b LessAdder = &a	//(1) 对
	var b LessAdder = a		//(2) 错
	
接口赋值用（1）还是 (2) ？

要注意到：**在为Integer类型添加函数时，Less函数为Integer值语义添，而Add函数为Integer引用语义。**这样似乎（1）和（2）都不对。实际上（1）是对的，（2）是错的。原因在于：Go语言可以根据下面函数：

	func (a Integer) Less(b Integer) bool
	
生成一个新函数：
	
	func (a *Integer) Less(b Integer) bool { 
		return (*a).Less(b)	}
这样，类型*Integer就既存在Less()方法，也存在Add()方法，满足LessAdder接口。而2 从另一方面来说，根据
	func (a *Integer) Add(b Integer) 
这个函数无法自动生成以下这个成员方法:
	func (a Integer) Add(b Integer) { 
		(&a).Add(b)	}
**因为(&a).Add()改变的只是函数参数a，对外部实际要操作的对象并无影响**，这不符合用户的预期。所以，Go语言不会自动为其生成该函数。