## 小技巧—nav水平、垂直居中

首先把所有元素的border、margin和padding设置为0，这不光是水平居中这样做，写css都先写这个是好习惯。

把display设置为table，margin的左、右设置为auto，这就可以水平居中了。

```css
* {
    padding: 0;
    margin: 0;
    border: 0;
}
nav {
    display: table;
    margin: 0 auto;
}
```

按上面的做法垂直居中也就很容易了