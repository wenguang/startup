## sass与compass简介

####sass

阮兄的文章：[SASS用法指南](http://www.ruanyifeng.com/blog/2012/06/sass.html) ，写得很简洁，可供编程查阅，以下是其文中的一段。

> 本文总结了SASS的主要用法。我的目标是，有了这篇文章，日常的一般使用就不需要去看[官方文档](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html)了。



*sass是用ruby编写的，`sudo gem install sass`安装，使用就用`sass input.scss out.css`，把.scss转化为css* 



**总结sass的用法** 

* 基本用法：变量、计算功能、嵌套、注释
* 代码重用：继承、Mixin、颜色函数、插入文件
* 高级用法：条件语句、循环语句、自定义函数



#### compass

*之所以把sass与compass放在一起介绍，是因为compass才能让sass发挥真正的威力，compass是sass的一个工具，它让.scss文件转化为.css文件更方便* 

**安装**  

> sudo gem install compass

**初始化** 

> compass create mydir

*多出一个config.rb文件，一个sass目录存放.scss文件，一个stylesheets目录存放转化后的.css文件* 

**编译** 

> compass compile

*转化.scss为.css，编译有很多选项：* 

```shell
compass compile --output-style compressed	//压缩css
compass compile --force					   //只编译变动的文件
compass watch		//自动编译，运行后，要只scss文件变动就自动编译
```

*也可以在config.rb里配置编译选项* 



compass模块 请看 [Compass用法指南](http://www.ruanyifeng.com/blog/2012/11/compass.html) 