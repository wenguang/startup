### accept函数的阻塞与非阻塞

在epoll_wait的一次返回中，有可能listen多个连接等待accept的情况，这在高并发的环境经常发生，那就要在一个while循环中调用accept函数，**直到accept函数返回-1，判断errno是EAGAIN或EWOULDBLOCK就说明已经没有在等待的连接了**。

**但负责监听的socketfd是阻塞的，accept函数在没有了等待接收的连接时，它就会阻塞着不返回。**所以要设置监听socket的非阻塞属性。



