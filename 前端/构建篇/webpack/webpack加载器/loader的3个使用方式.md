## loader的3个使用方式



1：在配置文件webpack.config.js中配置

```
module.exports = {
  module: {
    rules: [
      {
        test: /\.txt$/,
        use: 'raw-loader'
      }
    ]
  }
}

```

2：通过命令行参数方式

```
webpack --module-bind 'txt=raw-loader'

```

3：通过内联使用

```
import txt from 'raw-loader!./file.txt';
```