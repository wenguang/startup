## RequireJS简要

[Javascript模块化编程（三）：require.js的用法](http://www.ruanyifeng.com/blog/2012/11/require_js.html) 



RequireJS解决以下两个问题

* 实现js文件的异步加载，避免网页失去响应
* 管理模块之间的依赖性，便于代码的编写和维护



*要用RequireJS加载js模块，先得引入require.js文件。用require.js可以异步加载别的js模块，那加载require.js本身要怎样实现异步加载，避免网页失去响应呢？两个方法* 

* 一个是把它放在网页底部加载（这是为什么？）

* 另一个这样写：

  ```javascript
  <script src="js/require.js" defer async="true" ></script>
  // async属性表明这个文件需要异步加载，避免网页失去响应。IE不支持这个属性，只支持defer，所以把defer也写上
  ```



*加载require.js以后，下一步就要加载我们自己的代码了。假定我们自己的代码文件是main.js，也放在js目录下面。那么，只需要写成下面这样就行了：* 

```javascript
<script src="js/require.js" data-main="js/main"></script>
// data-main属性的作用是，指定网页程序的主模块。在上例中，就是js目录下面的main.js，这个文件会第一个被require.js加载。由于require.js默认的文件后缀名是js，所以可以把main.js简写成main。
```



**主模块的写法** 

*上面说到的main.js，我把它称为"主模块"，意思是整个网页的入口代码。主模块通常依赖别的模块，这就必要在main.js要用require.js异步加载依赖的模块了。*  

```javascript
// main.js
require(['jquery', 'underscore', 'backbone'], function ($, _, Backbone){
  // some code here
});
```

以上加载表示jquery、underscore、backbone与main.js在同一目录下，若依赖模块与主模块不在同一目录，就要用到require.config()方法要配置，**require.config()要写在main.js的头部**。

```javascript
require.config({
  paths: {
    "jquery": "jquery.min",
    "underscore": "underscore.min",
    "backbone": "backbone.min"
  }
});

require.config({
  paths: {
    "jquery": "lib/jquery.min",
    "underscore": "lib/underscore.min",
    "backbone": "lib/backbone.min"
  }
});

require.config({
  baseUrl: "js/lib",
  paths: {
    "jquery": "jquery.min",
    "underscore": "underscore.min",
    "backbone": "backbone.min"
  }
});

require.config({
  paths: {
    "jquery": "https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min"
  }
});
```



**更多RequireJS的用法参考：[require (中文版)](https://github.com/amdjs/amdjs-api/wiki/require-(%E4%B8%AD%E6%96%87%E7%89%88)) ** 