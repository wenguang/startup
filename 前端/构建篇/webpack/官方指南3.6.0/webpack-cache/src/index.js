
// 动态引入
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

// console.log('chunkhash实现缓存....');



import _lodash from 'lodash';
import _underscore from 'underscore';
//import Print from './print.js';

function component() {
    var element = document.createElement('div');

    // Lodash, now imported by this script
    element.innerHTML = _lodash.join(['Hello', 'webpack', '...'], ' ');
    //element.onclick = Print.bind(null, 'Hello webpack!');

    return element;
}

document.body.appendChild(component());