



**【webpack干么用的？】** 

开发部署好的前端模块要在客户端中执行，少不了模块的**加载**和**传输**这两大过程。

我们首先能想到两种极端的方式，一种是每个模块文件都单独请求，另一种是把所有模块打包成一个文件然后只请求一次。显而易见，每个模块都发起单独的请求造成了请求次数过多，导致应用启动速度慢；一次请求加载所有模块导致流量浪费、初始化过程慢。这两种方式都不是好的解决方案，它们过于简单粗暴。

**分块传输**，按需进行懒加载，在实际用到某些模块的时候再增量更新，才是较为合理的模块加载方案。

要实现模块的按需加载，就需要一个对整个代码库中的模块进行静态分析、编译打包的过程。

**webpack** 不仅把js当成模块，样式、图片、字体、HTML 模板等等众多的资源都被看成模块。它对整个代码进行静态分析，分析出各个模块的类型和它们依赖关系，然后将不同类型资源的模块提交给适配的加载器来处理，最后统一生成到js文件中。

下次我们就学习webpack，看它是怎样从**加载**和**传输**两大方面解决问题的。



参考：[Webpack 中文指南—模块系统](http://zhaoda.net/webpack-handbook/module-system.html) 



**【准备webpack环境—最简打包】** 

安装webpack

> npm install webpack -g

在vue-webpack目录下创建package.json，一路回车就好

> npm init

创建index.html和entry.js

```html
<html>
<head>
    <meta charset="utf-8">
</head>
<body>
    <h1 id="app"></h1>
      <!-- 注意这里引入的不是我们创建的文件，而是用webpack生成的文件 -->
    <script src="bundle.js"></script>
</body>
</html>
```

```javascript
document.getElementById('app').innerHTML="hello world";
```

打包

> webpack entry.js bundle.js

成功后看到bundle.js的结构和app.weex.js很像，这时打开浏览器打开index.html可以看到HelloWord了。

再创建一个sub.js，并修改entry.js，重新打包

```javascript
//sub.js
//我们这里使用CommonJS的风格
function getText(){
  var element = document.createElement('h2');
  element.innerHTML = "Hello China";
  return element;
}

module.exports = getText;
```

```javascript
//entry.js 
//引用sub模块
var sub = require('./sub');

var app=document.getElementById('app');
app.innerHTML="hello world";
app.appendChild(sub());
```

可以在vue-webpack目录下运行webpack命令不用带参数，那就要配置webpack.config.js了

```javascript
//entry 入口文件 让webpack用哪个文件作为项目的入口
//output 出口 让webpack把处理完成的文件放在哪里
//module 模块 要用什么不同的模块来处理各种类型的文件，这里未
var Webpack = require("webpack");
module.exports = {
    entry: ["./entry.js"],
    output: {
        path: __dirname,
        filename: "bundle.js"
    }
}
```

webpack命令会自动在当前目录中查找webpack.config.js的配置文件，并按照里面定义的规则来进行执行。

运行webpack报错：Error: Cannot find module 'webpack'，在当前的node_modules下找不到webpack，前面是用全局安装的。在目录下再安装一次

> npm install webpack —save-dev

再运行webpack就打包成功了。以上打包未涉及到css、图片。



参考：[浅析前端模块化](http://zhaomenghuan.github.io/blog/h/20160415.html)、[webpack入坑之旅（一）不是开始的开始](http://blog.guowenfh.com/2016/03/24/vue-webpack-01-base/)（系列） 





**【使用loader】** 

**loader**可以理解为是模块和资源的转换器，它本身是一个函数，接受源文件作为参数，返回转换的结果。这样，我们就可以通过require来加载任何类型的模块或文件。有css-loader、style-loader、file-loader等等。

修改package.json，在devDependencies加上两项

```json
"devDependencies": {
    "css-loader": "^0.28.0",
    "style-loader": "^0.16.1",
    "webpack": "^2.3.3"
}
```

安装依赖：npm install

修改entry.js，加一句`require("!style!css!./style.css")`

再执行`webpack entry.js bundle.js` ，但报错了

```shell
ERROR in ./entry.js
Module not found: Error: Can't resolve 'style' in '/Users/wenguangpan/webpack-step'
BREAKING CHANGE: It's no longer allowed to omit the '-loader' suffix when using loaders.
                 You need to specify 'style-loader' instead of 'style',
                 see https://webpack.js.org/guides/migrating/#automatic-loader-module-name-extension-removed
 @ ./entry.js 1:0-33
 @ multi ./entry.js ./entry.js ./bundle.js
```

官网有解释：https://webpack.js.org/guides/migrating/#automatic-loader-module-name-extension-removed  以上使用loader的方法适用于webpack1.x版本，webpack2.x版本就要修改下了。

在webpack.config.js的output结点后加上

```javascript
module: {
  loaders: [
     {test: /\.css$/, loader: 'style-loader!css-loader'}
   ]
}
```

entry.js的`require("!style!css!./style.css")` 把`!style!css!`去掉，再执行打包就ok了，背景变红色了。

说plugin以前，先简单的了解一下webpack.webconfig.js里面参数的意义：

- `entry`：指入口文件的配置项，它是一个数组的原因是webpack允许多个入口点。 当然如果你只有一个入口的话，也可以直接使用双引号`"./entry.js"`

- `output`：配置打包结果，`path`定义了输出的文件夹，filename则定义了打包结果文件的名称

- `module`：定义了对模块的处理逻辑，这里可以用`loaders`定义了一系列的加载器，以及一些正则。当需要加载的文件匹配test的正则时，就会调用后面的`loader`对文件进行处理，这正是`webpack`强大的原因。

  ​

参考：[webpack入坑之旅（二）loader入门](http://blog.guowenfh.com/2016/03/24/vue-webpack-02-deploy/)、[webpack配置文件](http://zhaoda.net/webpack-handbook/configuration.html) 





**【使用plugin】** 

plugin有webpack内置的，也可以用npm安装第三方的，下面看到简单的例子：给输出的文件头部添加注释信息，使用内置的BannerPlugin，webpack.config.js在mudule结点后添加

```javascript
plugins: [
    new Webpack.BannerPlugin("这里是打包文件头部注释！")
]
```

再重新打包就看到bundle.js头部加了一句：/*! 这里是打包文件头部注释！ */



参考：[webpack入坑之旅（三）webpack.config入门](http://blog.guowenfh.com/2016/03/24/vue-webpack-03-config/)、





**【图片loader】**

> npm install url-loader —save-dev
>
> npm install file-loader —save-dev

这就安装loader到node_modules下了，同时在package.json的devDependencies下自动加上依赖项目，若把—save-dev改为-save，就会在dependencies下自动加上依赖项。也可以编辑package.json的依赖项后用npm install命令安装，效果等效。

然后在webpack.config.js添加这段

```javascript
module: {
    loaders: [
        {test: /\.css$/, loader: 'style-loader!css-loader'},
        {test: /\.png|jpg|jpeg$/, loader: 'url-loader?limit=307200'}	
        //限制大小为300k，添加到这！并且会按照文件大小, 或者转化为 base64, 或者单独作为文件
        //在大小限制后可以加上&name=./[name].[ext]，会将我们的文件生成在设定的文件夹下。
    ]
}
```

在index.html加上两行

```html
<div id="logo1"></div>
<div id="logo2"></div>
```

修改style.css

```css
body {
	background: white;
}
#logo1 {
	width: 300;
	height: 300;
	background-image: url(img/logo-220k.png);
}
#logo2 {
	width: 300;
	height: 300;
	background-image: url(img/logo-338k.png);
}
```

webpack再次打包，刷新页面就看到图片了。【注意】目录下多了一个图片文件：973cc71ca39caf61a8784f3987c5893a.png，这是那个logo-338k.png，它比webpack.config.js加配置的限制大小要大，所以它还是个文件；而logo-220k.png则被转化为base64直接加到bundle.js加了，从bundle.js中看是这样的：

```javascript
/* 10 */
/***/ (function(module, exports) {
module.exports = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAA0oAAAOuCAYAAAA5D+d5  ...太长省略... ";
/***/ }),
  
/* 11 */
/***/ (function(module, exports, __webpack_require__) {
module.exports = __webpack_require__.p + "973cc71ca39caf61a8784f3987c5893a.png";
/***/ })
```



参考：[webpack入坑之旅（四）扬帆起航](http://blog.guowenfh.com/2016/03/24/vue-webpack-04-custom/) 





**【热加载】** 

说热加载前，先看看webpack命令的一些参考

```shell
1	webpack #最基本的启动webpack命令
2	webpack -w #提供watch方法，实时进行打包更新
3	webpack -p #对打包后的文件进行压缩
4	webpack -d #提供SourceMaps，方便调试
5	webpack --colors #输出结果带彩色，比如：会用红色显示耗时较长的步骤
6	webpack --profile #输出性能数据，可以看到每一步的耗时
7	webpack --display-modules #默认情况下 node_modules 下的模块会被隐藏，加上这个参数可以显示这些被隐藏的模块
8	webpack --progress --colors	#项目逐渐变大，webpack的编译时间会变长，可以通过参数让编译的输出内容带有 进度 和 颜色 
```

当中的webpack -w 或 webpack —watch，它检测到资源（代码、图片等等）有变动，就自动编译，当启动监听模式。开启监听模式后，没有变化的模块会在编译后缓存到内存中，而不会每次都被重新编译，所以监听模式的整体速度是很快的。

运行webpack -w后，所做的修改就去刷新下浏览器就行，http://localhost:8080 

这只是自动编译，还是得手动刷新浏览器，不算热加载。下面就看webpack-dev-server了。

```shell
#安装
npm install webpack-dev-server -g
#运行
webpack-dev-server
```

浏览器找开着http://localhost:8080 ，我修改了sub.js，命令行上会看到自动编译，之后就见到http://localhost:8080 自动变化了，再也不用手动刷新浏览器了。webpack-dev-server的原理就有待以后学习了。



参考：[webpack入坑之旅（四）扬帆起航](http://blog.guowenfh.com/2016/03/24/vue-webpack-04-custom/) 





**【让.vue跑起来】** 

想让webpack编译，在package.json的devDependencies下加上这些依赖，执行npm install安装

我是用npm install xxx —save-dev 各个安装的，因为我不知道最新版本

```json
"autoprefixer": "^6.7.7",
"autoprefixer-loader": "^3.2.0",
"babel": "^6.23.0",
"babel-core": "^6.24.1",
"babel-loader": "^6.4.1",
"babel-plugin-transform-runtime": "^6.23.0",
"babel-preset-es2015": "^6.24.1",
"babel-runtime": "^6.23.0",
"node-sass": "^4.5.2",
"sass-loader": "^6.0.3",
"vue-html-loader": "^1.2.4",
"vue-loader": "^11.3.4",
"vue-template-compiler": "^2.2.6"
```

node-sass 和 sass-loader 是为了处理SASS（是SASS还是SCSS？它们是啥？待我google下，嘻...）

安装完依赖后，再来看webpack.config.js配置，在module的loaders结点加上

```javascript
// scss
{ test: /\.scss/, loader: 'style!css!sass?sourceMap'},
// 解析.vue文件
{ test: /\.vue$/, loader: 'vue-loader' },
// 转化ES6的语法
{ test: /\.js$/, loader: 'babel-loader', exclude: /node_modules/ },
```

require可以不用写扩展名，加上以下配置

```javascript
resolve: {
    // require时省略的扩展名，如：require('module') 不需要module.js
    extensions: ['.js', '.vue']
}
```

最后我们把目录结构调整一下：/src/components、/dist，入口js文件放/src下，vue文件放/../components下，webpack.config.js配置如下：

```javascript
var path = require("path");

module.exports = {
    entry: './src/main',
    output: {
        path: path.join(__dirname, './dist'),
        filename: 'mix.js',  //webpack生成的文件名
        publicPath: './dist' //公共文件生成的地址
    }
  
  ...
```

package.json 配置下webpack-dev-server的命令

```json
"scripts": {
  "start": "webpack-dev-server --inline --hot"
}
```

这样就可以用 npm start 来启动服务器了。

做完这些就可以编写app.vue了

```vue
<template>
    <div>
        <h1>姓名：{{name}}</h1>
        <h2>{{age}}</h2>
    </div>
</template>
<script>
    //es6
    export default {
        el:"#app",
         //data:function(){}，下面是es6写法
         data () {
            return {
                name:"guowenfh",
                age:"2q1"
            }
        }
    }
</script>
<style lang="sass">
    /*一定要加lang不然无法编译*/
    /*测试一下对sass的编译*/
    $qwe:#098;
    body{
        background-color: $qwe;
        h1{
            background-color: #eee;
            color: red;
            transform: translate(10%, 10%);/*测试自动添加前缀*/
        }
        h1:hover{
            height:100px;
        }
        h2{
            background-color: #999;
        }
    }
</style>
```

index.html修改如下：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>webpack vue</title>
    <style>
        #app {
            margin: 20px auto;
            width: 800px;
            height: 600px;
        }
    </style>
</head>
<body>
    <div id="app"></div>
    <script src="dist/mix.js"></script>
</body>
</html>
```

最后编译打包，启动服务

> webpack
>
> npm start

http://localhost:8080 



至此、算是把vue运行起来了。



参考：[webpack入坑之旅（五）加载vue单文件组件](http://blog.guowenfh.com/2016/03/25/vue-webpack-05-vue/) 