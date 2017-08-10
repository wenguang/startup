### EAGAIN和EWOULDBLOCK

在centos7中，这两个错误码值是一样的（有些老的unix系统它们的码值不一样），它们意思是：

> [EAGAIN](https://web.archive.org/web/20130508062559/http://www.wlug.org.nz/EAGAIN) is often raised when performing [non-blocking I/O](http://www.kegel.com/dkftpbench/nonblocking.html). It means *"there is no data available right now, try again later"*.
>
> It [might](http://www.opengroup.org/onlinepubs/000095399/basedefs/errno.h.html) (or [might not](http://mail-archives.apache.org/mod_mbox/httpd-dev/200004.mbox/%3CE12edKw-0002M2-00@fanf.eng.demon.net%3E)) be the same as `EWOULDBLOCK`, which means *"your thread would have to block in order to do that"*.

在accept、read等函数中经常遇到这两个错误，要注意区分这两个错误与其它错误，以上解释中可看到它们非真正的系统出错。