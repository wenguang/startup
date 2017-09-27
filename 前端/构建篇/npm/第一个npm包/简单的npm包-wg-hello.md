##简单的npm包-wg-hello

新建目录wg-hello

npm init 初始化

最简单的package.json

```json
{
  "name": "wg-hello",
  "version": "1.0.0",
  "description": "first test npm package",
  "main": "index.js",
  "author": "wenguang",
  "license": "MIT"
}
```

index.js也只有一个函数，输出hello

```javascript
function sayHello() {
	console.log('hello, world');
}
exports.sayHello = sayHello;
```

发布say-hello-world包到npm

- 首先要[注册一个npm账号](https://www.npmjs.com/signup)(如果没有的话)
- 注册完后，在命令窗口运行`npm adduser`(登陆npm),会提示你输入用户名和密码；
- 登陆成功后，在wg-hello目录下执行命令`npm publish`(发布package)
- 发布成功后就可以[登陆到npm官网](https://www.npmjs.com/login)去看自己发布的package: https://www.npmjs.com/package/wg-hello。



#### 调用wg-hello

新建目录npm install wg-hello，安装在子目录node_modules下，新建hello.js

```javascript
var wg = require('wg-hello');
wg.sayHello();
```

> node hello.js



#### 更新wg-hello包

改动下index.js，输出hello world改成hello world. version update.

> npm version patch 

版本更新为1.0.1

npm publish 发布

在调用目录下 npm update wg-hello 即可