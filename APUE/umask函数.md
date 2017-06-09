### umask函数

*\<sys/stat.h\>* 

```c
// 设置进程创建文件时的屏蔽码，就是说有些权限让禁止的
// 这个设置对之后的open函数、create函数起作用，这函数的mode参数要与mask进行位运行后才得到文件的权限
// mode & (~mask)
mode_t umast(mode_t mask);
```

mask是由下表列出的9个常量中的若干个按位“或”构成的

S_IRUSR       用户读

S_IWUSR      用户写

S_IXUSR       用户执行

S_IRGRP       组读

S_IWGRP      组写

S_IXGRP       组执行

S_IROTH       其他读

S_IWOTH      其他写

S_IXOTH       其他执行

> 在最初cmask为0，即 000 000 000
>
> creat函数时设置mode为666
>
> mode & (~cmask) = 110 110 110 & 111 111 111 = 110 110 110 
>
> 所以foo文件的权限就是rw-rw-rw-
>
> 然后cmask为066,即000 110 110
>
> crear函数的mode仍为666
>
> mode & (~cmask) = 110 110 110 & 111 001 001 = 110 000 000 
>
> 所以bar文件的权限为rw-------

[Linux下的umask函数](http://blog.csdn.net/zhuyi2654715/article/details/7540759) 