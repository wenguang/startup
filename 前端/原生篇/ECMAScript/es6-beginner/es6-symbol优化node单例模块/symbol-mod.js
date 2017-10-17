const FOO_KEY = Symbol.for('foo')

function A() {
	this.foo = 'hello'
}

if (!global[FOO_KEY]) {
	this.foo = new A()
}

module.exports = global[FOO_KEY]