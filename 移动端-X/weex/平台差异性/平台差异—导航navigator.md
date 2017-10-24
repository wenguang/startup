## 平台差异—导航navigator

weex环境没有BOM的概念，要用到weex中的navigator。

虽然在 Android 和 iOS 中也有“历史”和“导航”的概念，但是它是用于多个管理视图之间的跳转的。换句话说，在浏览器中执行“前进”、“后退”仍然会处于同一个页签中，在原生应用中“前进”、“后退”则会真实的跳转到其他页面。

`push(options, callback)` 和 `pop(options, callback)`

```javascript
 <script>
  var navigator = weex.requireModule('navigator')
  var modal = weex.requireModule('modal')
  export default {
    methods: {
      jump (event) {
        console.log('will jump')
        navigator.push({
          url: 'http://dotwe.org/raw/dist/519962541fcf6acd911986357ad9c2ed.js',
          animated: "true"
        }, event => {
          modal.toast({ message: 'callback: ' + event })
        })
      }
    }
  };
</script>
```



navigator API 说明见：https://weex.apache.org/cn/references/modules/navigator.html

