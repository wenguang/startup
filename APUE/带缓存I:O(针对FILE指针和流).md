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

![](https://github.com/wenguang/startup/blob/master/imgs/stdio-buftype.png?raw=true)



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

![](https://github.com/wenguang/startup/blob/master/imgs/stdio-p.png?raw=true)



#### 流定位

```c
// 成功返回文件位置，出错返回-1L
long ftell(FILE *fp);
// 成功返回0，出错非0
// whence取值 SEEK_SET、SEET_CUR、SEET_END
int fseek(FILE *fp, long offset, int whence);

void rewind(FILE *fp);
```



#### 一次一字符

```c
// 皆为成功返回下一个字符，到达文件尾或出错返回EOF
int getc(FILE *fp);
int fgetc(FILE *fp);
// 相当于getc(stdin)
int getchar(void);

// 皆为成功返回c，出错EOF
int putc(int c, FILE *fp)
int fputc(int c, FILE *fp);
// 相当putc(c, stdout);
int putchar(int c);
```



#### 一次一行

```c
// 皆为成功返回buf, 文件尾或出错NULL
char* fgets(char *buf, int n, FILE *fp);
char* gets(char *buf);

// 皆为成功返回非负值，出错EOF
int fputs(const char *str, FILE *fp);
int puts(const char *str);
```

gets函数不安全，不建议使用，见APUE 5.7



#### 判断流错误或EOF

```c
// 真为非0，假为0
int ferror(FILE, fp);
int feof(FILE *fp);

// 清除error或EOF标志
void clearerr(FILE *fp);
```



#### 二进制I/O 读写结构

```c
// 成功返回读写的结构数量
// size为读写的结构大小，nobj为读写的结构数量
// fread若返回数小于nobj，有可能是出错也有可能是到达了文件尾，需用ferror或feof判断，fwrite若返回数小于nobj则出错。

size_t fread(void *ptr, size_t size, size_t nobj, FILE *fp);
size_t fwrite(const void *ptr, size_t size, size_t nobj, FILE *fp);
```

*使用二进制I/O的基本问题是：它只能用于读写在同一系统上的数据，见APUE 5.9* 

