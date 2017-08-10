### dup dup2解惑

```c

int fd = open("./dup.txt", O_RDWR | O_CREAT | O_TRUNC);
if (fd < 0)
{
    printf("- open file failed !\n");
    return -1;
}

// 把标准输出重定向到dup.txt上
// 它实际上是让STDOUT_FILENO（即文件描述符1）指向fd所指向的文件表项
// 在dup2之前，printf的内容输出到终端上，指向是这样的
// printf －> stdout －> STDOUT_FILENO(1) －> 终端(tty)
// tty也是一个文件：/dev/tty。  这符合Unix上一切皆文件的思想
// 在dup2之前，printf的内容就输出到dup.txt上，指向变这样了
// printf －> stdout －> STDOUT_FILENO(1) －> dup.txt
dup2(fd, STDOUT_FILENO);
printf("instead of displaying in tty, out to the file\n");
```

*完整代码见：https://github.com/wenguang/c-attack/blob/master/dup012.c* 



参考：[linux中的dup()系统调用](http://www.cnblogs.com/pengdonglin137/p/3286627.html) 