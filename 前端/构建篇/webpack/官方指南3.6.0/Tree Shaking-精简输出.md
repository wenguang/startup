## Tree Shaking-精简输出

*tree shaking* 是一个术语，通常用于描述移除 JavaScript 上下文中的未引用代码(dead-code)。它依赖于 ES2015 模块系统中的[静态结构特性](http://exploringjs.com/es6/ch_modules.html#static-module-structure)，例如 [`import`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) 和 [`export`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export)。



```
npm i --save-dev uglifyjs-webpack-plugin
```

webpack.config.js引入 const UglifyJSPlugin = require('uglifyjs-webpack-plugin');

plugins结点下加上 UglifyJSPlugin()



定义math.js 

```javascript
export function square(x) {
  return x * x;
}

export function cube(x) {
  return x * x * x;
}
```

但在index.js只import入cube函数，import { cube } from './math.js'（解构赋值），在没有UglifyJSPlugin情况，在npm run build建构后在输出bundle.js中还是有square函数的代码，在用UglifyJSPlugin后输出bundle.js中没有square函数的代码，这样就精简了输出