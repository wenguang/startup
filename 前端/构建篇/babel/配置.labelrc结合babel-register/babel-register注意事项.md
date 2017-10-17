## babel-register注意事项

* `babel-register`只会对`require`命令加载的文件转码，而不会对当前文件转码。
* 由于它是实时转码，所以只适合在开发环境使用。