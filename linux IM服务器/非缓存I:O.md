### 非缓存I/O AUPE 3 

*不 带 缓 存 指 的 是 每 个 r e a d 和 w r i t e 都 调 用 内 核 中 的 一 个 系 统 调 用*	

**特定文件描述符** 

*\<unistd.h\>* 

文件描述符是个非负整数，数字0、1、2表示特定的文件描述符，UNIX shell使文件描述符0与进程的标准输入相结合，文件描述符 1与标准输出相结合，文件描述符 2与标准出错输出相结合。

0	STDIN_FILENO

1	STDOUT_FILENO

2	STDERR_FILENO

​									

**文件内核结构** 

3个结构：进程表项、文件表项、vnode表项

![](https://github.com/wenguang/startup/blob/master/imgs/file-kernel-struct.png?raw=true)



**文件共享** 

![](https://github.com/wenguang/startup/blob/master/imgs/file-shared-struct.png?raw=true)



**文件描述符标记**：

**文件状态标志**：读、写、增写、同步、异步、非阻塞等，它们以O_xxx常量表示，如：O_RDWR，不同的文件I/O函数可操作的状态标志也不尽相同。下面介绍各个函数时会列出相关常用的标志常量。



**open函数** 

*\<fcntl.h\>* 

```c
// oflag：文件状态标志，返回是一个文件描述符，出错返回-1，mode为可选参
int open (const char *pathname, int oflag, .../*mode_t mode*/);
```

可操作的文件状态标志常量：

* O_CREAT                创建


* O_RDONLY  		只读
* O_WRONLY           只写
* O_RDWR                读写
* O_APPEND            追加
* O_EXCL                  检查文件是否存在
* O_TRUNC              若为只读或只写打开，清空原有内容
* O_NONBLOCK      非阻塞I/O
* O_NOCTTY            APUE 9.6
* O_SYNC                 APUE 3.12



**create函数** 

*\<fcntl.h\>* 

```c
// mode：指定文件的权限，返回是一个文件描述符，出错返回-1
int create (const char *pathname, mode_t mode);
```

*create函数的不足之处是它以只写方式打开所创建的文件，一般用以下代码创建：*

```c
open(pathname, O_CREAT | O_RDWR | O_TRUNC, mode);
```

mode参数常量：

* S_IRUSR       创建用户可读
* S_IWUSR      创建用户可写
* S_IXUSR        创建用户可执行
* S_IRGRP        创建用户所在组可读
* S_IWGRP       创建用户所在组可写
* S_IXGRP        创建用户所在组可执行
* S_IROTH        其他用户可读
* S_IWOTH       其他用户可写
* S_IXOTH        其他用户可执行



**close函数** 

*\<unistd.h\>* 

```c
// 成功返回0，出错返回-1
int close (int fd);
```







​		
​	