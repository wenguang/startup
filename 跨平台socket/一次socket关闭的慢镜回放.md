### 一次 tcp socket关闭的步骤分解



#### 介绍

知道TCP协议的同学，对下面这幅画面多少会有印象，就是那经典的4次挥手了。我们要做的是通过代码或工具分解这一经典瞬间的每一个步骤。

![](https://github.com/wenguang/startup/blob/master/imgs/tcp_close.png?raw=true)



#### 准备工作

分解环境：macbook pro（192.168.1.103）、centos7 虚拟机（192.168.1.104）

分解工具：wireshark、nc、iptables、netstat	（不熟悉这几样工具的同事请自行google）

server/client代码：https://github.com/wenguang/c-attack/blob/master/imserver/server.cpp

​				  https://github.com/wenguang/c-attack/blob/master/imclient/tcli.c



#### 定格FIN_WAIT_2和CLOSE_WAIT

图面中的第1步FIN和第3步FIN是由app主动调用close函数发出的，所以只要一方调用了close，而另一方不调用close，就会定格在第2次挥手的瞬间。

在centos7上运行server，在macbook pro上运行tcli，已经建立上连接

> [root@localhost ~]# netstat -ant|grep 9001
>
> tcp        0      0 192.168.1.104:**9001**      0.0.0.0:*               LISTEN     
>
> tcp        0      0 192.168.1.104:**9001**      192.168.1.103:50549     ESTABLISHED

mac这里打开wireshark，捕获en0上的数据包，输入过滤规则：

> tcp.port eq 9001  and (ip.src eq 192.168.1.103 and ip.dst eq 192.168.1.104) or (ip.src eq 192.168.1.104 and ip.dst eq 192.168.1.103)

这里输出q让tcli调用close函数，捕获到的数据如下

wireshark: 

![](https://github.com/wenguang/startup/blob/master/imgs/wireshark-0001.png?raw=true)

centos7: server处于CLOSE_WAIT状态

> [root@localhost ~]# netstat -ant|grep 9001
>
> tcp        0      0 192.168.1.104:**9001**      0.0.0.0:*               LISTEN     
>
> tcp        1      0 192.168.1.104:**9001**      192.168.1.103:50549     CLOSE_WAIT 

mac: tcli处于FIN_WAIT_2状态

> wenguangdeMacBook-Pro:imclient wenguangpan$ netstat -ant|grep 50549
>
> tcp4       0      0  192.168.1.103.50549    192.168.1.104.9001     FIN_WAIT_2 

过了60秒，mac上的FIN_WAIT_2状态就消失了，但centos7上则一直处在CLOSE_WAIT状态。