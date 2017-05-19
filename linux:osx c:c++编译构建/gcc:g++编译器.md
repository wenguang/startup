**gcc 最开始的时候是 GNU C Compiler。但是后来因为这个项目里边集成了更多其他不同语言的编译器，GCC就代表 the GNU Compiler Collection，所以表示一堆编译器的合集。 g++则是GCC的c++编译器。** 

> $ gcc
>
> clang: **error: **no input files

我以为未安装gcc，查了[如何在 Mac 上安装 GCC](https://www.zhihu.com/question/20588567) 才知道这是已经安装了。



[gcc/g++等编译器 编译原理： 预处理，编译，汇编，链接各步骤详解](http://blog.csdn.net/elfprincexu/article/details/45043971) 

**C和C++编译器是集成的，编译一般分为四个步骤：**

1. **预处理(preprocessing)  ----------------- cpp/ gcc -E **
2. **编译(compilation) ------------------ cc1 / gcc -S**
3. **汇编(assembly)  -------------------- as**
4. **连接(linking) --------------------- ld ** 

![](https://github.com/wenguang/startup/blob/master/imgs/compile-tain.png?raw=true)

> gcc -E hello.c -o hello.i
>
> gcc -S hello.i -o hello.s
>
> gcc -c hello.s -o hello.o

**预处理阶段** 

预处理阶段主要处理#include和#define，它把#include包含进来的.h 文件插入到#include所在的位置，把源程序中使用到的用#define定义的宏用实际的字符串代替，我们可以用-E选项要求gcc只进行预处理而不进行后面的三个阶段。

**编译阶段** 

检查代码的规范性、是否有语法错误等，以确定代码的实际要做的工作，在检查无误后，Gcc把代码翻译成汇编语言。

**汇编阶段** 

汇编阶段把*.s文件翻译成二进制机器指令文件*.o

**链接阶段** 

说到链接，就得先谈静态库和动态库，.a文件就是静态库、.so文件就是动态库。

> ar -cr libxxx.a file1.o file2.o 

生成libxxx.a，`ar`是archive

> gcc -shared file1.o -o libxxx.so
>
> gcc -fPIC -shared file1.o -o libxxx.so
>
> gcc -fPIC -shared file1.c -o libxxx.so

以上3行都可以生成libxxx.so

> gcc test.c -L/path -lxxx -o test 

***注意-l参数后是xxx，把libxxx.so前面lib和后面的so去掉***，这就是指定在/path下找libxxx库，链接libxxx，编译出可执行文件test，如果/path目录下有libxxx.a和libxxx.so，gcc默认链接libxxx.so，也要用 -static 参数让gcc链接libxxx.a

**静态库链接时搜索路径顺序：**

- \1. ld会去找GCC命令中的参数-L
- \2. 再找gcc的环境变量LIBRARY_PATH
- \3. 再找内定目录 /lib /usr/lib /usr/local/lib 这是当初compile gcc时写在程序内的

**动态链接时、执行时搜索路径顺序:**

- \1. 编译目标代码时指定的动态库搜索路径
- \2. 环境变量LD_LIBRARY_PATH指定的动态库搜索路径
- \3. 配置文件/etc/ld.so.conf中指定的动态库搜索路径
- \4. 默认的动态库搜索路径/lib
- \5. 默认的动态库搜索路径/usr/lib

**有关环境变量：**

- LIBRARY_PATH环境变量：指定程序静态链接库文件搜索路径
- LD_LIBRARY_PATH环境变量：指定程序动态链接库文件搜索路径



**[GCC常用参数详解](http://www.cnblogs.com/zhangsir6/articles/2956798.html) ** 

**-fPIC**： **表明生成位置无关的代码**。PIC就是position independent code，PIC使.so文件的代码段变为真正意义上的共享。http://blog.sina.com.cn/s/blog_54f82cc201011op1.html

​	*如果不加-fPIC,则加载.so文件的代码段时,代码段引用的数据对象需要重定位, 重定位会修改代码段的内容,这就造成每个使用这个.so文件代码段的进程在内核里都会生成这个.so文件代码段的copy.每个copy都不一样,取决于 这个.so文件代码段和数据段内存映射的位置.*

**-shared**：表明生成共享库

**-llibrary**： 
　　制定编译的时候使用的库 
　　例子用法 
　　gcc -lcurses hello.c 
　　使用ncurses库编译程序  

**-Ldir **：
　　制定编译的时候，搜索库的路径。比如你自己的库，可以用它制定目录，不然 
　　编译器将只在标准库的目录找。这个dir就是目录的名称。  

**更多参数见：[GCC中文手册](https://github.com/wenguang/startup/blob/master/linux:osx%20c:c%2B%2B编译构建/GCC%20%E4%B8%AD%E6%96%87%E6%89%8B%E5%86%8C.pdf)** 

