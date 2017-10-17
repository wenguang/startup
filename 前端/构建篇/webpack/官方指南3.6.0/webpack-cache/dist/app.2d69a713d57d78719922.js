webpackJsonp([2],{

/***/ "lVK7":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_lodash__ = __webpack_require__("M4fF");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_lodash___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0_lodash__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_underscore__ = __webpack_require__("rdLu");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_underscore___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1_underscore__);

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





//import Print from './print.js';

function component() {
    var element = document.createElement('div');

    // Lodash, now imported by this script
    element.innerHTML = __WEBPACK_IMPORTED_MODULE_0_lodash___default.a.join(['Hello', 'webpack', '...'], ' ');
    //element.onclick = Print.bind(null, 'Hello webpack!');

    return element;
}

document.body.appendChild(component());

/***/ })

},["lVK7"]);