### 网络接口监测组件

**NetHacker：网络钩子**

网络层我们通常是用**ASI**和**AFN**，钩子用**Aspects**，那要钩ASI和AFN的那个方法呢？
ASI的reqeust请求报错时会调用**reportFailure**方法，请求完成时会调用reportFinished方法；而AFN中，AFURLSessionManager中定义了AFNetworkingTaskDidCompleteNotification通知，AFHTTPRequestOperation中定义了AFNetworkingOperationDidFinishNotification通知。
这样就可以从aspectInfo.instance和通知数据中得到网络请求结果的相关状态了。再用block把
状态数据传给**NetLogger**做分析。**有一点需要注意：每次Aspects hack相关方法得到的id\<AspectToken\>要保存起来，无用可要逐个执行id\<AspectToken\>的remove方法**

**NetLogger: 监测日志**

开始就把一个block传给**NetHacker**，接收hacker回传的网络状态数据。再就是根据业务规则解析、过滤网络状态数据，然后接格式封装数据传给**ReportClient**上报。

**ReportClient: 日志上报**

它比较简单，就是**AFHTTPRequestOperationManager**的子类，上报数据而已。