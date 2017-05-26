### exit/_exit/atexit/return

*\<stdlib.h\>*

```c
void exit(int status);
```

*\<unistd.h\>*

```c
void _exit(int status);
```

> exit是ANSI C说明的，而_exit则是POSIX.1说明的



* exit函数会执行标准I/O的清除关闭操作，对打开的流调用fclose关闭
* exit、_exit 向执行此程序的进程（通常是shell进程）返回终止状态status
* return也可以返回终止状态：return(0);



**终止处理程序** 

*\<stdlib.h\>*

```c
// 登录程序终止时调用的函数，成功返回0，失败非0
int atexit(void (*func)(void));
```

* 一个进程可登录最多32个这样的函数
* exit以登记这些函数的的相反顺序调用它们
* 同一函数登记多次，也会被调用多次

