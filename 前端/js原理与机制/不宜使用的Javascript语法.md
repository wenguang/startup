## 不宜使用的Javascript语法

http://www.ruanyifeng.com/blog/2010/01/12_javascript_syntax_structures_you_should_not_use.html

《Javascript语言精粹》附录



**1、with**的本意是减少键盘输入。但它低效率，而且可能会导致意外。

**2、eval**用来直接执行一个字符串。这条语句也是不应该使用的，因为它有性能和安全性的问题。 

**3、位运算**符针对的是整数，而Javascript内部，所有数字都保存为双精度浮点数。如果使用它们的话，Javascript不得不将运算数先转为整数，然后再进行运算，这样就降低了速度。

**4、new**语句，new Object和new Array也不建议使用，可以用{}和[]代替。

**5、void**在大多数语言中，void都是一种类型，表示没有值。但是在Javascript中，void是一个运算符，接受一个运算数，并返回undefined。void 0; // undefined，这个命令没什么用，而且很令人困惑，建议避免使用。