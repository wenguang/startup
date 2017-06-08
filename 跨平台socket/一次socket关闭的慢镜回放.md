### tcp socket关闭的步骤分解



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

过了60秒（[linux内核文档](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)的tcp_fin_timeout定义FIN_WAIT_2的过期时间），mac上的FIN_WAIT_2状态就消失了，但centos7上则一直处在CLOSE_WAIT状态。大量的CLOSE_WAIT的存在会使服务器down掉，故编写程序要特别注意避免这种情况发生。



#### 定格FIN_WAIT_1

FIN_WAIT_1是发出FIN后等待对方ACK期间的状态，ACK是系统内核回应的，一般情况下这个状态会非常短。要定格这个状态需要用到iptables对网络包进行拦截，此外可用nc代替server/client程序。

centos7: 

> nc -vl 9001

mac:

> nc -v 192.168.1.104 9001

这样就建立了连接

设置centos7的iptables规则，最好用—dport 加上mac端用nc建立连接的端口号，以下添加一条iptables规则，意思是：拦截了从centos7发出的，目标地址是192.168.1.103的，目标端口为51959的数据包。

> iptables -A OUTPUT  -d 192.168.1.103 —dport 51949 -j DROP 

用ctl-c停止mac上的nc连接，centos7上的nc也自动断开了

centos7：处于LAST_ACK状态

> [root@localhost imserver]# netstat -ant|grep 9001
>
> tcp        0      1 192.168.1.104:**9001**      192.168.1.103:51949     LAST_ACK   

因为centos7收到mac的FIN，对回应了ACK（被拦截了），不过mac是否收到ACK，centos7又向mac发出FIN（当然又被拦截了），不管mac是否收到，centos7最终到达了LAST_ACK状态。

mac: 处于FIN_WAIT_1状态

> wenguangdeMacBook-Pro:startup wenguangpan$ netstat -ant|grep 51949
>
> tcp4       0      0  192.168.1.103.51949    192.168.1.104.9001     FIN_WAIT_1 

因为centof7向mac回应的ACK被拦截了，FIN_WAIT\_1状态会维持一段时间，之后双方端口回到closed状态，FIN_WAIT_1这段时间出mac因为收不到centos7的ACK会向centos重发FIN若干次后（[linux内核文档](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)的tcp_orphan_retries说明重发次数为8次，mac上抓包发现是12次，不同系统差异），最后向centos7发了RST。

同样的过滤规则wireshark抓包数据如下：

![](https://github.com/wenguang/startup/blob/master/imgs/wireshark-0002.png?raw=true)

