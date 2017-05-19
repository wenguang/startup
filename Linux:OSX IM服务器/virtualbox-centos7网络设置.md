安装centos7前，在网络设置中的连接方式设为桥接网卡，只有这种方式才能保证宿主机与虚拟机之间相互访问。

![](https://github.com/wenguang/startup/blob/master/imgs/virtualbox-network.png?raw=true)

安装完后，centos7默认网卡未激活，最小化版本也不能用ifconfig命令，只能用ip addr命令。

1、修改 /etc/sysconfig/network-scripts/ifcfg-enp0s3 文件，将ONBOOT=no改为ONBOOT=yes。

2、重启网卡：service network restart，就可以上网了。

3、yum install net-tools ，安装网络工具后就可以用ifconfig命令了。

4、查到分配给centos的地址是192.168.1.101，终端用ssh root@192.168.1.101就能连接虚拟机了。



参考：[virtualbox下最小化安装centos7后上网设置](https://my.oschina.net/u/144160/blog/517049) 

​	   [快速理解VirtualBox的四种网络连接方式](http://www.cnblogs.com/york-hust/archive/2012/03/29/2422911.html) 

centos最小化版本更多的配置：[安装完最小化 RHEL/CentOS 7 后需要做的 30 件事情](https://linux.cn/article-5341-1.html) 