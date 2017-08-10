### close-on-exec

在编写daemon程序时，在fork出子进程之后调用exec之前，要把当前打开的FD都关闭掉。这是因为调用exec后就从新程序的main开始执行了，之前打开的FD若不关闭掉就会造成系统资源浪费。

除了用sysconf(_SC_OPEN_MAX)逐个关闭外，还有2种方法

```c
// 方法1：在open一个FD后，把它的文件描述符标记设置为FD_CLOEXEC
// 这样当进程调用了exec后，之前打开的FD就会让自动关闭。
int fd = open("/file.txt", O_RDONLY | O_CREAT);
int flags = fcntl(fd, F_GETFD);
flags |= FD_CLOEXEC;
fcntl(fd, F_SETFD, flags);

// fork()
// exec()

close(fd);

//----------------------------------------------------------//

// 方法2：用O_CLOEXEC打开文件
int fd = open("/file.txt", O_CREAT | O_RDONLY | O_CLOEXEC);

// fork()
// exec()

close(fd);
```

