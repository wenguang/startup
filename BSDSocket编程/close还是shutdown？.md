

```objective-c
shutdown允许只关闭read或write，也可以read、write都关闭；close只能read、write都关闭。
shutdown比较优雅，会执行TCP的4次挥手过程；close强制关闭，发RST复位包。
```

参考：[socket close()和shutdown()区别](http://www.jianshu.com/p/eecab8d50697) 