### 剖析WebViewJavascriptBridge

**JS调用OC序列 **（js-oc-js）

**js核心方法：_doSend(message, responseCallback), _fetchQueue()**

1、message是一个json对象，message可以包含oc的handlerName、handlerName的参数data、如果有responseCallback（保存着这个回调，待步骤3调用先再删除掉），得把callbackId也装到message中。然后把message加入sendMessageQeueu队列中，把responseCallback回调装到responseCallbacks json对象中（callbackId为key，回调为value）。、最后设置messageIframe.src为定义好的url，这样就触发了webview的跳转流程 (这个iframe初始化时就加到DOM中，style.display设为none)。

2、以wkwebview为例，在delegate方法decidePolicyForNavigationAction中判断navigationAction.request.URL，去获取js的sendMessageQueue队列的数据。\_webView evaluateJavaScript:[_base webViewJavascriptFetchQueyCommand] completionHandler:^(NSString* result, NSError* error)调用js的_fetchQueue()方法得到js队列中的数据返回到result中。这样才算成功把js的数据给oc。根据message的handlerName取出oc的handler，handler有两个参数，一是message中的data，二是回调block，handler把自己的处理结果作为参数传给这个回调block，回调block把处理结果和message中的callbackId装到json中，通过调用js的\_handleMessageFromObjC方法传回给js端。

3、\_handleMessageFromObjC中，从参数中取出callbackId，从而得到步骤1中的callback，再把oc端的处理结果作为参数传callback去执行，执行完删除掉callback，就是完成了整个流程。

**OC调用JS序列**（oc-js-oc）

**js核心方法：(void)sendData:responseCallback:handlerName: \_handleMessageFromObjC(messageJSON)**

1、一样是封装需要调用的js端的handlerName、传给js的data、oc的callbackId到message中（保留着callback的block，待步骤3调用完再删除掉），oc调用js的\_handleMessageFromObjC方法。

2、js取出oc传过到的handlerName、data，把data传给相关的handler去执行，如果oc也传过去了callbackId，那就创建一个回调，把js的handler的处理结果传这个回调，在这个回调中又要调用_doSendMessage把处理结果responseData、callbackResponseId（就是oc传过来的callbackId）传回给oc调（message入队列、设置iframe的src触发webview的处理流程）。

3、通过js回传的callbackResponseId取出步骤1中的block，且把js的处理结果responseData作为参数传给block去执行，执行完删除掉callback，就是完成了整个流程。



**需要注意的点** 

* oc在给js传数据时，要对特殊字符做转义，参考：[js特殊字符转义](http://www.cnblogs.com/rrooyy/p/5349978.html)

* 调用webview的evaluateJavascript方法要在主线程。

* js的自执行函数编写方法