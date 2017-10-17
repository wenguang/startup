
// function getComponent() {
//     return import(/* webpackChunkName: "lodash" */ 'lodash').then(_ => {
//     	var element = document.createElement('div');
//     	element.innerHTML = _.join(['Hello', 'webpack'], ' ');
//     	return element;
//     }).catch(error => 'An error occurred while loading the component');
// }

// getComponent().then(component => {
// 	document.body.appendChild(component);
// })

import _ from 'lodash';

function component() {
	var element = document.createElement('div');
	var button = document.createElement('button');
	var br = document.createElement('br');

	button.innerHTML = 'Click me and look at the console!';
	element.innerHTML = _.join(['Hello', 'webpack'], ' ');
	element.appendChild(br);
	element.appendChild(button);

	// 注意当调用 ES6 模块的 import() 方法（引入模块）时，必须指向模块的 .default 值，
	// 因为它才是 promise 被处理后返回的实际的 module 对象。
    button.onclick = e => import(/* webpackChunkName: "print" */ './print').then(module => {
    	var print = module.default;
    	print();
    });

    return element;
}

document.body.appendChild(component());