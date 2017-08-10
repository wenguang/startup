**【CommonJS规范】主要用于node.js服务器端，同步加载** 

**关键字：require、module、exports；** 

文件即模块；

文件内代码运行在模块作用域，不污染全局作用域，除非用module.exports导出；

每个模块都有个module对象；

每个模块提供一个exports变量；

模块按代码出现顺序加载；

**模块可以多次加载，但是只会在第一次加载时运行一次，然后运行结果就被缓存了，以后再加载，就直接读取缓存结果。要想让模块再次运行，必须清除缓存；** 



可用 node xxx.js 命令把xxx的module打印出来看看

```javascript
// module.id 模块的识别符，通常是带有绝对路径的模块文件名。
// module.filename 模块的文件名，带有绝对路径。
// module.loaded 返回一个布尔值，表示模块是否已经完成加载。
// module.parent 返回一个对象，表示调用该模块的模块。
// module.children 返回一个数组，表示该模块要用到的其他模块。
// module.exports 表示模块对外输出的值。
```

exports变量默认指向module.exports

```javascript
// 正确
exports.log = function(x) {console.log(x)};

// 正解
fun1 = function() {return 1};
fun2 = function() {return 2};
module.exports = {
  fun1 = fun1;
  fun2 = fun2;
}

// 错误，exports不能直接指向一个值
exports = function(x) {console.log(x)};

// 以下也是错误的，由于第2行重置了exports，第1行也就无法输出了
exports.hello = function() { return 'hello'};
module.exports = 'Hello world';
```

require加载缓存

```javascript
require('./example.js');
require('./example.js').message = "hello";
require('./example.js').message
// "hello"

// 第二次加载的时候，为输出的对象添加了一个message属性。
// 但是第三次加载的时候，这个message属性依然存在，
// 这就证明require命令并没有重新加载模块文件，而是输出了缓存

// 删除指定模块的缓存
delete require.cache[moduleName];
// 删除所有模块的缓存
Object.keys(require.cache).forEach(function(key) {
  delete require.cache[key];
})
```

require.main

```javascript
// 可以用来判断模块是直接执行，还是被调用执行
require.main === module
// true
```



**关于加载的各种坑** 

```javascript
// lib.js
var counter = 3;
function incCounter() {
  counter++;
}
module.exports = {
  counter: counter,
  incCounter: incCounter,
};

// main.js
var counter = require('./lib').counter;
var incCounter = require('./lib').incCounter;

console.log(counter);  // 输出是3，容易懂
incCounter();
console.log(counter); // 这里输出什么？

// 输出是3，what? why?
// 还记得这句吗？
// 模块可以多次加载，但是只会在第一次加载时运行一次，然后运行结果就被缓存了
// 记住：值和函数说到底都是内存空间，加载后就被固定在缓存中了，
// 函数的变化在于不同的输入产生不同的输出而已
// counter变量引出后，incCounter函数内部和引出的counter已经不在同一作用域了
```



**require加载过程** 

```javascript
Module._load = function(request, parent, isMain) {
  // 1. 检查 Module._cache，是否缓存之中有指定模块
  // 2. 如果缓存之中没有，就创建一个新的Module实例
  // 3. 将它保存到缓存
  // 4. 使用 module.load() 加载指定的模块文件，
  //    读取文件内容之后，使用 module.compile() 执行文件代码
  // 5. 如果加载/解析过程报错，就从缓存删除该模块
  // 6. 返回该模块的 module.exports
};

// 以下有点看不懂了~~~

// 上面的第4步，采用module.compile()执行指定模块的脚本，逻辑如下
Module.prototype._compile = function(content, filename) {
  // 1. 生成一个require函数，指向module.require
  // 2. 加载其他辅助方法到require
  // 3. 将文件内容放到一个函数之中，该函数可调用 require
  // 4. 执行该函数
};

// require函数及其辅助方法
require(): 加载外部模块
require.resolve()：将模块名解析到一个绝对路径
require.main：指向主模块
require.cache：指向所有缓存的模块
require.extensions：根据文件的后缀名，调用不同的执行函数

// 一旦require函数准备完毕，整个所要加载的脚本内容，就被放到一个新的函数之中，
// 这样可以避免污染全局环境。该函数的参数包括require、module、exports，以及其他一些参数
(function (exports, require, module, __filename, __dirname) {
  // YOUR CODE INJECTED HERE!
});
```



**之所以说`require`加载是同步的，就在于`Module._compile`方法是同步执行，所以`Module._load`要等它执行完成，才会向用户返回`module.exports`的值** 



**循环加载问题、CommonJS兼容AMD问题** 参考：[阮一峰的CommonJS规范](http://javascript.ruanyifeng.com/nodejs/module.html) 