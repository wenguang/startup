### 带缓存I/O(针对FILE指针和流)

*\<stdio.h\>* 

**这种I/O在APUE叫标准I/O，标准I/O库函数是调用文件I/O的系统调用要实现的，每个I/O流都有一个与其关联的文件描述符** 

```c
// 获得与其关联的FD
int fileno(FILE *fp);
```



#### 三种类型的缓存

(1) 全缓存。当填满标准I/O缓存后才进 实际I/O操作。在一个流上执行第一次 I/O操作时，相关标准	I/O函数通常调 malloc( 7.8节)获得需使用的缓存。

(2)  行缓存。写完一行之后才执行实际I/O操作。

(3)  不带缓存。相当于直接调用write系统函数写到相关联的文件上。

stderr是不带缓存的，涉及到设备的流是行缓存，其它的是全缓存。

更改缓存类型

```c
void setbuf(FILE *fp, char *buf);
int setvbuf(FILE *fp, char *buf, int mod, size_t size);
```



#### 流打开与关闭

```c
// 皆是成功返回文件指针，出错返回NULL
FILE * fopen(const char* pathname, const char* type);
FILE * freopen(const char* pathname, const char* type, FILE *fp)
// 从一个打开的FD得到流
FILE * fdopen(int, fd, const char* type);

// 成功返回0， 出错返回EOF
int fclose(FILE *fp);
```

