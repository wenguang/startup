### stat函数

*\<sys/stat.h\>* 

```c
// 3个函数都是成功返回0，出错返回-1
int stat(const char* pathname, struct stat* buf);
// fd为已经打开的文件描述符
int fstat(int fd, struct stat* buf);
// 返回符号连接的有关信息，而不是符号连接指向的文件信息，该函数是针对符号连接文件类型的
int lstat(const char* pathname, struct stat* buf);
```

**stat结构** 

```c
struct stat
{
	mode_t 	st_mode;		// 文件类型或权限mode
  	ino_t 	st_ino;			// i-node号
  	dev_t 	st_dev;			// 磁盘设备号
  	dev_t	st_rdev;		// 特殊文件设备号
  	nlink_t	st_nlink;		// 符号连接号
  	uid_t	st_uid;			// 所属用户id
  	gid_t	st_gid;			// 所属用户组id
  	off_t	st_size;		// 文件大小，只对一般文件而言
  	time_t	st_atime;		// 最后访问时间
  	time_t	st_mtime;		// 最后修改时间	
 	time_t	st_ctime;		// 最后文件状态更改时间
  	long	st_blksize;		// 最佳I/O块大小
  	long	st_blocks;		// number of 512-byte blocks allocated
}
```





