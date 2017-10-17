## 怎样学习和使用babel

*说在前面，以写笔记的方式不是很好学习方式，建目录打es代码和babel命令那是好的学习方式，这里只做个简单的查询记录，待打完es6的代码再回头打babel的*



####先列出参考资料

#####Babel用户手册：https://github.com/thejameskyle/babel-handbook/blob/master/translations/zh-Hans/user-handbook.md

#####Babel插件手册：https://github.com/thejameskyle/babel-handbook/blob/master/translations/zh-Hans/plugin-handbook.md （教如何编写自己的babel插件与preset，涉及到很多js编译器的知识。一般用babel自备的插件和preset就够了）

#####阮一峰的babel入门教程写得很清晰：http://www.ruanyifeng.com/blog/2016/01/babel.html



**注意：不要全局安装babel，按着项目安装到本地即行，原因有2点：**

* 在同一台机器上的不同项目或许会依赖不同版本的 Babel 并允许你有选择的更新。
* 这意味着你对工作环境没有隐式依赖，这让你的项目有很好的可移植性并且易于安装。



#### 3种使用babel的方式

**1、编程的方式使用，**项目本地安装babel-core，require引入babel-core后即用。

**2、命令行和REPL方式使用，**安装babel-cli，就可用babel命令转换es代码了，且安装了babel-cli就自带了babel-node工具，我们都知道在终端中打入node就可以以REPL方式编写node代码了，像shell一样。那babel-node命令就提供了es6的REPL环境。

**3、.babelrc的方式使用，这也是最好的方式，**在项目根目录下配置.babelrc文件，加入babel-register，babel-register包改写了require命令，为它加上一个钩子。此后，每当使用`require`加载`.js`、`.jsx`、`.es`和`.es6`后缀名的文件，就会先用Babel进行转码。这样方式具体怎么待后续会打出代码。



####如何配置.babalrc，官方的preset和插件有那些



#### babel-polyfill很重要

https://github.com/babel/babel/blob/master/packages/babel-plugin-transform-runtime/src/definitions.js



#####babel在线转换工具：https://babeljs.io/repl/

##### .babelrc配置参考：https://babeljs.io/docs/usage/babelrc/

##### babel插件与preset集：https://babeljs.io/docs/plugins/



