## webpack简介

*有说webpack是模块化打包工具，是因为webpack把一切都视为模块，都把项目中的各种资源处理后得到统一的入口。我把它也归类为构建工具。* 



1、*[入门Webpack，看这篇就够了](http://www.jianshu.com/p/42e11515c10f) 文章有很好的介绍，下面只摘一段作个简介及与gulp的比较，详细请看全文。*

2、[webpack一步步](https://github.com/wenguang/startup/blob/master/%E5%89%8D%E7%AB%AF/%E6%9E%84%E5%BB%BA%E8%87%AA%E5%8A%A8%E5%8C%96/webpack%E4%B8%80%E6%AD%A5%E6%AD%A5.md) 记录一步步如何用webpack



**什么是Webpack** 

WebPack可以看做是**模块打包机**：它做的事情是，分析你的项目结构，找到JavaScript模块以及其它的一些浏览器不能直接运行的拓展语言（Scss，TypeScript等），并将其转换和打包为合适的格式供浏览器使用。

**WebPack和Grunt以及Gulp相比有什么特性** 

其实Webpack和另外两个并没有太多的可比性，Gulp/Grunt是一种能够优化前端的开发流程的工具，而WebPack是一种模块化的解决方案，不过Webpack的优点使得Webpack在很多场景下可以替代Gulp/Grunt类的工具。

Grunt和Gulp的工作方式是：在一个配置文件中，指明对某些文件进行类似编译，组合，压缩等任务的具体步骤，工具之后可以自动替你完成这些任务。

Grunt和Gulp的工作流程

![](https://github.com/wenguang/startup/blob/master/imgs/gulp-working.png?raw=true)

Webpack的工作方式是：把你的项目当做一个整体，通过一个给定的主文件（如：index.js），Webpack将从这个文件开始找到你的项目的所有依赖文件，使用loaders处理它们，最后打包为一个（或多个）浏览器可识别的JavaScript文件。

Webpack工作方式

![](https://github.com/wenguang/startup/blob/master/imgs/webpack-working.png?raw=true)

如果实在要把二者进行比较，Webpack的处理速度更快更直接，能打包更多不同类型的文件。

