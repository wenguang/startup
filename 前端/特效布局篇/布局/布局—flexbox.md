## flexbox布局

flex容器、flex项目、主轴、交叉轴。不用x轴、y轴是因为主轴的方向是可变的，可定义横向为主轴，也可以定义纵轴为主轴，交叉轴就是与主轴垂直的轴。

设置flex容器的属性

- flex-direction：决定主轴的方向
- flex-wrap：换行规则
- flex-flow：flex-direction和flex-wrap综合
- justify-content：项目在主轴上的对齐方式
- align-items：项目在交叉轴上如何对齐
- align-content：定义了多根轴线的对齐方式

设置flex项的属性

- order：项目的排列顺序。数值越小，排列越靠前，默认为0
- flex-grow：项目的放大比例，默认为0
- flex-shrink：项目的缩小比例，默认为1
- flex-basis：项目占据的主轴空间
- flex：flex-grow, flex-shrink 和 flex-basis的综合
- align-self：允许单个项目有与其他项目不一样的对齐方式

属性具体要设置什么值参考：阮兄的[Flex 布局教程：语法篇](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html) 与 [Flex 布局教程：实例篇](http://www.ruanyifeng.com/blog/2015/07/flex-examples.html)  

