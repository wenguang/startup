## AMD规范简要

[Javascript模块化编程（三）：require.js的用法](http://www.ruanyifeng.com/blog/2012/11/require_js.html) 



*一般用RequireJS加载的模块要按AMD规范来编写（不按AMD规范编写需要RequireJS做额外的配置才能加载）。*

**模块必须采用特定的define()函数来定义** 



假设要编写一个math模块

```javascript
// math.js

// 编写的模块没有依赖别的模块时
　　define(function (){
　　　　var add = function (x,y){
　　　　　　return x+y;
　　　　};
　　　　return {
　　　　　　add: add
　　　　};
　　});

// 编写的模块依赖别的模块时
　　define(['myLib'], function(myLib){
　　　　function foo(){
　　　　　　myLib.doSomething();
　　　　}
　　　　return {
　　　　　　foo : foo
　　　　};
　　});
```

*当require()函数加载上面math模块的时候，就会先加载myLib.js文件。* 



**更多AMD规范参考：[AMD (中文版)](https://github.com/amdjs/amdjs-api/wiki/AMD-(%E4%B8%AD%E6%96%87%E7%89%88)) ** 