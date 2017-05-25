### exec簇

*\<unistd.h\>* 	

*execl、execle、execlp、execv、execve、execvp* 

**AUPE中的原话** 

> 当进程调用一个exec函数时，该进程完全由新程序代换，而新程序则从其main函数开始执行。因为调用exec函数并不创建新进程，所以前后的进程ID并不改变。exec只是用一个新程序替换了当前进程的正文、数据、堆和栈段。

**所以，exec调用成功后，它后面的语句就不会执行了** 