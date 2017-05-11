**会不会写makefile，从一个侧面说明了一个人是否具备完成大型工程的能力** 



**[GNU make 手册](https://www.gnu.org/software/make/manual/make.html)** 

**[Makefile经典教程（掌握这些足够）](http://blog.csdn.net/ruglcc/article/details/7814546/)** 



**libco中有makefile、co.mk这样两个文件，里面加了注释：[libco-anls](https://github.com/wenguang/libco_anls)，详细参考： [Make 命令教程](http://www.ruanyifeng.com/blog/2015/02/make.html) **  

```sh
$ make 	# 找到makefile或Makefile文件，按其描述的规则构建makefile中的第一个目标

# 按rules.txt描述的规则构建程序
$ make -f rules.txt
# 或者
$ make --file=rules.txt
```

**规则格式** 

```shell
<target> : <prerequisites> 
[tab]  <commands>	# 命令必须以tab起头
```

**多行命令** 

```shell
# 以下只会输出 hello，因为每行命令都在单独的shell中执行
print:
	echo "hello"
	echo "world"

# 以下几种正确写法

print:
	echo "hello"; echo "world"	# 分号隔开
	
print：
	echo "hello"\	# \号连接
	echo "world"
	
.ONESHELL:			# .ONESHELL命令
print:
	echo "hello"
	echo "world"
```

**最原始的makefile书写** 

```shell
# 定义变量
cc = gcc

# edit就是目标文件
edit : main.o kbd.o command.o display.o \
		insert.o search.o files.o utils.o       
	cc -o edit main.o kbd.o command.o display.o \
		insert.o search.o files.o utils.o

main.o : main.c defs.h
	cc -c main.c	# 命令一定要以tab开头
kbd.o : kbd.c defs.h command.h
	cc -c kbd.c
command.o : command.c defs.h command.h
	cc -c command.c
display.o : display.c defs.h buffer.h
	cc -c display.c
insert.o : insert.c defs.h buffer.h
	cc -c insert.c
search.o : search.c defs.h buffer.h
	cc -c search.c
files.o : files.c defs.h buffer.h command.h
	cc -c files.c
utils.o : utils.c defs.h	# utils.o的前置条件是 utils.c defs.h文件存在，如果存在，也就执行 cc -c utils.c ，如果分号后面的前置条件为空，就是说不用前置条件就可以执行 cc -c utils.c
	cc -c utils.c
.PHONY : clean
clean :
	rm edit main.o kbd.o command.o display.o \
		insert.o search.o files.o utils.o
```

**另类风格的makefile书写** 

```shell
# 定义变量
cc = gcc
objects = main.o kbd.o command.o display.o \
		insert.o search.o files.o utils.o

# edit就是目标文件
edit : $(objects)
	cc -o edit $(objects)

# 这块就简单了，再看不出依赖关系，鱼和熊掌不可兼得
$(objects) : defs.h
kbd.o command.o files.o : command.h
display.o insert.o search.o files.o : buffer.h

# “.PHONY”表示，clean是个伪目标文件，得用 make clean 命令执行
.PHONY : clean
clean :
	rm edit $(objects)
```



**这两种书写之间显示了很多makefile的规则，详细参考如下：** 

[跟我一起写Makefile:MakeFile介绍](http://wiki.ubuntu.org.cn/%E8%B7%9F%E6%88%91%E4%B8%80%E8%B5%B7%E5%86%99Makefile:MakeFile%E4%BB%8B%E7%BB%8D) 



**GNU的make工作时的执行步骤如下：（想来其它的make也是类似）** 

1. 读入所有的Makefile。
2. 读入被include的其它Makefile。
3. 初始化文件中的变量。
4. 推导隐晦规则，并分析所有规则。
5. 为所有的目标文件创建依赖关系链。
6. 根据依赖关系，决定哪些目标要重新生成。
7. 执行生成命令



**需要注意的点** 

* 引用其它makefile，在include前面可以有一些空字符，但是绝不能是[Tab]键开始

