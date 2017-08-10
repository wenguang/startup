## this

http://www.ruanyifeng.com/blog/2010/04/using_this_keyword_in_javascript.html

《你不知道的javascript》也中有提到this指定调用点。

阮兄提到的4种情况，情况一：纯粹的函数调用，情况二：作为对象方法的调用，都很好理解。

**要注意的是情况三 作为构造函数调用**，通过这个函数生成一个新对象（object）。这时，this就指这个新对象。

```javascript
var x = 2;
function test(){
  this.x = 1;
}
// 语句A
//test();
// 语句B
//var o = new test();
alert(x); // 当执行语句A时，值为1；当执行语句B时，值为2
```

*当 当执行语句A时，this指定全局上下文，所在this.x =1就把全局变量x的值改为1；当执行语句B时，this指定新对象，this.x = 1实际上修改新对象作用域下的变量x的值，和全局变量x无关，所以输出值仍为2* 



还有**情况四 apply调用**，apply()是函数对象的一个方法，它的作用是改变函数的调用对象，它的第一个参数就表示改变后的调用这个函数的对象。因此，this指的就是这第一个参数。

```javascript
var x = 0;
function test(){
  alert(this.x);
}
var o={};
o.x = 1;
o.m = test;
o.m.apply(); //0
o.m.apply(o); //1
```

*apply()的参数为空时，默认调用全局对象。因此，这时的运行结果为0，证明this指的是全局对象。* 