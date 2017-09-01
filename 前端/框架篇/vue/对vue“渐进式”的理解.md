## 对vue“渐进式”的理解

知乎这篇文章 [Vue2.0 中，“渐进式框架”和“自底向上增量开发的设计”这两个概念是什么？](https://www.zhihu.com/question/51907207?rf=55052497) 给出了很好回答。

总结几点：

* 主张最少
* 不像react那样主张与其协同工作的其它层也使用函数式的编程方法，如Flux、Redux
* 框架做分层设计，每层都可选，不同层可以灵活接入其他方案。当你某一层不想用官方设计时，也可方便接入其它方案

![](https://github.com/wenguang/startup/blob/master/imgs/vue-arch.png?raw=true)

可以看到只有 **声明式**和**组件系统** 是vue的核心

作者在youtube的视频里也做了简述：[NingJS · Vue.js: the Past and the Future, Evan You, Author of Vue.js - Nanjing September 2016](https://www.youtube.com/watch?v=EiTORdpGqns) 



另外  [Vue2.0 中，“渐进式框架”和“自底向上增量开发的设计”这两个概念是什么？](https://www.zhihu.com/question/51907207?rf=55052497) 中提到：**“函数式编程，无副作用，写出来的代码没有bug，这是真理没错”** ，这似乎是react强主张的原因吧。当然现在我还这句话还不能理解，待以后学习吧。