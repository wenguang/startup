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

// document.body.appendChild(component());

// if (module.hot) {
//     module.hot.accept('./print.js', function() {
//         console.log('Accepting the updated printMe module!');
//         printMe();
//     });
// }

/*
模块热替换可能比较难掌握。为了说明这一点，我们回到刚才的示例中。如果你继续点击示例页面上的按钮，你会发现控制台仍在打印这旧的 printMe 功能。

这是因为按钮的 onclick 事件仍然绑定在旧的 printMe 函数上。

为了让它与 HRM 正常工作，我们需要使用 module.hot.accept 更新绑定到新的 printMe 函数上：
 */

let element = component();
document.body.appendChild(element);

if (module.hot) {
    module.hot.accept('./print.js', function() {
        console.log('Accepting the updated printMe module!');
        // printMe()
        document.body.removeChild(element);
        element =  component();
        document.body.appendChild(element);
    })
}