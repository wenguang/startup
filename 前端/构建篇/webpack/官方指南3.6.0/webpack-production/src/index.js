// import _ from 'lodash';
import { cube } from './math.js';

if (process.env.NODE_ENV !== 'production') {
	console.log('Looks like we are in development mode!');
}

function component() {
    var element = document.createElement('pre');

    // Lodash, now imported by this script
    element.innerHTML = ['Hello webpack', '5 cubed is equal to ' + cube(5)].join('\n\n');

    return element;
}

let element = component();
document.body.appendChild(element);