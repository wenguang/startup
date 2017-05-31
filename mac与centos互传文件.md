**1、最简单的方法：终端中 scp ~/dir/file user@remote:/dir/** 

**scp ~/Desktop/header.h root@192.168.1.101:/var/public** 

**也可以把centos的文件传来mac上，把scp 的2个参数前后对换即行**  



**2、samba做共享 最后一步拷贝文件到centos有问题待解决** 

yum -y install samba samba-client

安装成功后

vim /etc/samba/smb.conf	，把以下这段加到配置文件中

```shell
[public]
	comment = Public Stuff
	path = /var/public
	public = yes
	writable = yes
	available = yes
	browseable = yes
	create mask = 0770
	directory mask = 0770
```

可以用testparm命令验证下编辑的配置文件是否有错误

service smb restart  启动服务

创建用户

groupadd samba

useradd -g samba samba

Sampasswd -a mj

设置权限

chown samba:samba /var/public

chmod 777 /var/public

在Finder上连接到服务器，输入：smb:192.168.1.101 ，再输出samba用户名密码即连接上

**但从finder拷贝文件到smb所有centos目录报没有读取权限错误** 