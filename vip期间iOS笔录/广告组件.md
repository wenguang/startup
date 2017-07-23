### 广告组件

在app上，广告的展示需求多种多样：有满宽平铺的、左右等宽排列的、宫格排列的、轮播展示的、支持gif的（原生已支持）、非等宽高组合的、类pageControl分页的、支持承载wap页的、弹窗的。要怎么设计才能满足多变的运营需求和性能要求呢？

**UI**：以一种iphone的机型为设计size，比如iphone5 ，设计宽则为750像素（750/2=375 为程序的宽度），以这为基础UI人员给出广告宽高显示像素，程序根据机型做等比缩放。

**接口**：以广告id标识一块广告位，接口支持批量获取广告位数据。

**跳转协议**：广告数据中的跳转url是按一定规则配置的，这样就方便把url传给相对独立的组件做跳转，降低耦合性。



**基类（adview）**：

* 持有—adId
* 与id对应的广告数据列表(adList)，1个广告位对应1到多帧广告，1帧对应1个url
* designWidth（设计宽），子类根据不同的布局要求属性，平铺或宫格中增加itemWidth & itemHeight（各帧等宽高）、帧之间的间隔等等
* layoutUI方法，子类可重载该方法，实现不同展示规则的UI，根据设计size和adList可构建复杂的UI布局，如collectionView实现不规则布局、pageControll实现分页布局、scrollView+timer实现轮播等等
* onTouchImage:方法，参数中image.tag与adList中广告帧的index对应，基类中只是取出image对应的url，传跳转组件。子类可重载实现不同处理逻辑



**外部调用**

1､除wap专题广告外（wap专题单独讲），其他的高度都是可预知的，这就可以给adview指定布局属性，这些adview加到dictionary中（key为adid）

2､批量请求广告数据，根据adid取数据赋给adview，调用adview的layoutUI