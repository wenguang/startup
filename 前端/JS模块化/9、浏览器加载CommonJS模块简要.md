## 浏览器加载CommonJS模块简要

[浏览器加载 CommonJS 模块的原理与实现](http://www.ruanyifeng.com/blog/2015/05/commonjs-in-browser.html) 



*浏览器不兼容CommonJS的根本原因，在于缺少四个Node.js环境的变量。*

- module
- exports
- require
- global

*只要能够提供这四个变量，浏览器就能加载 CommonJS 模块。* 



**而Browserify就是干这个事的** 

> npm install -g browserify
>
> npm install -g browser-unpack

*browser-unpack是个解压工具* 

```javascript
// foo.js
module.exports = function(x) {
  console.log(x);
};

// main.js
var foo = require("./foo");
foo("Hi");


$ browserify main.js > compiled.js	//把main.js转为浏览器可用的格式
$ browser-unpack < compiled.js		//compiled.js解包

```

*解包输出* 

```json
[
  {
    "id":1,
    "source":"module.exports = function(x) {\n  console.log(x);\n};",
    "deps":{}
  },
  {
    "id":2,
    "source":"var foo = require(\"./foo\");\nfoo(\"Hi\");",
    "deps":{"./foo":1},
    "entry":true
  }
]
```

*可以看到，browerify 将所有模块放入一个数组，id 属性是模块的编号，source 属性是模块的源码，deps 属性是模块的依赖。* 

