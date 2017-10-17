## webpack内置插件



#####CommonsChunkPlugin

这种插件不用安装，它就在webpack，只要引入webpack模块，如代码分离插件CommonsChunkPlugin，

```javascript
new webpack.optimize.CommonsChunkPlugin({
	name: 'common'	//指定公共bundle名称
})
```



##### [NamedModulesPlugin](https://doc.webpack-china.org/plugins/named-modules-plugin) 和  [HashedModuleIdsPlugin](https://doc.webpack-china.org/plugins/hashed-module-ids-plugin)  

用处看这里：https://doc.webpack-china.org/guides/caching/#-module-identifiers-

#### UglifyJsPlugin

压缩和混淆代码

```javascript
new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false
      },
      sourceMap: true
    })
```



