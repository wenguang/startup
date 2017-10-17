// 对于Node来说，模块文件可以看成是一个类。
// 怎么保证每次执行这个模块文件，返回的都是同一个实例呢？
// 很容易想到，可以把实例放到顶层对象global。

function A() {
	this.foo = 'hello'
}
if(!global.foo) {
	global._foo = new A();
}
module.exports = global._foo

// 但是，这里有一个问题，全局变量global._foo是可写的，任何文件都可以修改。