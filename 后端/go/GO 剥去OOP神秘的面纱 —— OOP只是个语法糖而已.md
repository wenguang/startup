### GO 剥去OOP神秘的面纱 —— OOP只是个语法糖而已
***

在Go语言中,你可以给任意类型(包括内置类型,但不包括  类型) 加相应的方法, 例如:

	type Integer int	func (a Integer) Less(b Integer) bool { 		return a < b	} 	func main() {	var a Integer = 1 if a.Less(2) {	        fmt.Println(a, "Less 2")	    }	}
  
**我们熟知C++的对象模型也只是在C基本上加了个语法糖。下面用go在展示这个细节**

上面的这个Integer例子如果不使用Go语言的面向对象特性,而使用之前我们  的面向过程方式实现的话,相应的实现细节将如下所示:
		type Integer int	func Integer_Less(a Integer, b Integer) bool { 
		return a < b	}	func main() {	var a Integer = 1	if Integer_Less(a, 2) {	        fmt.Println(a, "Less 2")	    }	}
**在Go语言中,面向对象的神秘面纱被剥得一干二净。对比下面的两段代码:**
	func (a Integer) Less(b Integer) bool { 		//面向对象
		return a < b	}	func Integer_Less(a Integer, b Integer) bool { //面向过程     
		return a < b	}	a.Less(2) 										//面向对象的用法	Integer_Less(a, 2) 								//面向过程的用法
*可以看出,面向对象只是换了一种语法形式来表达。C++语言的面向对象之所以让有些人迷惑的一大原因就在于其隐藏的this指针。一量把隐藏的this指针显示出来,大家看到的就是一个面向过程编程。*

**我们对于一些事物的不理解或者恐惧,原因都在于这些事情所有意无意带有的绚丽外衣和神秘面纱。只要 开这一层直达本质,就会发现一切其实都很简单。**

参考：《Go语言编程》3.1.1 章节