## 从代码片段的疑惑中学习JS的语言特性



```javascript
var a = [];
for (var i = 0; i < 10; i++) {
  a[i] = function () {
    console.log(i);
  };
}
a[6](); // 输出是 10
```

参考：http://es6.ruanyifeng.com/#docs/let





```javascript
function f1()
{
    var N = 0; // N是f1函数的局部变量
    function f2() // f2是f1函数的内部函数，是闭包
    {
        N += 1; // 内部函数f2中使用了外部函数f1中的变量N
        console.log(N);
    }
    return f2;
}

var result = f1();
result(); // 输出1
result(); // 输出2
result(); // 输出3
```

参考：http://www.10tiao.com/html/399/201707/2651494566/1.html

​	   《你不知道的javascript》(上卷)  5.3 闭包—实质问题



```javascript
// 代码段1
a = 2;
var a;
console.log(a);	// 输出为2

// 代码段2
console.log(a);	// 输出为undefined，神奇吧
var a = 2;
```

参考：《你不知道的javascript》(上卷) 第4章—提升



```javascript
// 代码段1
foo(); // 不是 ReferenceError, 而是 TypeError!
var foo = function bar() { // ...
};

//代码段2
foo(); // TypeError
      bar(); // ReferenceError
var foo = function bar() { // ...
};
```

参考：《你不知道的javascript》(上卷) 第4章—4.2



```javascript
foo(); // 1
var foo;
function foo() { console.log( 1 );
}
foo = function() { console.log( 2 );
};
```

参考：《你不知道的javascript》(上卷) 第4章提升—4.3 函数优化



```javascript
for (var i=1; i<=5; i++) { 
  setTimeout( function timer() {
       console.log( i );
   }, i*1000 );
}
//正常情况下，我们对这段代码行为的预期是分别输出数字 1~5，每秒一次，每次一个。
//但实际上，这段代码在运行时会以每秒一次的频率输出五次 6。
```

参考：《你不知道的javascript》(上卷) 5.4 循环与闭包