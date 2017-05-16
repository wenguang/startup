**select/poll/epoll/kqueue/libevent/IOCP** 

[我读过的最好的epoll讲解--转自”知乎“](https://my.oschina.net/dclink/blog/287198) 

Mac不支持epoll，支持kqueue，libevent是linux下的库，IOCP是windows的技术，这里暂不考虑。

IM服务器的跨平台不包括windows（它不适合做性能服务器），只支持Unix/Linux/MacOS

