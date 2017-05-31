```objective-c
// sys/fnctl.h 主要文件描述符操作

///---------------------------------------------------------------------------------------------//
/// 把socket的句柄(文件描述符)状态标志设置为非延迟
/// 就是把socket设置为非阻塞式，这是socket编程常用到的函数
status = fcntl(socketFD, F_SETFL, O_NONBLOCK);

/**
  * 操作文件描述词的一些特性
  *
  * @param fd 文件描述符，socketFD即socket句柄，也是个文件描述符，上面讲过
  * @param cmd 操作命令，如：F_SETFL，详见：fnctl.h
  * @param arg 如：O_NONBLOCK，表示非延迟，详见：fnctl.h
  * 
  * 参数详细参考：http://c.biancheng.net/cpp/html/233.html
  *
  * @return 成功则返回0, 若有错误则返回-1
  */
int fcntl(int fd, int cmd, long arg);
```

