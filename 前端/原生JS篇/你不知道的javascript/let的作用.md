## let的作用

 

~~

**块作用域和闭包联手** 



分析下面两段代码的输出

```javascript
for (var i=1; i<=5; i++) { 
  setTimeout( function timer() {
       console.log( i );
   }, i*1000 );
}

for (let i=1; i<=5; i++) { 
  setTimeout( function timer() {
       console.log( i );
   }, i*1000 );
}
```



参考：《你不知道的javascript》(上卷) 5.4 循环与闭包