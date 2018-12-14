## iOS8自动行高问题与优化思路（研究FDT之前先看看这篇）

http://www.jianshu.com/p/7a96c97460a4



ios8中，默认地 tableView.rowHeight = UITableViewAutomaticDimension，

1、当设置 tableView.rowHeight = fixed height ; 时，为固定行高，

2、当设置tableView.estimatedRowHeight = estimated height时，为自动行高



**自动行高时，tableview怎么知道自己contentSize呢？** 

总的要说，tableview知道bounds的高度，它先计算出填满bounds的cells高度，然后要滑动中再计算出现在屏幕中的cells的高度，**且ios8不像ios7计算过的cell高度被缓存起来，ios8当cells每次出现在屏幕都要重新计算一次，之所以这样，是因系统认为cell的高度是随时变化的，比如当设置了字体的大小，这是ios8滑动不流畅的原因所在** 



Apple 为了把 Cell 的高度计算变得更灵活，使得是否动态计算高度 or 使用缓存已计算的高度的工作放到了开发者这边，**那开发者要怎样缓存高度呢？** 

 文中提到

1、决定cache key 为 cell的indexPath

2、选用cache storage 为 NSMutableArray或objc_setAssociatedObject（性能优于NSCache）

3、在cell的Delete/Insert操作时，调整缓存数据



那就看看[UITableView-FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell) 是怎样实现的吧 😆😆

