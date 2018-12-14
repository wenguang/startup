## 看看FDT是怎么实现的

[UITableView-FDTemplateLayoutCell 源码分析](http://www.jianshu.com/p/5fc142ab8573) 

[FDT作者的文章-优化UITableViewCell高度计算的那些事](http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/) 



缓存行高

1、cache key 为 cell的indexPath

2、选用cache storage 为 NSMutableArray或objc_setAssociatedObject（性能优于NSCache）

3、在cell的Delete/Insert操作时，调整缓存数据