import _ from 'lodash';
import './style.css';
import Icon from './time.jpeg';
import Data from './data.xml';
import printMe from './print.js';

function component() {
    var element = document.createElement('div');

    // Lodash, now imported by this script
    element.innerHTML = _.join(['Hello', 'webpack'], ' ');
    element.classList.add('hello');

    var btn = document.createElement('button');
    btn.innerHTML = "click me and check the console";
    btn.onclick = printMe;
    element.appendChild(btn);

    var myIcon = new Image();
    myIcon.src = Icon;
    element.appendChild(myIcon);

    console.log(Data);

    return element;
}

document.body.appendChild(component());