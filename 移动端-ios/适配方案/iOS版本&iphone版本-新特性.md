## iOS版本&iphone版本-新特性



在我们回顾过去四五年 iOS 系统的发展的时候，不免感叹变化速度之快，迭代周期之短。[iOS 7](https://onevcat.com/2013/06/developer-should-know-about-ios7/) 翻天覆地的全新设计，[iOS 8](https://onevcat.com/2014/07/developer-should-know-about-ios8/) 中 Size Classes 的出现，应用扩展，以及 Cloud Kit 的加入，[iOS 9](https://onevcat.com/2015/06/ios9-sdk/) 里的分屏多任务特性等等。



##### SDK-11：https://onevcat.com/2017/06/ios-11-sdk/

- CoreML（机器学习）、
- ARKit、
- Swift4、
- xcode9（Xcode 9 中的索引系统也使用了新的引擎，据称在大型项目中搜索最高可以达到 50 倍的速度）、
- [Core NFC](https://developer.apple.com/documentation/corenfc) （在 iPhone 7 和 iPhone 7 Plus 上提供基础的近场通讯读取功能）、
- [DeviceCheck](https://developer.apple.com/documentation/devicecheck) - 每天要用广告 ID 追踪用户的开发者现在有了更好地选择 (当然前提是用来做正经事儿)。DeviceCheck 允许你通过你的服务器与 Apple 服务器通讯，并为单个设备设置两个 bit 的数据。简单说，你在设备上用 DeviceCheck API 生成一个 token，然后将这个 token 发给自己的服务器，再由自己的服务器与 Apple 的 API 进行通讯，来更新或者查询该设备的值。这两个 bit 的数据用来追踪用户比如是否已经领取奖励这类信息、
- [IdentityLookup](https://developer.apple.com/documentation/identitylookup) - 可以自己开发一个 app extension 来拦截系统 SMS 和 MMS 的信息、
- [PDFKit](https://developer.apple.com/documentation/pdfkit) - 这是一个在 macOS 上已经长期存在的框架，但却在 iOS 上姗姗来迟。你可以使用这个框架显示和操作 pdf 文件、
- [拖拽](https://developer.apple.com/documentation/uikit/drag_and_drop) - 很标准的一套 iOS API，不出意外地，iOS 系统帮助我们处理了绝大部分工作，开发者几乎只需要处理结果。`UITextView` 和 `UITextField` 原生支持拖拽，`UICollectionView` 和 `UITableView` 的拖拽有一系列专用的 delegate 来表明拖拽的发生和结束。而你也可以对任意 `UIView` 子类定义拖拽行为。和 mac 上的拖拽不同，iOS 的拖拽充分尊重了多点触控的屏幕，所以可能你需要对一次多个的拖拽行为做些特别处理
- [不再支持 32 位 app]() - 虽然在 beta 1 中依然可以运行 32 位 app，但是 Apple 明确指出了将在后续的 iOS 11 beta 中取消支持。所以如果你想让自己的程序运行在 iOS 11 的设备上，进行 64 位的重新编译是必须步骤
- [FileProvider 和 FileProviderUI](https://developer.apple.com/documentation/fileprovider) - 提供一套类似 Files app 的界面，让你可以获取用户设备上或者云端的文件。相信会成为以后文档相关类 app 的标配
- [新的 Navigation title 设计]() - iOS 11 的大多数系统 app 都采用了新的设计，放大了导航栏的标题字体。如果你想采用这项设计的话也非常简单，设置 navigation bar 的 [`prefersLargeTitles`](https://developer.apple.com/documentation/uikit/uinavigationbar/2908999-preferslargetitles) 即可



##### SDK-10：https://onevcat.com/2016/06/ios-10-sdk/

- [Siri API]() 的开放自然是 iOS 10 SDK 中最激动人心也是亮眼的特性
- [User Notifications]()  [活久见的重构 - iOS 10 UserNotifications 框架解析](https://onevcat.com/2016/08/notification/) 
- xcode8
- Swift3



##### SDK-9：https://onevcat.com/2015/06/ios9-sdk/

- [Multitasking]() 多任务特性，特别是分屏多任务使得 iPad 真正变得像一个堪当重任的个人电脑
- watchOS 2 [30 分钟开发一个简单的 watchOS 2 app](http://onevcat.com/2015/08/watchos2/) 
- Swift2
- [App Thinning]() 
  - 因为 iOS app 为了后向兼容，现在都同时包含了 32 bit 和 64 bit 两个 slice。另外在图片资源方面，更是 1x 2x 3x 的图像一应俱全 (好吧现在 1x 应该不太需要了)。而用户使用 app 时，因为设备是特定的，其实只需要其中的一套资源。但是现在在购买和下载的时候却是把整个 app 包都下载了。Apple 终于意识到了这件事情有多傻，iOS 9 中终于可以仅选择需要的内容 (Slicing) 下载了。这对用户来说是很大的利好，因为只需要升级到 iOS 9，就可以节省很多流量。对于开发者来说，并没有太多要做的事情，只需要使用 asset catalog 来管理素材标记 2x 3x 就可以了。
  - 给 App 瘦身的另一个手段是提交 Bitcode 给 Apple，而不是最终的二进制。Bitcode 是 LLVM 的中间码，在编译器更新时，Apple 可以用你之前提交的 Bitcode 进行优化，这样你就不必在编译器更新后再次提交你的 app，也能享受到编译器改进所带来的好处。Bitcode 支持在新项目中是默认开启的，没有特别理由的话，你也不需要将它特意关掉。
- [CloudKit]() 



##### SDK8：https://onevcat.com/2014/07/developer-should-know-about-ios8/

- [应用扩展（Extension）]()  [iOS 通知中心扩展制作入门](http://onevcat.com/2014/08/notification-today-widget/) 


- [Touch ID]() 
- [Photos.framework 框架]()，这个框架用于与系统内置的 Photo 应用进行交互，不仅可以替代原来的 Assets Library 作为照片和视频的选取，还能与 iCloud 照片流进行交互
- [CoreLocation 室内定位]() 现在 CL 可以给出在建筑物中的楼层定位信息了，直接访问 `CLLocation` 实例的 `floor`，如果当前位置可用的话，会返回一个包含位置信息的非 nil 的 `CLFloor` 以标识当前楼层。这个使得定位应用的可能性大大扩展了，想象一下在复杂的地铁站或者大厦里迷路的时候，还可以依赖定位系统，幸福感涌上心头啊。
- [HomeKit]()
- [HealthKit]() 
- [Size Class]() （个人觉得鸡肋）



##### SDK7：https://onevcat.com/2013/06/developer-should-know-about-ios7/

- 后台应用运行和多任务新特性 [WWDC2013笔记 iOS7中的多任务](http://onevcat.com/2013/08/ios7-background-multitask/) 
  - 经常需要下载新内容的应用现在可以通过设置`UIBackgroundModes`为`fetch`来实现后台下载内容了，需要在AppDelegate里实现`setMinimumBackgroundFetchInterval:`以及`application:performFetchWithCompletionHandler: `来处理完成的下载，这个为后台运行代码提供了又一种选择。不过考虑到Apple如果继续严格审核的话，可能只有杂志报刊类应用能够取得这个权限吧。另外需要注意开发者仅只能指定一个最小间隔，最后下没下估计就得看系统娘的心情了。
  - 同样是后台下载，以前只能推送提醒用户进入应用下载，现在可以接到推送并在后台下载。UIBackgroundModes设为remote-notification，并实现`application:didReceiveRemoteNotification:fetchCompletionHandler:`


- [UIKit的力学模型]()    [WWDC2013笔记 UIKit力学模型入门](http://onevcat.com/2013/06/uikit-dynamics-started/) 
- [AirDrop]() 
- [点对点连接 Peer-to-Peer Connectivity]() 
- [Store Kit]() 在内购方面采用了新的订单系统