### exec簇

*\<unistd.h\>* 	

*execl、execle、execlp、execv、execve、execvp* 

```c
// 皆是成功不返回，出错返回-1
int execl  (const char* pathname, const char* arg0, .../* (char *)NULL */);
int execle (const char* pathname, const char* arg0, .../* (char *)NULL, char* const envp[] */);
int execlp (const char* filename, const char* arg0, .../* (char *)NULL */);
int execv  (const char* pathname, char* const arg0);
int execve (const char* pathname, char* const arg0, .../* char* const envp[] */);
int execvp (const char* filename, char* const arg0);
```



**APUE中的原话**  

> 当进程调用一个exec函数时，该进程完全由新程序代换，而新程序则从其main函数开始执行。因为调用exec函数并不创建新进程，所以前后的进程ID并不改变。exec只是用一个新程序替换了当前进程的正文、数据、堆和栈段。

**所以，exec调用成功后，它后面的语句就不会执行了** 



这些函数容易搞混，函数名中的字符会给我们一些帮助

p：函数取*filename*为参数，并且用PATH环境变量寻找可执行文件

l：函数取参数表

v：函数取一个argv[]

e：函数取envp[]数组，而不使用当前环境

![](https://github.com/wenguang/startup/blob/master/imgs/6exec.png?raw=true)

说到envp[]，就提到历史上，Unix的main函数有3个参数：

```c
int main (int argc, char argv[], char* envp[]);
```

envp[]意在取代程序的环境表，ANSI C规定main只有两个参数，因为envp[]相比环境表没什么好处。

**环境表** 

> 每个程序都接收到环境表。与参数一样，环境表也是一个字符指针数组，其中每个指针包含一个以NULL结束的字符串的地址，全局变量environ则包住了该指针数组的地址。

*extern char **environ* 

![](https://github.com/wenguang/startup/blob/master/imgs/environ.png?raw=true)





