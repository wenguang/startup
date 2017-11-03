## 从入口来看weex做了什么

入口：[WXSDKEngine initSDKEnvironment]; 

首先找到sdk中的main.js，新版本叫native-bundle-main.js

在执行main.js之前，要注册weex自带的组件、模块与处理器

```objective-c
+ (void)registerDefaults
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _registerDefaultComponents];
        [self _registerDefaultModules];
        [self _registerDefaultHandlers];
    });
}
```

注册组件，就是把H5标签映射为可本地渲染的组件

注册方法有个要注意的地方

```objective-c
[self registerComponent:name withClass:clazz withProperties: @{@"append":@"tree"}];
```

比较让人迷惑的也就是Properties中的参数了，这个其实是vue的渲染模式。`@"append":@"tree"`代表是整个vue结点包括子结点生成完之后才会一次性渲染到屏幕，`@"append":@"node"`代表是先渲染自身然后再渲染子节点。**（不甚明了）** 

在注册方法其实是使用`WXComponentFactory`进行注册

```objective-c
NSMutableDictionary *dict = [WXComponentFactory componentMethodMapsWithName:name];
// 这样就得到标签对应的组件方法映射字典
```

在这之前先讲几个相关类的功能，免得迷糊。

- WXInvocationConfig：抽象单例类，为什么用单例(懵逼脸)，使用时需要子类继承
- WXComponentConfig: 继承`WXInvocationConfig`类，存储每个Component的method、name、classname
- WXComponentFactory：单例类，通过字典存储`WXComponentConfig`对象，通过每个`WXComponentConfig`对象操作每个Component的method、name、classname。



最后，WXSDKManager调用WXBridgeContext把得到方法映射交给JavaScriptCore执行，这样就完成了组件注册。

```objective-c
if (properties) {
      NSMutableDictionary *props = [properties mutableCopy];
      if ([dict[@"methods"] count]) {
          [props addEntriesFromDictionary:dict];
      }
      [[WXSDKManager bridgeMgr] registerComponents:@[props]];
  } else {
      [[WXSDKManager bridgeMgr] registerComponents:@[dict]];
  }
```



注册Module过程和注册Component过程类似

注册Handler，这个不需要传给weex，因为就是我们Native端进行调用。所以只需要使用WXHandlerFactory操作就行了。



看下以下几个类，逻辑会再清楚些

- WXSDKInstance：普通类，这个类是一个类似于Controller的类，具有非常多的功能，目前不需要了解具体功能
- WXSDKManager：单例类，通过一个字典存储所有`WXSDKInstance`实例，key是一个唯一值；一个`WXBridgeManager`实例
- WXBridgeManager：单例类，注册，渲染功能都通过调用`WXBridgeContext`对象去跟JS交互
- WXBridgeContext：功能其实不多，render，regist component，regist module，executeJs。就是处理了需要调用js的逻辑。
- WXJSCoreBridge: 这个类才是真正的处理JS调用的类。它实现了WXBridgeProtocol协议，对JavaScriptCore进行了封装，使`WXBridgeContext`调用



![](https://github.com/wenguang/startup/blob/master/imgs/weex-call-js.png?raw=true)



