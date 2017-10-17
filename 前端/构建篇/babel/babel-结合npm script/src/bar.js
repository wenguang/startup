function foo(cb) {
    cb()
}

foo(() => {
    console.log('被babel转换')
})

function foo2() {
    let inp = [1, 2, 3]
    inp.map(item => item + 1)
}