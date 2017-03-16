### JSON数据映射model的实现

代码：[JsonParser](https://github.com/wenguang/NetRef/blob/master/NetRef/JsonParser.m)

* 关键runtime方法：

  * **objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount)**，得到当前类层次的objc_property_t的链表（可用properties[i]取得第i个property）和property的个数。
  * **const char *property_getName(objc_property_t property) **，取得property的名称。
  * **char *property_copyAttributeValue(objc_property_t property, const char *attributeName)**， attributeName参数传'T'取得property的类型。

* 两种给property赋值的方式：

  为property生成setXXX的SEL，[jsonDic valueForKey:propertyName]取得jsonValue。

  * 当propertyType为对象时，[model performSelector:setXXX withObject:jsonValue];

  * 当propertyType为数值时，用NSInvocation的方式赋值

    ```objective-c
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[model methodSignatureForSelector:setMethod]];
    [invocation setSelector:setMethod];
    [invocation setTarget:model];
    [invocation setArgument:&xxxValue atIndex:2];
    [invocation invoke];
    ```

* 遍历model的父类，止于NSObject