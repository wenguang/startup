## vue计算属性、watch属性

在[vue-计算属性.html](https://github.com/wenguang/startup/blob/master/%E5%89%8D%E7%AB%AF/%E6%A1%86%E6%9E%B6%E7%AF%87/vue/vue-%E8%AE%A1%E7%AE%97%E5%B1%9E%E6%80%A7.html)，用计算属性和methods的结果是一样的，那为什么要用计算属性呢？

**因为** 

不同的是**计算属性是基于它们的依赖进行缓存的**。计算属性只有在它的相关依赖发生改变时才会重新求值。这就意味着只要 `message` 还没有发生改变，多次访问 `reversedMessage` 计算属性会立即返回之前的计算结果，而不必再次执行函数。



**要注意的是** 

计算属性依赖的属性必须是响应式的，不然，即使属性变化了，也不触发计算属性重新计算。比如计算属性reversedMessage就依赖于属性message，而message是vue做过绑定的，即为响应式的，当message变化时就会触发reversedMessage的重新计算。而下面这个例子就不同了

```javascript
computed: {
  now: function () {
    return Date.now()
  }
}
```

now所依赖的Date.now()不是响应式的，因为vue没绑定过它。



**计算属性与watched属性** 

```javascript
var vm = new Vue({
  data: {
    a: 1,
    b: 2,
    c: 3
  },
  watch: {
    a: function (val, oldVal) {
      console.log('new: %s, old: %s', val, oldVal)
    },
    // 方法名
    b: 'someMethod',
    // 深度 watcher
    c: {
      handler: function (val, oldVal) { /* ... */ },
      deep: true
    }
  }
})
vm.a = 2 // => new: 2, old: 1
```

watch也很好理解：就是监听某些属性，当这些属性变化时，就在给定回调函数里做些什么。**相比下，通常计算属性比watched属性用起来更多简洁些** 



**watch的好用处** 

虽然计算属性在大多数情况下更合适，但有时也需要一个自定义的 watcher。这是为什么 Vue 通过 watch 选项提供一个更通用的方法，来响应数据的变化。**当你想要在数据变化响应时，执行异步操作或开销较大的操作，这是很有用的。** 