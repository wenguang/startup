**malloc、calloc、realloc、free** 

```objective-c
// 分配size个字节的内存，返回内存首地址，失败返回NULL
void* malloc(size_t size);
// 分配num个长度为size字节的内存，返回内存首地址
void* calloc(size_t num, size_t size);

1、malloc和calloc的区别在于malloc没有初始化内存，calloc把内存初始化为0，所以malloc经常和memset一起使用来初始化内存。
2、返回值是void *，所以可转换为任何类型的指针，如：(int *)。
  
// 把ptr指向的内存重新分配为size个字节大小，返回重新分配后的内存首地址
void* realloc(void* ptr, size_t size);

1、realloc的ptr只能是2种可能：要么是经动态分配的内存指针，要么是NULL，为NULL时realloc等同于malloc。
2、size为0时，相当于把ptr指向的内存空间释放掉，类似于free。
3、分配成功后，ptr指针被系统回收，不可再用；分配失败，ptr不变，可再用。
4、重新分配的内存首地址可能与ptr一样，也可能不一样。
5、size可> < = 原内存空间，ptr指向内存的数据会被复制到新地址中，当size比原空间小时，ptr所指内容被截取。
  
// free函数只是释放指针指向的内容，而该指针仍然指向原来指向的地方，此时，指针为野指针，如果此时操作该指针会导致不可预期的错误。安全做法是：在使用free函数释放指针指向的空间之后，将指针的值置为NULL
void free (void * p);
```



参考：[C语言stdlib函数](http://c.biancheng.net/cpp/u/stdlab_h/) 、[malloc,calloc,realloc函数之间的区别](http://www.cppblog.com/Sandywin/archive/2011/09/14/155746.html) 



**memset、memcmp、memcpy、memmove** 

```objective-c
// 把ptr指向的内存的前num个字节设置为value
void* memset(void *ptr, int value, size_t num);

/**
  用来比较s1 和s2 所指的内存区间前n 个字符

  字符串大小的比较是以ASCII 码表上的顺序来决定，次顺序亦为字符的值。
  memcmp()首先将s1 第一个字符值减去s2 第一个字符的值，若差为0 则再继续比较下个字符，
  若差值不为0 则将差值返回。例如，字符串"Ac"和"ba"比较则会返回字符'A'(65)和'b'(98)的差值(－33)
 */
int memcmp (const void *s1, const void *s2, size_t n);

/**
  复制 src 所指的内存内容的前 num 个字节到 dest 所指的内存地址上
  
  需要注意的是：
  dest 指针要分配足够的空间，也即大于等于 num 字节的空间。如果没有分配空间，会出现断错误。
  dest 和 src 所指的内存空间不能重叠（如果发生了重叠，使用 memmove() 会更加安全）。
  与 strcpy() 不同的是，memcpy() 会完整的复制 num 个字节，不会因为遇到“\0”而结束。
  【返回值】返回指向 dest 的指针。注意返回的指针类型是 void，使用时一般要进行强制类型转换。
 */
void * memcpy ( void * dest, const void * src, size_t num );

/**
  memmove() 与 memcpy() 类似都是用来复制 src 所指的内存内容前 num 个字节到 dest 所指的地址上。
  不同的是，memmove() 更为灵活，当src 和 dest 所指的内存区域重叠时，
  memmove() 仍然可以正确的处理，不过执行效率上会比使用 memcpy() 略慢些
 */
 void * memmove(void *dest, const void *src, size_t num);
```

**memmove的一个例子** 

```objective-c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main ()
{
    char str[] = "memmove can be very useful......";
    memmove (str+20,str+15,11);
    puts (str);
    system("pause");
    return 0;
}

// 输出
memmove can be very very useful.

这段代码能够很好的说明内存重叠时的情况：先将内容复制到类似缓冲区的地方，再用缓冲区中的内容覆盖 dest 指向的内存，请看下图。
```





参考：[C内存管理函数](http://c.biancheng.net/cpp/u/hs3/) 、[C语言memmove()函数：复制内存内容（可以处理重叠的内存块](http://c.biancheng.net/cpp/html/156.html) 