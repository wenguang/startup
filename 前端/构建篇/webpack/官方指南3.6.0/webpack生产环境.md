## webpack生产环境



#####webpack-merge编写不同环境的配置

```
npm install --save-dev webpack-merge
```

webpack.common.js：开发与生产环境共有配置

webpack.dev.js：开发环境特有配置

webpack.prod.js：生产环境特有配置

用webpack-merge的API可以把webpack.common.js与webpack.dev.js合并成开发环境配置，把webpack.common.js与webpack.prod.js合并成生产环境配置，具体看webpack-production目录下的代码

 修改package.json，指定配置

```json
"start": "webpack-dev-server --open --config webpack.dev.js",
"build": "webpack --config webpack.prod.js"
```



##### 使用生产环境的source map

生产环境不用'inline-source-map'，而是

devtool: 'source-map'



**process.env.NODE_ENV指定环境** 

代码见 webpack-production目录

> 技术上讲，`NODE_ENV` 是一个由 Node.js 暴露给执行脚本的系统环境变量。通常用于决定在开发环境与生产环境(dev-vs-prod)下，服务器工具、构建脚本和客户端 library 的行为。然而，与预期不同的是，无法在构建脚本 `webpack.config.js` 中，将 `process.env.NODE_ENV` 设置为 `"production"`，请查看 [#2537](https://github.com/webpack/webpack/issues/2537)。因此，例如 `process.env.NODE_ENV === 'production' ? '[name].[hash].bundle.js' : '[name].bundle.js'` 这样的条件语句，在 webpack 配置文件中，无法按照预期运行。

