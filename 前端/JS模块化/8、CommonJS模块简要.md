## CommonJS模块简要

**模块导出** 

```javascript
//tool.js
var tool = {
    add: function (a, b){
        return a + b;
    }
}
module.exprots = tool;
```

**模块引用** 

```javascript
var tool = require('./tool');
tool.add(1, 2); //3
```



**require()加载详细过程请参考：[require() 源码解读](http://www.ruanyifeng.com/blog/2015/05/require.html) （阮一峰的文章）** 

