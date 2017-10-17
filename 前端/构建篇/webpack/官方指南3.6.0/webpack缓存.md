## webpack缓存

目录

* output用chunkhash
* 提取webpack 的样板(boilerplate)和 manifest
* 三方库提取到单独的chunk
* 文件的加载顺序
* 模块标识符



####output用chunkhash

在配置的output中用chunkhash标识输出包，让浏览器在bundle内容修改时才向服务器加载，不然浏览器就用缓存中的内容

代码见 webpack-cache目录下，用npm script配置webpack —watch编译，每当修改内容就生成一个新的包



####提取webpack 的样板(boilerplate)和 manifest 

我们注意到，入口文件生成的bundle中（这里就是app.[chunkhash].js），除入口文件index.js中的代码外，还有webpack本身的模板与manifest。我们都知道用CommonsChunkPlugin指定第三方库名就可以用三方库生成独立chunk bundle，如

```javascript
new webpack.optimize.CommonsChunkPlugin({
    name: 'lodash'
})
```

**然而 CommonsChunkPlugin 有一个较少有人知道的功能是，能够在每次修改后的构建结果中，将 webpack 的样板(boilerplate)和 manifest 提取出来。** 

```javascript
new webpack.optimize.CommonsChunkPlugin({
    name: 'runtime'	// 这个名字不限制，不冲突就行，我试过用xxx也行
})
```

再构建就发现原先app.[chunkhash].js小了很多，只有入口文件本身的代码了，多了个了runtime.[chunkhash].js文件，里面就是webpack 的样板(boilerplate)和 manifest ，**这样代码只更清楚明了** 



#### 三方库提取到单独的chunk

这可以通过使用新的 entry(入口) 起点，以及再额外配置一个 CommonsChunkPlugin 实例的组合方式来实现：见代码webpack-cache，如果所有的三方库生成一个chunk太的话，可按需求拆分vendor1、vendor2，写法见代码webpack-cache。

**注意，引入顺序在这里很重要。`CommonsChunkPlugin` 的 `'vendor'` 实例，必须在 `'runtime'` 实例之前引入。且vendor1、vendor2写在一个CommonsChunkPlugin实例中，数组表示，若分开在两个CommonsChunkPlugin实例中写也会报错** 

```javascript
...
entry: {
        app: './src/index.js',
        vendor1: [
            'lodash'
        ],
        vendor2: [
            'underscore'
        ]
    },
    output: {
        filename: '[name].[chunkhash].js',
        chunkFilename: '[name].[chunkhash].js',
        path: path.resolve(__dirname, 'dist')
    },
    plugins: [
        new CleanWebpackPlugin(['dist']),
        new HtmlWebpackPlugin({
            title: '缓存'
        }),
        // vendor一定要在runtime之前，不然会报错
        new webpack.optimize.CommonsChunkPlugin({
            names: ["vendor2", "vendor1"]
        }),
        // 分开写会报错：ERROR in CommonsChunkPlugin: While running in normal mode it's not allowed to use a non-entry chunk (vendor2)
        // https://github.com/webpack/webpack/issues/1016
        // new webpack.optimize.CommonsChunkPlugin({
        //     name: 'vendor2'
        // }),
        new webpack.optimize.CommonsChunkPlugin({
            name: 'webpackBootstrap'
        })
        // new ExtractTextPlugin("style.css")
    ],
    ...
```



#### 文件的加载顺序

构建后，若非用动态引入的方式，那生成的js都会被HtmlWebpackPlugin生成的index.html引用，加载的顺序先webpackBootstrap->vendor->app，先是webpack本身的模板与manifest，再是三方库，最后是我们自己编写的代码



#### 模块标识符

现在有4个bundle，我们再修改下index.js的内容，重新构建，预想着只有webpackBootstrap和app这两个bundle重新生成，可是看了下chunkhash，发现4个bundle都重新生成了，**这是因为每个 [`module.id`](https://doc.webpack-china.org/api/module-variables#module-id-commonjs-) 会基于默认的解析顺序(resolve order)进行增量（后续分析完webpackBootStrap就明白了）**



幸运的是，可以使用两个插件来解决这个问题。第一个插件是 [`NamedModulesPlugin`](https://doc.webpack-china.org/plugins/named-modules-plugin)，将使用模块的路径，而不是数字标识符。虽然此插件有助于在开发过程中输出结果的可读性，然而执行时间会长一些。第二个选择是使用 [`HashedModuleIdsPlugin`](https://doc.webpack-china.org/plugins/hashed-module-ids-plugin)，推荐用于生产环境构建：

```
new webpack.HashedModuleIdsPlugin()
```

再构建发现vendor1、vendor2的hash没有变化了。