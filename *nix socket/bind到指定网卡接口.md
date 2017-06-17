### bind到指定网卡接口

cient.c、server.c在不同的centos虚拟机环境也

同一虚拟机可以连接成功，不同虚拟器连接异常：

server用环路ip bind，在启动firewall时(service firewalld restart)，cient的connect函数抛出：no route to host，在停止firewall时，client的connect函数抛出：connect refused

*解决方法* 

https://www.centos.org/forums/viewtopic.php?t=57032 这里提到

> It is only listening to port xxx on localhost, not your lan interface.

**原因：用sockaddr_in构建一个地址，指定ip为127.0.0.1，它只是一个环路地址，只在在同一虚拟机上连接成功。应该用getifadds函数获取网卡信息，获得enp0s3上为AF_INET的地址，应该要enp0s3所在的ip上监听才行**。

虚拟机上ifconfig的信息如下：

```shell
enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.104  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::9734:ffea:1940:3c93  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:1e:b2:7a  txqueuelen 1000  (Ethernet)
        RX packets 106341  bytes 105557442 (100.6 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 53965  bytes 4743821 (4.5 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1  (Local Loopback)
        RX packets 76  bytes 5736 (5.6 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 76  bytes 5736 (5.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

