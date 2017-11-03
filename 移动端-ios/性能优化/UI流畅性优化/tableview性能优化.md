## tableview性能优化

http://www.jianshu.com/p/1a047f478ed5



#####以下3点了除了最后一点，前2点要打出代码来才深刻



- **一般在cell中显示图片要用SDWebImage开辟子线程加载，子线程过多也会对主线程产生影响** 
  - 在scrollerView的代理方法中，didEndDragging,didEndDeceleratiing方法中去完成图片异步加载的操作，tableView滑动的时候不做加载。
  - 并且可以在didReceiveMemoryWarning方法中释放掉所有的子线程，防止在内存警告的时候被系统强制关闭。
  - 在dealloc方法中将所有的delegate设置nil
- **但是如果在cell中，有大量的的图片需要设置圆角，这个时候GPU会在当前的屏幕缓冲区外新开辟一个缓冲区进行这部分工作，这样的离屏渲染的方式会导致额外的内存开销。这样的操作如果太多，会导致缓冲区的频繁合并和上下文不断切换，而导致页面出现掉帧的情况。有事我们可以利用imageView.layer.shouldRasterize=YES作为解决方案，但是如果layer及sublayers常常改变的话，它就会一直不停的渲染及删除缓存重新创建缓存，所以这种情况下建议不要使用光栅化，这样也是比较损耗性能的。** 
- **当cell中有大量的控件需要布局的时候，也会出现掉帧卡顿的情况** 
  - 手写代码而非xib
  - 我们可以将cell中控件的的位置提前计算好
  - 当多个视图重叠时，GPU会对其进行合成渲染，而渲染最慢的操作之一是混合，因此当视图结构太复杂就会消耗大量GPU资源，所以当一个控件本身是不透明的，注意设定opaque = YES，这样子可以避免无用的alpha通道合成，降低GPU负载