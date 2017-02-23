潘文光	

工作8年，ios开发5年



2015-5 ~ 今	唯品会	多APP创新业务部	iOS高级工程师（P3）

担任乐蜂网APP主程，主要工作：

* 架构设计、SDK基础组件开发


* 购物主流程、首页、商城页开发
* 保证开发质量—code review、降低crash率、内存性能优化
* Appstore提审发布

扩展Cordova实现Hybird方案，编写不同的plugin，方便适配wap对运营支持。

从4.8.0版本开始实施React-Native动态化方案。

负责https适配、ip/v6支持。

接入智能路由，通过网络探测找到离用户最近的服务器ip列表返回给app，接口由域名访问转为用ip直接访问，减少dns解析的时间，提高网络响应时间。

基于CocoaLumjack实现异常日志的收集和上报。

在产品高蜂用户量达1000万时，app的crash率能保持在千分之二左右。

app的网络连通率在99.5%以上，网络请求平均耗时1秒。

以下分享部分提高乐蜂app质量的技术方案及组件的核心实现

* 网络连通率与接口异常监控组件

  * NetHooker（网络钩子）：

    网络层我们用到ASI和AFN。对于ASI，用Aspects拦截ASIHTTPRequest的reportFailure和reportFinished方法，从中得到网络请求的响应数据；而AFN中，监听AFURLSessionManager中的AFNetworkingTaskDidCompleteNotification通知及AFHTTPRequestOperation中定义了AFNetworkingOperationDidFinishNotification通知，从通知数据中得到网络请求的响应数据的。再用block把响应数据传给NetLogger做分析。

  * NetLogger（监测日志）: 

    接收hooker回传的网络响应数据，根据业务规则解析、过滤网络响应数据（比如4xx、5xx等），然后接格式封装数据传给ReportClient上报。

  * ReportClient（日志上报）: 

    它比较简单，就是AFHTTPRequestOperationManager的子类，上报数据到监控接口。

* 热补丁方案实现

  * 基于JSPatch的实现，oc转为js脚本，用app版本号+key加密js脚本，脚本push到gitlab，打上tag。
  * 后台程序检测到gitlab的有新打的tag，就拉取新tag的脚本压缩生成一个zip包，且提供了这个zip包的url。
  * 在补丁后面编辑补丁版本、tag号、对应的app版本、补丁适配的ios版本，发布补丁。
  * 在app的启动接口中返回补丁描述列表，补丁描述项包含对应的app版本、ios版本及补丁zip包url，过滤补丁描述列表，得到符合条件的补丁url，下载zip，解压后用JSPatch把js转换为oc代码，运用oc代码。

* 广告组件

  在电商app上，广告的展示需求多种多样：有满宽平铺的、左右等宽排列的、宫格排列的、轮播展示的、支持gif的（原生已支持）、非等宽高组合的、类pageControl分页的、支持承载wap页的、弹窗的。要怎么设计才能满足多变的运营需求和性能要求呢？

  - 设计：以一种iphone的机型为设计size，比如iphone5 ，设计宽则为750像素（750/2=375 宽度），以这为UI人员给出广告宽高显示像素，程序根据机型做等比缩放。
  - 接口：以广告id标识一块广告位，接口支持批量获取广告位数据。
  - 跳转协议：广告数据中的跳转url是按一定规则配置的，这样就方便把url传给相对独立的组件做跳转，降低耦合性。

  基类实现：

  - 持有—adId
  - 与id对应的广告数据列表(adList)，1个广告位对应1到多帧广告，1帧对应1个url
  - designWidth（设计宽），子类根据不同的布局要求属性，平铺或宫格中增加itemWidth & itemHeight（各帧等宽高）、帧之间的间隔等等
  - layoutUI方法，子类可重载该方法，实现不同展示规则的UI，根据设计size和adList可构建复杂的UI布局，如collectionView实现不规则布局、pageControll实现分页布局、scrollView+timer实现轮播等等
  - onTouchImage:方法，参数中image.tag与adList中广告帧的index对应，基类中只是取出image对应的url，传跳转组件。子类可重载实现不同处理逻辑

  外部调用

  - 除wap专题广告外（wap专题单独讲），其他的高度都是可预知的，这就可以给adview指定布局属性，这些adview加到dictionary中（key为adid）
  - 批量请求广告数据，根据adid取数据赋给adview，调用adview的layoutUI



2013-6 ~ 2014-12	 创业  肇庆魔方软件公司  技术leader

技术团队5人	负责的项目：

- 知行播客app，英文在线音频播放应用，提供下载、脚本同步。涉及技术：thread、runloop、AudioToolbox、ASI。
- 肇庆水厂信息整合项目一期、二期。
- 中集车辆监控系统，服务端+web端+app端。



2010-7 ~ 2013-5	广州玄武无线科技	 集团信息研发部 .Net工程师、翼讯研发部 iOS工程师

集团信息研发部 （2010-7 ~ 2012-6）：

- 短彩信web客户端，部署给客户提供发送集群短彩信。
- 短彩信运营后台，实现通道、黑白红名单、短信状态查询。

翼讯研发部 （2012-7 ~ 2013-5，2012开始ios开发，个人志愿+ios缺人 内部转岗）：

- 翼讯快销行业巡店app，负责店面信息查询功能、巡店拍照功能、信息录入及上报功能



2009-5 ~ 2010-6	广州力擎网络科技	 研发部	.Net工程师

开发GPS车辆监控产品，主要工作：

- 车载GPS设备对接程序。用socket通信接收GPS设备上报的定位、速度、报警等数据并传送给监控服务器做分发，及下发指令给GPS设备。
- 车辆监控web端。用google map api实现对车辆的定位显示，jquery响应用户的输入发送指令到监控服务器，进而通过设备对接程序下发给GPS设备。

为了优化响应速度，GPS设备中除了登录指令用tcp方式，设备登录后就用udp方式通信+心跳包协议。