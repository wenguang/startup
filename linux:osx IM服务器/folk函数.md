### folk 

~^~!! 文中代码见：https://github.com/wenguang/c-attack/tree/master/folk

```c
#include <unistd.h>  
#include <stdio.h>   
int main ()   
{   
    pid_t fpid;
    int count=0;  
    fpid=fork();   
    if (fpid < 0)   
        printf("error in fork!\n");   
    else if (fpid == 0)
    {  
        printf("child process, pid = %d\n",getpid());     
        count++;  
    }  
    else 
    {  
        printf("parent process, pid = %d\n",getpid());     
        count++;  
    }  
    printf("count: %d\n",count);  
    return 0;  
}
/* 输出
parent process, pid = 76322
count: 1
child process, pid = 76323
count: 1
*/
```

**fork调用的一个奇妙之处就是它仅仅被调用一次，却能够返回两次**

它可能有三种不同的返回值：
​    1）在父进程中，fork返回新创建子进程的进程ID；
​    2）在子进程中，fork返回0；
​    3）如果出现错误，fork返回一个负值；

也得注意到两次count的输出都是1，是因为在调用folk()时，count的值是0，它被都由到子进程的空间中，所以当子进程执行到`count++`时，它变为1。也就是说在folk()之后，就有了两个count变量，它们分属不同进程。



fork出错可能有两种原因：
​    1）当前的进程数已经达到了系统规定的上限，这时errno的值被设置为EAGAIN。
​    2）系统内存不足，这时errno的值被设置为ENOMEM。



更多变态的folk()调用见：[linux中fork（）函数详解（原创！！实例讲解）](http://blog.csdn.net/jason314/article/details/5640969) 