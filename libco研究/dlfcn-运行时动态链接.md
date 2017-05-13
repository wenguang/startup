**类Unix系统的dlfcn.h文件中定义了可以在运行时实现动态链接的函数** 

```objective-c
// 常用的几个函数
extern void * dlopen(const char * __path, int __mode);
extern void * dlsym(void * __handle, const char * __symbol);
extern char * dlerror(void);
extern int dlclose(void * __handle);
```

**定义一个最简单的动态链接库—xxx.so** 

```objective-c
// xxx.h
int add(int a,int b)；
  
// xxx.c
int add(int a,int b)
{
    return (a + b);
}
```

**编译生成动态链接库** 

> gcc -fPIC -shared xxx.c -o libxxx.so

**实现一个可执行程序，在运行定位动态链接库，从链接库中得到某个函数的指针，调用这个方法** 

```objective-c
/*********  main.c  **********/
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

// 动态链接库路径
#define LIB_PATH "./libxxx.so"

// 函数指针
typedef int (*ADD_FUNC)(int, int);

int main()
{
	void *handle;
	char *error;
	ADD_FUNC add_func = NULL;

	// 打开动态链接库
	handle = dlopen(LIB_PATH, RTLD_LAZY);
	if (!handle)
	{
		fprintf(stderr, "%s\n", dlerror());
		exit(-1);
	}
	// 清除之前存在的错误
	dlerror();

	// 获取一个函数
	add_func = (ADD_FUNC)dlsym(handle, "add");
	if ((error = dlerror()) != NULL)
	{
		fprintf(stderr, "%s\n", error);
		exit(-1);
	}

	printf("add :%d\n", (*add_func)(2, 3));

	// 关闭动态链接库
	dlclose(handle);
	exit(0);
}
```

**生成可执行文件** 

> gcc main.c -L./ -lxxx -o main

**执行main** 

> ./main

**编译脚本编写在makefile中，用make编译即可，代码github地址：[dlfcn-test](https://github.com/wenguang/dlfcn-test)** 