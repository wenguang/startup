### 链接多个c/c++文件

*编写了两个c文件，11.c和22.c，11.c需要用到22.c中的函数，如果只是用#include引入22.h用gcc直接编译11.c，那是不会成功的，因为它找不到22.h代表的目标文件（.o），所以无法链接*

**正解：如下就可以用make命令编译了** 

```cmake
cc = gcc

objs = client.o errstr.o
exe = client

$(exe): $(objs)
	$(cc) $(objs) -o $@
client.o: client.c
	 $(cc) -c $< -o $@
errstr.o: errstr.c
	$(cc) -c $< -o $@

clean:
	rm -rf $(exe) *.o
```

