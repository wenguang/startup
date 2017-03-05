**JS调用OC序列 **（js-oc-js）

**js核心方法：_doSend(message, responseCallback)**

1、message是一个json对象，message可以包含oc的handlerName、handlerName的参数data、如果有responseCallback，得把callbackId也装到message中。然后把message加入sendMessageQeueu队列中，把responseCallback回调装到responseCallbacks json对象中（callbackId为key，回调为value）。、最后设置messageIframe.src为定义好的url，这样就触发了webview的跳转流程 (这个iframe初始化时就加到DOM中，style.display设为none)。

2、以wkwebview为例，在delegate方法decidePolicyForNavigationAction中判断navigationAction.request.URL，去获取js的sendMessageQueue队列的数据。\_webView evaluateJavaScript:[_base webViewJavascriptFetchQueyCommand] completionHandler:^(NSString* result, NSError* error)调用js的_fetchQueue()方法得到js队列中的数据返回到result中。这样才算成功把js的数据给oc。根据message的handlerName取出oc的handler，handler有两个参数，一是message中的data，二是回调block，handler把自己的处理结果作为参数传给这个回调block，回调block把处理结果和message中的callbackId装到json中，通过调用js的\_handleMessageFromObjC方法传回给js端。

3、\_handleMessageFromObjC中，从参数中取出callbackId，从而得到js的callback，再从参数中取出oc端的处理结果作为callback的参数，执行callback，就是完成了整个流程。

**OC调用JS序列**（oc-js-oc）

**js核心方法：_dispatchMessageFromObjC(messageJSON)**，