## Go接口赋值 提示

先看下代码段

	type Integer int
		return a < b
		*a += b
	
		Add(b Integer)

	var b LessAdder = a		//(2) 错
	
接口赋值用（1）还是 (2) ？

要注意到：**在为Integer类型添加函数时，Less函数为Integer值语义添，而Add函数为Integer引用语义。**这样似乎（1）和（2）都不对。实际上（1）是对的，（2）是错的。原因在于：Go语言可以根据下面函数：

	func (a Integer) Less(b Integer) bool
	
生成一个新函数：
	
	func (a *Integer) Less(b Integer) bool { 
		return (*a).Less(b)




		(&a).Add(b)
