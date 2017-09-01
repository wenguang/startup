## 小技巧—了解margin collapse

不同于其他很多属性，盒模型中垂直方向上的Margin会在相遇时发生崩塌，也就是说当某个元素的底部Margin与另一个元素的顶部Margin相邻时，只有二者中的较大值会被保留下来，可以从下面这个简单的例子来学习:

```
.square {   
    width: 80px;   
    height: 80px;   
}   

.red {   
    background-color: #F44336;   
    margin-bottom: 40px;   
}   

.blue {   
    background-color: #2196F3;   
    margin-top: 30px;   
}
```

在上述例子中我们会发现，红色和蓝色方块的外边距并没有相加得到70px，而是只有红色的下外边距保留了下来。我们可以使用一些方法来避免这种行为，不过建议来说还是尽量统一使用margin-bottom属性，这样就显得和谐多了。