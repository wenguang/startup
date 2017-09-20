## 混合（mixins）

对于mixins模式，google一下就知道了，不多说，只是要注意以下几点。



**1、当mixin对象与组件对象有同名的选项时** 

​	1）、同名选项为生命周期钩子函数时：同名钩子函数将混合为一个数组，因此都将被调用。另外，混合对象的 钩子将在组件自身钩子 **之前** 调用 。

```javascript
var mixin = {
  created: function () {
    console.log('混合对象的钩子被调用')
  }
}
new Vue({
  mixins: [mixin],
  created: function () {
    console.log('组件钩子被调用')
  }
})
// => "混合对象的钩子被调用"
// => "组件钩子被调用"
```



​	2）、同名选项为vue对象的预定义选项时：例如 `methods`, `components` 和 `directives`，将被混合为同一个对象。 两个对象键名冲突时，取组件对象的键值对。

```javascript
var mixin = {
  methods: {
    foo: function () {
      console.log('foo')
    },
    conflicting: function () {
      console.log('from mixin')
    }
  }
}
var vm = new Vue({
  mixins: [mixin],
  methods: {
    bar: function () {
      console.log('bar')
    },
    conflicting: function () {
      console.log('from self')
    }
  }
})
vm.foo() // => "foo"
vm.bar() // => "bar"
vm.conflicting() // => "from self"
```



**2、用Vue.mixin可以全局注册mixin对象，但要慎用全局mixin对象，因为它会影响到每个单独创建的Vue实例** 

```javascript
// 为自定义的选项 'myOption' 注入一个处理器。
Vue.mixin({
  created: function () {
    var myOption = this.$options.myOption
    if (myOption) {
      console.log(myOption)
    }
  }
})
new Vue({
  myOption: 'hello!'
})
// => "hello!"
```



**3、自定义选项混合策略** 

...