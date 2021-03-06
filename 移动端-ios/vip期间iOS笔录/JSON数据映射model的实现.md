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

* 对象类型的几个要点：判断相方的，一是objc_property_t的类型propertyType，二是对应的jsonValue的类型

  * **@encode(xxx)** 得到rumtime的类型编码（[类型编码](http://nshipster.cn/type-encodings/)），xxx可以值类型，也可以是对象类型

  * 对象编码@表示id，@"NSString"表示NSString类型，@号与"号也是字符串的一部，所以注意判断编码类型时，判断语句：

    ```objective-c
    [propertyType isEqualToString:@"@\"NSString\""]
    ```

  * propertyType为NSString及子类、NSDictionary及子类、id，就可以直接赋值对property。

  * propertyType为NSArray及子类，则用数组的第一个元素类型判断，若为NSNumber、NSString、NSArray及子类，就可把这个数组的jsonValue赋值给property了；不然就进行【1】。

  * 【1】propertyType为NSString、NSDictionay、NSArray及id以外的类型，且jsonValue的类型为NSDictionay时，可以被被看作是自定义类，则用typeOfXXX取得自定义类型，用XXX和json解析得到一个XXX的对象，这个对象再赋值对model的property

    ```objective-c
    NSDictionary *modelDictionary = (NSDictionary *)jsonValue;
                        SEL typeOfClassMethod = [self typeOfClassMethodFromPropertyName:propertyName];
                        id currentObject = nil;
                        if ([model respondsToSelector:typeOfClassMethod])
                        {
                            Class theModelClass = [self savePerformSelectorForModle:model selector:typeOfClassMethod parameterObject:nil];
                            currentObject = [self runtimeParseObject:theModelClass jsonDictionary:modelDictionary];
                        }
                        [self savePerformSelectorForModle:model selector:setMethod parameterObject:currentObject];
    ```

    ​

