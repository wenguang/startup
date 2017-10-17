## 模块热替换（HMR）

**HMR** 不适用于生产环境，这意味着它应当只在开发环境使用。更多详细信息，请查看[生产环境构建指南](https://doc.webpack-china.org/guides/production)。



**提在前面的问题：HMR和webpack-dev-server中自动编译有啥区别？** 



**启用HMR** 

修改下webpack-dev-server的配置和使用webpack内置的HMR插件就行（不用再用npm install像安装html-webpack-plugin一样安装HMR插件，它是webpack内置的），在webpack.config.js中require进来webpack模块

```
const webpack = require('webpack');
```

plugins结点下加上 new webpack.HotModuleReplacementPlugin()

devServer结点下加上 hot: true

**还要删除掉 `print.js` 的入口起点，因为它现在正被 `index.js` 模式使用。** 



**问题** 

> 模块热替换可能比较难掌握。为了说明这一点，我们回到刚才的示例中。如果你继续点击示例页面上的按钮，你会发现控制台仍在打印这旧的 `printMe` 功能。
>
> 这是因为按钮的 `onclick` 事件仍然绑定在旧的 `printMe` 函数上。
>
> 为了让它与 HRM 正常工作，我们需要使用 `module.hot.accept` 更新绑定到新的 `printMe` 函数上：

代码见 webpack-hmr目录下



**HMR原理见：https://doc.webpack-china.org/concepts/hot-module-replacement** 