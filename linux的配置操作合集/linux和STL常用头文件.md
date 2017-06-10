### linux和STL常用头文件



1、

\<assert.h\>：ANSI C。提供断言，assert(表达式)

\<glib.h\>：GCC。GTK，GNOME的基础库，提供很多有用的函数，如有数据结构操作函数。使用glib只需要包含\<glib.h\>

\<dirent.h\>：GCC。文件夹操作函数。struct dirent,struct DIR,opendir(),closedir(),readdir(),readdir64()等 

\<ctype.h\>：ANSI C。字符测试函数。isdigit(),islower()等

\<errno.h\>：ANSI C。查看错误代码errno是调试程序的一个重要方法。当linuc C api函数发生异常时,一般会将errno变量(需include errno.h)赋一个整数值,不同的值表示不同的含义,可以通过查看该值推测出错的原因。在实际编程中用这一招解决了不少原本看来莫名其妙的问题。比较 麻烦的是每次都要去linux源代码里面查找错误代码的含义，现在把它贴出来，以后需要查时就来这里看了。来自linux 2.4.20-
18的内核代码中的/usr/include/asm/errno.h

\<getopt.h\>：处理命令行参数。getopt()

2、

//------------------------------------------------

linux常用头文件如下：

POSIX标准定义的头文件

\<dirent.h\>        目录项

\<fcntl.h\>         文件控制

\<fnmatch.h\>    文件名匹配类型

\<glob.h\>    路径名模式匹配类型

\<grp.h\>        组文件

\<netdb.h\>    网络数据库操作

\<pwd.h\>        口令文件

\<regex.h\>    正则表达式

\<tar.h\>        TAR归档值

\<termios.h\>    终端I/O

\<unistd.h\>    符号常量

\<utime.h\>    文件时间

\<wordexp.h\>    字符扩展类型

//------------------------------------------------

\<arpa/inet.h\>    INTERNET定义

\<net/if.h\>    套接字本地接口

\<netinet/in.h\>    INTERNET地址族

\<netinet/tcp.h\>    传输控制协议定义

//------------------------------------------------

\<sys/mman.h\>    内存管理声明

\<sys/select.h\>    Select函数

\<sys/socket.h\>    套接字借口

\<sys/stat.h\>    文件状态

\<sys/times.h\>    进程时间

\<sys/types.h\>    基本系统数据类型

\<sys/un.h\>    UNIX域套接字定义

\<sys/utsname.h\>    系统名

\<sys/wait.h\>    进程控制



POSIX定义的XSI扩展头文件 

\<cpio.h\>    cpio归档值 

\<dlfcn.h\>    动态链接

\<fmtmsg.h\>    消息显示结构

\<ftw.h\>        文件树漫游

\<iconv.h\>    代码集转换使用程序

\<langinfo.h\>    语言信息常量

\<libgen.h\>    模式匹配函数定义

\<monetary.h\>    货币类型

\<ndbm.h\>    数据库操作

\<nl_types.h\>    消息类别

\<poll.h\>    轮询函数

\<search.h\>    搜索表

\<strings.h\>    字符串操作

\<syslog.h\>    系统出错日志记录

\<ucontext.h\>    用户上下文

\<ulimit.h\>    用户限制

\<utmpx.h\>    用户帐户数据库 



\<sys/ipc.h\>    IPC(命名管道)

\<sys/msg.h\>    消息队列

\<sys/resource.h\>资源操作

\<sys/sem.h\>    信号量

\<sys/shm.h\>    共享存储

\<sys/statvfs.h\>    文件系统信息

\<sys/time.h\>    时间类型

\<sys/timeb.h\>    附加的日期和时间定义

\<sys/uio.h\>    矢量I/O操作



POSIX定义的可选头文件

\<aio.h\>        异步I/O

\<mqueue.h\>    消息队列

\<pthread.h\>    线程

\<sched.h\>    执行调度

\<semaphore.h\>    信号量

\<spawn.h\>     实时spawn接口

\<stropts.h\>    XSI STREAMS接口

\<trace.h\>     事件跟踪


3、 C/C++头文件一览

\<assert.h\>　　　　//设定插入点

\<ctype.h\>　　　　 //字符处理

\<errno.h\>　　　　 //定义错误码

\<float.h\>　　　　 //浮点数处理

\<iso646.h\>        //对应各种运算符的宏

\<limits.h\>　　　　//定义各种数据类型最值的常量

\<locale.h\>　　　　//定义本地化C函数

\<math.h\>　　　　　//定义数学函数

\<setjmp.h\>        //异常处理支持

\<signal.h\>        //信号机制支持

\<stdarg.h\>        //不定参数列表支持

\<stddef.h\>        //常用常量

\<stdio.h\>　　　　 //定义输入／输出函数

\<stdlib.h\>　　　　//定义杂项函数及内存分配函数

\<string.h\>　　　　//字符串处理

\<time.h\>　　　　　//定义关于时间的函数

\<wchar.h\>　　　　 //宽字符处理及输入／输出

\<wctype.h\>　　　　//宽字符分类