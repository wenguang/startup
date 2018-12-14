**一句话：libco是微信为了提高其C++后台服务的并发能力而实施的非侵入式的协程异步化改造方案** 

* 它是个协程库，要弄懂协程是怎么工作
* 它只能C++编写的服务有用
* 它是对已有的服务的改造，故新服务用天然就支持协程的go编写更好
* 它是非侵入式的，用Hook的方式




**为什么要研究libco** 

​	新的后台服务我确定用go编写，go在语言层面就支持协程，但想在一个语言层面就支持的特性，很难研究出它的实现原理。之所以研究libco，就因为C++原没这个特性，libco实现了它，那就好好研究，里面有很多系统级的知识，对编写高性能的服务很有帮助。




**libco的架构** 

![](https://github.com/wenguang/startup/blob/master/libco%E7%A0%94%E7%A9%B6/libco-arch.png?raw=true)



**关键点**

* 协程的切换没有进程、线程切换的开销大，但还是要做寄存器保存与恢复的工作，libco用汇编来实现。
* ...


[C/C++协程库libco：微信怎样漂亮地完成异步化改造](http://www.infoq.com/cn/articles/CplusStyleCorourtine-At-Wechat) **（文章很精彩）** 

[腾讯协程库libco的原理分析](http://blog.csdn.net/brainkick/article/details/48676403) 