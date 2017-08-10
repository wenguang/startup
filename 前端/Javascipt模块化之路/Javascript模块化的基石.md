## Javascript模块化的基石

*以下Javascript的特性是实现模块化的基础* 



**自执行函数（也叫匿名闭包）** 

*自执行函数的主要作用：防止全局变量污染、不对外暴露私有变量* 

```javascript

/** 立即执行函数的两种写法 **/
(function () { /* code */ } ());
(function () { /* code */ })();


/** 一般对象的写法会暴露内部变量 **/
var myObject = {
    name : "FeeldesignStudio",
    getName : function(){
        return this.name;
    }
};
myObject.name;       //FeeldesignStudio
myObject.getName();  //FeeldesignStudio


/** 立即执行函写法不会暴露内部变量 **/
var myObject = (function(){
    var name = "FeeldesignStudio";
    return {
        getName : function(){
            return name;
        }
    }
})();
myObject.name;       //出错！
myObject.getName();  //FeeldesignStudio
```



**全局变量导入** 

*让自执行函数可以引用别的模块* 

```javascript
var myModule = (function ( $, YAHOO ) {

    function method1(){
        $(".container").html("test");
      	//YAHOO的函数调用...
    }

    return{
        publicMethod: function(){
            method1();
        }
    };

})( jQuery, YAHOO );

myModule.publicMethod();
```



**模块导出** 

*编写可以让别的自执行函数引入的模块，通过在自执行函数中返回一个Object，就可以实现模块导出功能* 

```javascript
var myModule = (function () {

  var module = {}, privateVariable = "Feeldesign";

  function privateMethod() {
    // ...
  }

  module.publicProperty = "FeeldesignStudio";
  module.publicMethod = function () {
    console.log( privateVariable );
  };

  return module;

})();
```



**扩展模式（也叫放大模式）** 

*就是在自执行函数中导入一个全局变量，给该全局变量添加一些实现，再导出。就是结合上面三个特性实现模块的扩展* 

```javascript
var myModule = (function ( my ) {

    my.xxMethod = function () {
        ...
    };

    return my;

})( myModule );
```



**松散扩展模式（也叫宽放大模式）** 

*扩展模式的前提是导入的模块必须已经定义。如果扩展函数对原模块没有依赖，要求原模块必须已经定义就毫无必要了，那也有兼容的写法，只是这种情况不多用* 

```javascript
// 松散扩展模式
var myModule = (function ( my ) {

    my.xxMethod = function () {
        ...
    };

    return my;

})( myModule || {} );	//意思若myModule没有定义就传入一个空对象
```



**更严紧的写法** 

*上述代码还存在一个问题，那就是如果a.js中声明了 `var myModule = …`，b.js中也声明了 `var myModule = …`，这样在引入a.js和b.js时，后者会将前者覆盖，这并不是我们期望的* 

```javascript
(function ( my ) {

    my.xxMethod = function () {
        ...
    }

})( window.myModule = window.myModule || {} );	//这样写就很好啦~
```





【参考】

[深入了解JavaScript模块化编程](http://jerryzou.com/posts/jsmodular/) 

[JavaScript模块化开发（一）——基础知识](http://www.feeldesignstudio.com/2013/09/javascript-module-pattern-basics/) 