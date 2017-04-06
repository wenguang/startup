**【搭环境】安装weex-toolkit工具集**

> npm install -g weex-toolkit

安装目录在/usr/local/lib/node_modules/weex-toolkit

输入 weex  会看到usage提示，就表示安装成功了



> weex init weexone

weex-toolkit 就为我们生成了标准项目结构

package.json 中已经配置好了几个常用的 npm script，分别是：

```javascript
"scripts": {
    "build": "webpack",		//源码打包，生成 JS Bundle
    "dev": "webpack --watch",	//webpack watch 模式，方便开发
    "serve": "node build/init.js && serve -p 8080",	//开启静态服务器
    "debug": "weex-devtool"	//调试模式
  }
```

dependencies和devDependencies定义了好多依赖，先安装依赖

> cd weexone/
>
> npm install

node_modules目录下就安装了一大堆js组件



> npm run dev	

```shell
wenguangdeMacBook-Pro:weexone wenguangpan$ npm run dev

> weexone@0.1.0 dev /Users/wenguangpan/weex-step-by-step/weexone
> webpack --watch

Hash: 3964f89c358b3b26bd3f
Version: webpack 1.14.0
Time: 1295ms
      Asset     Size  Chunks             Chunk Names
app.weex.js  4.41 kB       0  [emitted]  app
    + 5 hidden modules
Hash: 8d1dfab364b64b339056
Version: webpack 1.14.0
Time: 1434ms
     Asset     Size  Chunks             Chunk Names
app.web.js  15.4 kB       0  [emitted]  app
    + 10 hidden modules

```

它有什么作用？



> npm run server

```shell
wenguangdeMacBook-Pro:weexone wenguangpan$ npm run serve

> weexone@0.1.0 serve /Users/wenguangpan/weex-step-by-step/weexone
> node build/init.js && serve -p 8080

serving /Users/wenguangpan/weex-step-by-step/weexone on port 8080
GET /index.html 200 9ms - 1.6kb
GET /config.js 200 4ms - 30
GET /assets/qrcode.js 200 5ms - 48.89kb
GET /assets/style.css 200 8ms - 1.14kb
GET /assets/url.js 200 4ms - 295
GET /node_modules/vue/dist/vue.js 200 5ms - 238.7kb
GET /weex.html 200 1ms - 891
GET /assets/phantom-limb.js 200 2ms - 10.12kb
GET /node_modules/vue/dist/vue.runtime.js 200 3ms - 172.52kb
GET /dist/app.web.js 200 3ms - 15.02kb
GET /node_modules/weex-vue-render/index.js 200 5ms - 713.49kb
```

打开 http://localhost:8080/index.html ，就可以看到weex的页面了



**【跑iOS上的试例】**

在weexone/下创建iOS目录，创建iOS工程，引入WeexSDK，

把weexplayground的animation.js拷贝到weexone工程中，用WeexViewController（它和WeexSDK中的WXBaseViewController很像）加载animation.js，这就显示出一个weex页面了，里面有很多动画效果。

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	//business configuration
	[WXAppConfiguration setAppName:@"weexone"];
	//init sdk enviroment
	[WXSDKEngine initSDKEnvironment];
	NSString *entry = [[NSBundle mainBundle] pathForResource:@"animation" ofType:@"js"];
	NSURL *url = [NSURL fileURLWithPath:entry];
	UIViewController *vc = [[WeexViewController alloc] initWithSourceURL:url];
	self.window.rootViewController = vc;
	[self.window makeKeyAndVisible];
	return YES;
}
```

animation.js要复杂一些，app.weex.js就简单些，那又该怎样编写.vue并显示呢？一个最简单的.vue又是怎样转化为native显示的呢？



参考：[写给 iOS 程序员的 Weex 教程（2）：打造自己的 iOS host 应用](https://0error0warning.com/blog/14842302030085.html) 中的demo。



**【webpack打包】**

.js文件应该是经webpack打包过的。那来看看webpack怎样打包的。

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
//module 模块 要用什么不同的模块来处理各种类型的文件
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

再运行webpack就打包成功了。以上打包未涉及到css、图片。详见：[浅析前端模块化](http://zhaomenghuan.github.io/blog/h/20160415.html)



**【搭建vue开发环境】**

安装vue和vue-cli命令行工具

> npm install vue -g
>
> npm install vue-cli -g

vue+webpack初始化项目结构、安装依赖、运行

> vue init webpack vue-project
>
> cd vue-project
>
> npm install
>
> npm run dev

```shell
wenguangdeMacBook-Pro:vue-project wenguangpan$ npm run dev

> vue-project@1.0.0 dev /Users/wenguangpan/vue-project
> node build/dev-server.js

> Starting dev server...


 DONE  Compiled successfully in 2166ms                                 下午2:15:02

> Listening at http://localhost:8080
```

http://localhost:8080 看到运行结果，那到底它是怎样工作起来的呢？项目结构各文件有什么作用呢？

package.json有项目结构的描述。



> npm run build

```shell
wenguangdeMacBook-Pro:vue-project wenguangpan$ npm run build

> vue-project@1.0.0 build /Users/wenguangpan/vue-project
> node build/build.js

⠏ building for production...

... //省略

Build complete.

Tip: built files are meant to be served over an HTTP server.
Opening index.html over file:// won't work.
```

在dist目录下生成。



参考：[vuejs-templates/webpack](https://github.com/vuejs-templates/webpack)



**到目前，离我们编写vue页面，打包jsbundle，再到ios weex中运行还有距离**









【参考】[官方教程](https://weex.incubator.apache.org/cn/)、[高阶知识](https://weex.incubator.apache.org/cn/v-0.10/advanced/index.html)、[weex工作原理](https://weex.incubator.apache.org/cn/guide/intro/how-it-works.html) 

[weex在线编辑](http://dotwe.org/vue) 

[Weex调试神器——Weex Devtools使用手册 ](https://github.com/weexteam/article/issues/50) 

[Weex 是如何在 iOS 客户端上跑起来的](http://www.jianshu.com/p/41cde2c62b81) 