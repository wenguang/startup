## 接口 —— Go编程哲学的基石

### Go的接口不同于JAVA、C#等语言的接口

在学习JAVA、C#语言时，我们通常都被告知OOP、接口是如何能体现现实世界的样子，它如何让我们能更好地用接近现实世界的思维去组织我们的程序。诚然，我们享受到这样的好处。**但这些语言对接口的实现仍很有争议。**

下面我们要讨论下为什么这么说。

> *设想我们现在要实现一个简单  引 (SE),它需要依赖两个模 ,一个是 希表(HT), 一个是HTML分析器(HtmlParser)。*

> *搜索引擎的实现者认为,SE对HT的依赖是确定性的,所以不需要在SE和HT之间定义接口, 而是直接通过import(或者include)的方式使用HT;而模 SE对HtmlParser的依赖是不确定 的,未来可能需要有WordParser、PdfParser等模 来 代HtmlParser,以达到不同的业务要求。为此,他定义了SE和HtmlParser之间的接口,在模 SE中通过接口调用方式间接引用模块HtmlParser。*

> *应当注意到,接口的需求方是SE,只有SE才知道接口应该定义成什么样子,但是接口的实 现方是HtmlParser。基于模 设计的单向依赖原则,模 HtmlParser实现自身的业务时,不应该关 心某个具体使用方的要求。HtmlParser在实现的时候,  还不知道未来有一天SE会用上它。*

> *期望模块HtmlParser能够知道需求方需要的所有接口,并提前 明实现这些接口是不合理的。 同样的道理发生在SE自己身上。SE并不能够 计未来会有哪些需求方会用到自己,并且实现它们所要求的接口。*
 
**从上面例子可以看出我们写程序的思维是这样的：先可能多归纳调用方需求，抽象出接口的定义，然后实现方们按着接口的定义去实现。这样的思维本来就和现实世界不太一致。**

想不明白？看下面小故事

> *万能的大自然（实现方）造了一条了小溪，它流过你家门前，你（调用方）想用小溪的水灌你家的菜园子，于是用一个管子（接口）去引水到菜园子。这是实现世界的样子。先是实现方造了一个事物，这里就是大自然造了小溪，然后调用方用接口调用实现方的事物，这里就是你用管子引水。*

**想象下一下，先是你设计了一个管子，然后让大自然按管子规格去造一个小溪，说：嗯，按这样子去造条小溪吧，我要用。很不合理吧**

正是因为这种不合理的设计,实现Java、C#类库中的每个类时都需要纠结以下两个问题：

* 我提供哪些接口好呢?* 如果两个类实现了相同的接口,应该把接口放到哪个包好呢?


### Go的解决方案 —— 非侵入式接口

在Go语言中,一个类只需要实现了接口要求的所有函数,我们就说这个类实现了该接口,例如:

	// File类
	type File struct { // ...	}	func (f *File) Read(buf []byte) (n int, err error)	func (f *File) Write(buf []byte) (n int, err error)	func (f *File) Seek(off int64, whence int) (pos int64, err error) 
	func (f *File) Close() error
	
	// IFile接口
	type IFile interface {	Read(buf []byte) (n int, err error)	Write(buf []byte) (n int, err error)	Seek(off int64, whence int) (pos int64, err error) Close() error	}		// IReader接口	type IReader interface {	Read(buf []byte) (n int, err error)	}
	// IWriter接口	type IWriter interface {	Write(buf []byte) (n int, err error)	}
	// iCloser接口	type ICloser interface { Close() error	}

尽管File类并没有从这些接口继承，甚于可以不知道这些接口的存在，但是File类实现了这些接口，可以进行赋值:

	var file1 IFile = new(File) 
	var file2 IReader = new(File) 
	var file3 IWriter = new(File) 
	var file4 ICloser = new(File)

Go语言的非侵入式接口，看似只是做了很小的文法调整，**实则影响深远**。* **其一，Go语言的标准库，再也不需要绘制类库的继承树图。你一定见过不少C++、Java、C# 类库的继承树图。在Go中，类的继承树并无意义，你只需要知道这个类实现了哪些方法,每个方法是啥含义就足够了。**
* **其二，实现类的时候,只需要关心自己应该提供哪些方法,不用再纠结接口需要拆得多细才算合理。接口由使用方按需定义,而不用事前规划。**
* **其三，不用为了实现一个接口而导入一个包,因为多引用一个外部的包，就意味着更多的耦合。接口由使用方按自身需求来定义，使用方无需关心是否有其他模块定义过类似的接口。**

更多Go接口知识参考《Go语言编程》3.5 章节
