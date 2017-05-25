**[pthread的各种同步机制](https://casatwy.com/pthreadde-ge-chong-tong-bu-ji-zhi.html)**  

**[pthread多线程编程整理 - 与时间赛跑的使者](http://www.360doc.com/content/10/1109/10/3700464_67847038.shtml)** 

**\<pthread.h\> ** 

**pthread_t、pthread_attr_t** 

**各种同步机制** 

**pthread_mutex_t、pthread_mutexattr_t （互斥量）** 

**pthread_cond_t、pthread_condattr_t（条件变量）** 

**pthread_rwlock_t、pthread_rwlockattr_t（读写锁）** 

**pthread_spin_t （spin lock 空转锁）** 



**pthread_xxx函数** 

```c
int pthread_create(pthread_t* nthread, const pthread_attr_t* attr, void* (*start_routine)(void *), void* arg);
int pthread_join(pthread_t tid,void **status);
int pthread_detach(pthread_t tid);
void pthread_exit (void *retval);
void pthread_cancel(pthread_t tid);
pthread_t pthread_self(void);
```

调用pthread_join()将阻塞自己，一直到要等待加入的线程运行结束。 
可以用pthread_join()获取线程的返回值。 
一个线程对应一个pthread_join()调用，对同一个线程进行多次pthread_join()调用是逻辑错误。 
join or detach 
线程分两种：一种可以join，另一种不可以。该属性在创建线程的时候指定。 
joinable线程可在创建后，用pthread_detach()显式地分离。但分离后不可以再合并。该操作不可逆。 
为了确保移植性，在创建线程时，最好显式指定其join或detach属性。似乎不是所有POSIX实现都是用joinable作默认。 

主线程用pthread_exit只会使主线程自身退出，产生的子线程继续执行；用return则所有线程退出。 

**总的来说**，只要线程运行结束，并且被detach了，后面再join就不行了，只要线程还在运行中，就能join。如果运行结束了，第一次被join之后，线程就被detach了，后续就不能join。当然了，如果线程本来就是detach属性的线程，那任何时候都无法被join。



**pthread_attr_xxx函数** 

```c
int pthread_attr_init (pthread_attr_t *attr);
int pthread_attr_destroy (pthread_attr_t *attr);
```

pthread_attr_init函数必须在pthread_create函数之前调用。

pthread_attr_t主要包括：是否绑定、是否分离、堆栈地址、堆栈大小、优先级、是否为守护线程。默认为非绑定、非分离、缺省的堆栈、与父进程同样级别的优先级。



**mutex锁本质上是一个spin lock，空转锁** 

```c
PTHREAD_MUTEX_NORMAL；
PTHREAD_MUTEX_ERRORCHECK；
PTHREAD_MUTEX_RECURSIVE；
PTHREAD_MUTEX_DEFAULT
```

> PTHREAD_MUTEX_NORMAL
> 这种类型的互斥锁不会自动检测死锁。如果一个线程试图对一个互斥锁重复锁定，将会引起这个线程的 死锁。如果试图解锁一个由别的线程锁定的互斥锁会引发不可预料的结果。如果一个线程试图解锁已经被解锁的互斥锁也会引发不可预料的结果。
>
> PTHREAD_MUTEX_ERRORCHECK
> 这种类型的互斥锁会自动检测死锁。如果一个线程试图对一个互斥锁重复锁定，将会返回一个错误代 码。如果试图解锁一个由别的线程锁定的互斥锁将会返回一个错误代码。如果一个线程试图解锁已经被解锁的互斥锁也将会返回一个错误代码。 
>
> PTHREAD_MUTEX_RECURSIVE
> 如果一个线程对这种类型的互斥锁重复上锁，不会引起死锁，一个线程对这类互斥锁的多次重复上锁必须由这 个线程来重复相同数量的解锁，这样才能解开这个互斥锁，别的线程才能得到这个互斥锁。如果试图解锁一个由别的线程锁定的互斥锁将会返回一个错误代码。如果 一个线程试图解锁已经被解锁的互斥锁也将会返回一个错误代码。这种类型的互斥锁只能是进程私有的（作用域属性为PTHREAD_PROCESS_PRIVATE）。
>
> PTHREAD_MUTEX_DEFAULT
> 这种类型的互斥锁不会自动检测死锁。如果一个线程试图对一个互斥锁重复锁定，将会引起不可预料的结果。 如果试图解锁一个由别的线程锁定的互斥锁会引发不可预料的结果。如果一个线程试图解锁已经被解锁的互斥锁也会引发不可预料的结果。POSIX标准规定，对于某一具体的实现，可以把这种类型的互斥锁定义 为其他类型的互斥锁。



```c
PTHREAD_MUTEX_INITIALIZER 
// 用于静态的mutex的初始化，采用默认的attr。
// 比如: static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

int pthread_mutex_init(pthread_mutex_t *restrict mutex, const pthread_mutexattr_t *restrict attr); 
int pthread_mutex_destroy(pthread_mutex_t *mutex); 
int pthread_mutex_lock(pthread_mutex_t *mutex); 
int pthread_mutex_trylock(pthread_mutex_t *mutex); 
int pthread_mutex_unlock(pthread_mutex_t *mutex); 

/* Initialize mutex attribute object ATTR with default attributes
   (kind is PTHREAD_MUTEX_TIMED_NP).  */
int pthread_mutexattr_init (pthread_mutexattr_t *attr);
int pthread_mutexattr_settype (pthread_mutexattr_t *attr, int kind);
int pthread_mutexattr_destroy (pthread_mutexattr_t *attr);
```



**基本上所有的问题都可以用互斥的方案去解决，大不了就是慢点儿，但不要不管什么情况都用互斥，都能采用这种方案不代表都适合采用这种方案。** 



**如果是读多写少的场合，就比较适合读写锁(reader/writter lock)** 

**Reader-Writter Lock，有的地方也叫Shared-Exclusive Lock，共享锁。** 

> Reader-Writter Lock的特性是这样的，当一个线程加了读锁访问临界区，另外一个线程也想访问临界区读取数据的时候，也可以加一个读锁，这样另外一个线程就能够成功进入临界区进行读操作了。此时读锁线程有两个。当第三个线程需要进行写操作时，它需要加一个写锁，这个写锁只有在读锁的拥有者为0时才有效。也就是等前两个读线程都释放读锁之后，第三个线程就能进去写了。总结一下就是，读写锁里，读锁能允许多个线程同时去读，但是写锁在同一时刻只允许一个线程去写。



```c
PTHREAD_RWLOCK_INITIALIZER
int pthread_rwlock_init(pthread_rwlock_t *restrict rwlock, const pthread_rwlockattr_t *restrict attr);
int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
int pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
```



为了避免写线程饥饿，必须要在创建读写锁的时候设置`PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE`，不要用`PTHREAD_RWLOCK_PREFER_WRITER_NP`啊，这个似乎没什么用，感觉应该是个bug，不要问我是怎么知道的

```
enum
{
  PTHREAD_RWLOCK_PREFER_READER_NP,
  PTHREAD_RWLOCK_PREFER_WRITER_NP, // 妈蛋，没用，一样reader优先
  PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP,
  PTHREAD_RWLOCK_DEFAULT_NP = PTHREAD_RWLOCK_PREFER_READER_NP
};
```



**spin lock 空转锁** 

```c
PTHREAD_SPINLOCK_INITIALIZER
int pthread_spin_init (__pthread_spinlock_t *__lock, int __pshared);
int pthread_spin_destroy (__pthread_spinlock_t *__lock);
int pthread_spin_trylock (__pthread_spinlock_t *__lock);
int pthread_spin_unlock (__pthread_spinlock_t *__lock);
int pthread_spin_lock (__pthread_spinlock_t *__lock);
```



> **spin lock 空转锁** 
>
> 上面在给出mutex锁的实现代码的时候提到了这个spin lock，空转锁。它是互斥锁、读写锁的基础。在其它同步机制里condition variable、barrier等都有它的身影。
>
> 我先说一下其他锁申请加锁的过程，你就知道什么是spin lock了。
>
> 互斥锁和读写锁在申请加锁的时候，会使得线程阻塞，阻塞的过程又分两个阶段，第一阶段是会先空转，可以理解成跑一个while循环，不断地去申请锁，在空转一定时间之后，线程会进入waiting状态(对的，跟进程一样，线程也分很多状态)，此时线程就不占用CPU资源了，等锁可用的时候，这个线程会被唤醒。
>
> 为什么会有这两个阶段呢？主要还是出于效率因素。
>
> - 如果单纯在申请锁失败之后，立刻将线程状态挂起，会带来context切换的开销，但挂起之后就可以不占用CPU资源了，原属于这个线程的CPU时间就可以拿去做更加有意义的事情。假设锁在第一次申请失败之后就又可用了，那么短时间内进行context切换的开销就显得很没效率。
> - 如果单纯在申请锁失败之后，不断轮询申请加锁，那么可以在第一时间申请加锁成功，同时避免了context切换的开销，但是浪费了宝贵的CPU时间。假设锁在第一次申请失败之后，很久很久才能可用，那么CPU在这么长时间里都被这个线程拿来轮询了，也显得很没效率。
>
> 于是就出现了两种方案结合的情况：在第一次申请加锁失败的时候，先不着急切换context，空转一段时间。如果锁在短时间内又可用了，那么就避免了context切换的开销，CPU浪费的时间也不多。空转一段时间之后发现还是不能申请加锁成功，那么就有很大概率在将来的不短的一段时间里面加锁也不成功，那么就把线程挂起，把轮询用的CPU时间释放出来给别的地方用。
>
> #### 还是要分清楚使用场合
>
> 了解了空转锁的特性，我们就发现这个锁其实非常适合临界区非常短的场合，或者实时性要求比较高的场合。
>
> 由于临界区短，线程需要等待的时间也短，即便轮询浪费CPU资源，也浪费不了多少，还省了context切换的开销。 由于实时性要求比较高，来不及等待context切换的时间，那就只能浪费CPU资源在那儿轮询了。
>
> 不过说实话，大部分情况你都不会直接用到空转锁，其他锁在申请不到加锁时也是会空转一定时间的，如果连这段时间都无法满足你的请求，那要么就是你扔的线程太多，或者你的临界区没你想象的那么短。



**线程退出时调用callback，多用来打日志** 

```c
// 这2个函数要成对出现，否则编译不过
void pthread_cleanup_push(void (*callback)(void *), void *arg);
void pthread_cleanup_pop(int execute);
```

你塞进去的callback只有在以下情况下才会被调用：

1. 线程通过pthread_exit()函数退出
2. 线程被pthread_cancel()取消
3. pthread_cleanup_pop(int execute)时，execute传了一个非0值