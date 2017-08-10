### setuid函数 看得脑核疼…-_-!

在讨论这个setuid函数之前，我们首先要了解的一个东西就是内核为每个进程维护的三个UID值。

* 实际用户ID(real uid)：当前的登录用户ID。
* 有效用户ID(effective uid)：当前进程是以哪个用户ID运行的。如以guest用户登录，但有些进程需要root权限才能运行的，就以sudo xxx 运行该进程。
* 保存的设置用户ID(saved set-user-ID)：保存的设置用户ID就是有效用户ID的一个副本，与SUID权限有关。

*关于那个**SUID（超级用户特权）**，最经典的例子莫过于passwd命令。passwd这个可执行文件的所有者是root，但是其他用户对于它也有执行权限，并且它自身具有SUID权限。那么当其他用户来执行passwd这个可执行文件的时候，产生的进程的就是以root用户的ID来运行的。*



参考：AUPE && [setuid函数解析](http://www.cnblogs.com/bwangel23/p/4225818.html) 