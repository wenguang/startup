## Go Unicode字符——rune和byte的陷阱

先看代码段

	hello := "Hello, 世界"
	fmt.Println(len(hello))
	
运行结果是13	

英文字母、半角逗号和空格用一个字节，即ASC码可表示，中文字符则要用3个字节表示，合计为13。[字符编码参考](https://zhidao.baidu.com/question/1047887004693001899.html?qbl=relate_question_1&word=%D6%D0%CE%C4%D7%D6%B7%FBascii%C2%EB)

**既然字符串中有多种编码长度的字符表示，那我们也该如何获取字符串中每个字符呢？**

	for _, c := range hello {
		fmt.Println(c)		
	}
	
这样可以打印出各个字符了，那如果想比较字符串里前后字符是否相同，要怎么做呢？你可能很自然地想到以后代码

	for i, c := range hello {
		if i < len(hello)-1 {
			fmt.Println(string(hello[i+1]) == string(c))
		}
	}
	
但很遗憾，输出是：false false false false 。 这是为什么呢？**因为c是rune类型，还在取到‘世’字符时，c为'世‘，而hello[i+1]则是'世'字符的3个字节中第二个字节，记住！string类型用数组脚标取值如：hello[i]时，它取得实际是变量hello表示的字符串中的第i个字节。这是原因所在。**

那要怎样做前后字符的比较呢？看以下代码

	word := "Hello"
	s := []byte(word)
	for utf8.RuneCount(s) > 1 {
		r, size := utf8.DecodeRune(s)
		s = s[size:]
		nextR, size := utf8.DecodeRune(s)
		fmt.Print(r == nextR, ",")
	}
	
输入为：false,false,true,false, 这是我们要的结果。**unicode/utf8包的DecodeRune就是解析出单个字符，也是它可以定位出字符开始的字节点。**

	 