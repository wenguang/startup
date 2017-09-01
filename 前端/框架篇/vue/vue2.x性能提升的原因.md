## vue2.x性能提升的原因

![](https://github.com/wenguang/startup/blob/master/imgs/vue-faster.png?raw=true)



作者在youtube的视频里也做了简述：[NingJS · Vue.js: the Past and the Future, Evan You, Author of Vue.js - Nanjing September 2016](https://www.youtube.com/watch?v=EiTORdpGqns) 



![](https://github.com/wenguang/startup/blob/master/imgs/vue-virtual-dom.png?raw=true)



watcher追踪组件的依赖，当某个组件数据变化时，vue准确地知道那个结点需要更新，工作最少量的渲染，不必遍历virtual-DOM



另外：可实现定义的Render Function