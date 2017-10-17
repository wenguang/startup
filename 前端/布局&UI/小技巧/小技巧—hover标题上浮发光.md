## 小技巧—hover标题上浮发光

首先，hover一般要改变标题的颜色

```css
x:hover {
    color: #6488ba;
}
```

这是个动态的效果，那transition就少不了

```css
-webkit-transition: all .2s;
-o-transition: all .2s;
transition: all .2s;
```

上浮那就想得用到text-shadow

```css
text-shadow: 1px 1px 1px #FFF;
```

要发光就得用双层shadow，除上浮的shadow，还有设置一个颜色与标题颜色一样，h-shadow v-shadow为0px，blur为正值的shadow，这是个让标题模糊化的效果，两个shadow结合，就有上浮发光的效果了。

```css
text-shadow: 1px 1px 1px #FFF, 0px 0px 1px #6488ba;
```

