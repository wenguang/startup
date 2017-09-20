## 布局—使用box-sizing

[学会使用box-sizing布局](http://www.jianshu.com/p/e2eb0d8c9de6) 



- `padding` + `border` + `width`= 盒子的宽度
- `padding`+ `border` + `height` = 盒子的高度



- 这意味着，如果我们设置一个宽度为`200px`，而实际呈现的盒子的宽度可能会大于`200px`(除非没有左右边框和左右补白)。这可能看起来比较怪，`CSS`设置的宽度仅仅是内容区的宽度，而非盒子的宽度。同样，高度类似
- 这导致的直接结果是当我们希望页面呈现的盒子的宽度是200px的时候，我们需要减去它的左右边框和左右补白，然后设置为对应的CSS宽度。例如上图，我们设置希望盒子宽度为`200px`，则需要先减去左右补白各`20px`，左右边框各`1px`，然后设置对应的`CSS`宽度`158px`。


- 幸运的是，我们有更好的方法达到我们想要的目的

####box-sizing

- 语法：`box-sizing:` `content-box` | `border-box` | `inherit`;

