## webpack开发环境



以下工具**仅用于开发环境**，请**不要**在生产环境中使用它们！

https://doc.webpack-china.org/configuration/devtool



**使用source map** 

> 当 webpack 打包源代码时，可能会很难追踪到错误和警告在源代码中的原始位置。例如，如果将三个源文件（`a.js`, `b.js` 和 `c.js`）打包到一个 bundle（`bundle.js`）中，而其中一个源文件包含一个错误，那么堆栈跟踪就会简单地指向到 `bundle.js`。这并通常没有太多帮助，因为你可能需要准确地知道错误来自于哪个源文件。
>
> 为了更容易地追踪错误和警告，JavaScript 提供了 [source map](http://blog.teamtreehouse.com/introduction-source-maps) 功能，将编译后的代码映射回原始源代码。如果一个错误来自于 `b.js`，source map 就会明确的告诉你。
>
> source map 有很多[不同的选项](https://doc.webpack-china.org/configuration/devtool)可用，请务必仔细阅读它们，以便可以根据需要进行配置。
>
> 对于本指南，我们使用 `inline-source-map` 选项，这有助于解释说明我们的目的（仅解释说明，不要用于生产环境）：

在webpack.config.js中加上这行：devtool: 'inline-source-map'

inline-source-map只能在开发环境使用，source-map、hidden-source-map、nosources-source-map可以生产环境使用，详见：https://doc.webpack-china.org/configuration/devtool



**自动编译—观察模式** 

在npm script 加一行也 "watch": "webpack —watch"

运行 `npm run watch`，就会看到 webpack 编译代码，然而却不会退出命令行。这是因为 script 脚本还在观察文件。**唯一的缺点是**，为了看到修改后的实际效果，你需要刷新浏览器。



**自动编译—webpack-dev-server** 

npm install webpack-dev-server

webpack配置加上这几行，更多配置详见：https://doc.webpack-china.org/configuration/dev-server/

```javascript
devServer: {
      contentBase: path.join(__dirname, 'dist'),
      compress: true,
      port: 9000
  }
```

 npm script加"start": "webpack-dev-server —open"， npm start就能自动编译且自动刷新浏览器了



**自动编译—webpack-dev-middleware** 

webpack-dev-middleware是将webpack处理的文件发送到服务器的包装器。 这在内部使用在webpack-dev-server中，但是它可以作为一个单独的包使用，以允许更多的自定义设置。 我们将看一个将webpack-dev-middleware与express结合的例子。

npm install --save-dev express webpack-dev-middleware

webpack.config.js的output结点下加上publicPath: '/'

npm script加上"server": "node server.js" 

server.js源码见./webpack-dev目录下