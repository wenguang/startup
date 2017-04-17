```objective-c
ioctl.h只有一个函数就是：ioctl函数，但ioctl.h引入其他的头文件，里面预定义了好多cmd命令
  
/**
ioctl是设备驱动程序中对设备的I/O通道进行管理的函数。所谓对I/O通道进行管理，就是对设备的一些特性进行控制，例如串口的传输波特率、马达的转速等等。
@param 其中fd是用户程序打开设备时使用open函数返回的文件标示符，
@param cmd是用户程序对设备的控制命令，
@param 至于后面的省略号，那是一些补充参数，一般最多一个，这个参数的有无和cmd的意义相关。
*/
int	ioctl(int fd, unsigned long cmd, ...);

// ioctl.h包含了这些文件，里面有好多预定义cmd命令
#include <sys/ttycom.h>
#include <sys/ioccom.h>
#include <sys/filio.h>
#include <sys/sockio.h>

// 比如以下cmd
/* Socket ioctl's. */
#define	SIOCSHIWAT	 _IOW('s',  0, int)		/* set high watermark */
#define	SIOCGHIWAT	 _IOR('s',  1, int)		/* get high watermark */
...
  
  
预定义cmd宏中的_IOW、_IOR、_IOWR是什么含义，下面会讲到


// 在看预定义cmd之前，先了解cmd字段的各段位表示什么
| 设备类型 | 序列号 | 方向 |数据大小|
|----------|--------|------|--------|
| 8 bit | 8 bit |2 bit |8~14 bit|
|----------|--------|------|--------|

1、类型：说得再好听的名字也只不过是个0~0xff的数，占8bit(_IOC_TYPEBITS)。这个数是用来区分不同的驱动的，像设备号申请的时候一样，内核有一个文档给出一些推荐的或者已经被使用的幻数。
2、序列号：用这个数来给自己的命令编号，占8bit(_IOC_NRBITS)，我的程序从1开始排序。
3、数据传输方向：占2bit(_IOC_DIRBITS)。如果涉及到要传参，内核要求描述一下传输的方向，传输的方向是以应用层的角度来描述的。
	1)_IOC_NONE：值为0，无数据传输。
	2)_IOC_READ：值为1，从设备驱动读取数据。
	3)_IOC_WRITE：值为2，往设备驱动写入数据。
	4)_IOC_READ|_IOC_WRITE：双向数据传输。
4、数据大小：与体系结构相关，ARM下占14bit(_IOC_SIZEBITS)，如果数据是int，内核给这个赋的值就是sizeof(int)。
  
// 按以上段位解释，可以如下生成cmd命令
_IO(type,nr) //没有参数的命令
_IOR(type,nr,size) //该命令是从驱动读取数据
_IOW(type,nr,size) //该命令是从驱动写入数据
_IOWR(type,nr,size) //双向数据传输
// 拆分cmd命令
_IOC_DIR(cmd) //从命令中提取方向
_IOC_TYPE(cmd) //从命令中提取幻数
_IOC_NR(cmd) //从命令中提取序数
_IOC_SIZE(cmd) //从命令中提取数据大小
```



参考：[驱动程序ioctl函数用法](http://blog.sina.com.cn/s/blog_ba08e8e00101bw4e.html)、[ioctl()函数详解](http://blog.csdn.net/gemmem/article/details/7268533) 