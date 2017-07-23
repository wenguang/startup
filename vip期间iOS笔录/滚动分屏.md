### 滚动分屏

1、baseScroll（外层scrollView） 2、upperScroll（上分屏scrollView） 3、lowerScroll（下分屏scrollView）

* baseScroll置为不可滚动，height设为屏幕高度
* upperScroll和lowerScroll可滚动，height设为屏幕高度
* (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset中，根据参数中scrollView是upperScroll或lowerScroll、scroll的contentOffset的设置条件，去设置baseScroll的contentOffset，这就实现了滚动分屏