## javascript定义类的三种方法

http://www.ruanyifeng.com/blog/2012/07/three_ways_to_define_a_javascript_class.html



**一、构造函数法** 

构造函数内部用this指代实例，类属性和方法定义在构造函数的prototype对象上。

**二、Object.create()法** 

ECMAScript 5 的标准，它与*构造函数继承中提到的* **空对象作中介** 的方式很像

```javascript
var Cat = {
  name: "大毛",
  makeSound: function(){ alert("喵喵喵"); }
};

if (!Object.create) {
  Object.create = function (o) {
     function F() {}
    F.prototype = o;
    return new F();
  };
}
var cat1 = Object.create(Cat);
alert(cat1.name); // 大毛
cat1.makeSound(); // 喵喵喵
```

***这种方法不能实现私有属性和私有方法，实例对象之间也不能共享数据***  



**三、极简主义法** 

它不用this和prototype

```javascript
var Animal = {
  createNew: function() {
    var animal = {};
    animal.sleep = function(){ alert("睡懒觉"); };
    return animal;
  }
};

var Cat = {
  sound : "喵喵喵",	//数据共享，类数据
  createNew: function(){
    var cat = Animal.createNew();	//继承
    cat.spec = 111;	// 私有变量
    cat.makeSound = function(){ alert(Cat.sound); };
    cat.changeSound = function(x){ Cat.sound = x; };
    return cat;
  }
};
var cat1 = Cat.createNew();
var cat2 = Cat.createNew();
cat1.makeSound(); // 喵喵喵
cat2.changeSound("啦啦啦");
cat1.makeSound(); // 啦啦啦
```

***这种方法实际用了闭包的特性，能实现封装、继承、私有属性与方法、数据共享（即类属性和方法）*** 