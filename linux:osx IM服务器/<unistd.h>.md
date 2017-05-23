***头文件以linux上的为准***

**sysconf函数** 

获取系统执行的配置信息。例如页大小、最大页数、cpu个数、打开句柄的最大个数等等 

```c
int sysconf (int name);
```

**注意**：*name参数在mac上unistd.h能找到定义，如：_SC_NPROCESSORS_CONF，而linux上的unistd找不到这些定义，但在两个系统上都编译通过。还发现了一些在linux有定义但mac上未定义的，如：\_SC_AVPHYS_PAGES。*

_SC_OPEN_MAX：一个进程能打开文件描述符的最大数量

_SC_NPROCESSORS_CONF：可配置的CPU核数

更好宏定义参考《Unix环境高级编程》第2章



**进程、进程组、会话** 

```C
pid_t	 fork(void);
pid_t	 getpid(void);	//获取进程id
pid_t	 getppid(void);	//获取当前进程的父进程id
pid_t	 getpgid(pid_t); //获取指定进程的父进程id
...
int	 setgid(gid_t);
int	 setpgid(pid_t, pid_t);
...
int setuid (__uid_t);	
...
  
pid_t setsid (void)； //创建一个会话，返回会话id，非进程组长调用才能成功
pid_t	 getsid(pid_t);
...
int getresuid (__uid_t *__ruid, __uid_t *__euid, __uid_t *__suid);
int getresgid (__gid_t *__rgid, __gid_t *__egid, __gid_t *__sgid);
int setresuid (__uid_t __ruid, __uid_t __euid, __uid_t __suid);
int setresgid (__gid_t __rgid, __gid_t __egid, __gid_t __sgid);
```



**chdir、fchdir函数** 

更改进程工作目录、更改进程工作目录为fd打开的目录

```c
int chdir (const char *__path);
int fchdir (int __fd)
```

