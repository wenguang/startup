**【搭建vue开发环境】**

安装vue和vue-cli命令行工具

> npm install vue -g
>
> npm install vue-cli -g

在vue-project目录下初始化项目结构、安装依赖、运行

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

