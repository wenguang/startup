## Sublime Text 3 前端插件



####安装Package Control

[Package Control](https://packagecontrol.io/) 是安装与管理插件的工具

使用Ctrl+`快捷键或者通过View->Show Console菜单打开命令行

将以下代码复制后粘贴到命令行中，然后按Enter(回车)，稍等片刻

> import urllib.request,os,hashlib; h = 'df21e130d211cfc94d9b0905775a7c0f' + '1e3d39e33b79698005270310898eea76'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)

如果安装成功，就可以在Preferences菜单下看到Package Settings和Package Control两个菜单。



#### 使用Package Control

command+shift+p调出Package Control，输入ip，智能提示Install Package，回车稍等就会出现插件的输入提示，比如输出emmet，回车稍等安装成功。想要删除已安装的插件也很简单，command+shift+p调出Package Control，输出remove，智能提示Remove Package，回车，选择要删除的插件即行



#### Emmet

它让编写HTML代码变得极其简单高效

基本用法：输入标签简写形式，然后按Tab键

关于Emmet的更多介绍，请查看[官方文档](http://docs.emmet.io/)

这份[速查表](http://docs.emmet.io/cheat-sheet/)，可以帮你快速记忆简写形式



#### SublimeCodeIntel

这是一款代码提示插件，支持多种编程语言

该插件安装时间可能相对较长

更特别的是，安装该插件后需要根据您使用的编程语言进行配置

本部分将以配置JavaScript语言的代码提示功能为例

安装该插件后，mac下配置~/.codeintel/config文件，这就加上智能提示的语言，如

```json
{
    "JavaScript": {
        "javascriptExtraPaths": []
    },
    "Python": {
        "python": '/usr/bin/python',
        "pythonExtraPaths": []
    }
}
```

SublimeCodeIntel支持的语言有JavaScript, Mason, XBL, XUL, RHTML, SCSS, Python, HTML, Ruby, Python3, XML, Sass, XSLT, Django, HTML5, Perl, CSS, Twig, Less, Smarty, Node.js, Tcl, TemplateToolkit, PHP.	更多配置请见https://github.com/SublimeCodeIntel/SublimeCodeIntel



#### Autoprefixer

这是一款CSS3私有前缀自动补全插件，它依赖node，得先安装node

使用方法：在输入CSS3属性后（冒号前）按Tab键，如下图示

![](https://github.com/wenguang/startup/blob/master/imgs/autoprefixer.gif?raw=true)



#### TrailingSpaces

它可以自动将多余的空格标红，以示提醒。当然，如果你想一键摒除之，这也很好办，加入一点配置即可：在 Preferences / Key Bindings – User加上如下代码即可（数组内部，当然快捷键可自行约定，我这里用的是 `ctrl+shift+d` ）；

```json
{ "keys": ["ctrl+shift+d"], "command": "delete_trailing_spaces" }
```



####DocBlockr

可以快速的对函数进行注释。保持代码规范。支持多种语言,有 JavaScript (including ES6), PHP, ActionScript, Haxe, CoffeeScript, TypeScript, Java, Apex, Groovy, Objective C, C, C++ and Rust.

- `/*`:回车创建一个代码块注释
- `/**`:回车在自动查找函数中的形参等等。

它会生成 JSDoc 格式的注释。



####SublimeTmpl

SublimeTmpl能新建html、css、javascript、...等类型的文件模板，SublimeTmpl默认的快捷键:

```shell
ctrl+opt+h html
ctrl+opt+j javascript
ctrl+opt+c css
```



#### SublimeLinter 插件集

js校验：SublimeLinter-jshint

css校验：SublimeLinter-csslint

html校验：SublimeLinter-contrib-htmlhint

都依赖node。SublimeLinter-jshint要用npm安装jshint，SublimeLinter-csslint要用npm安装csslint，安装完后js校验不起作用，因为找不到可执行的linter，在~/.bash_profile加上配置重启sublime即可。见 [Finding a linter executable](http://sublimelinter.readthedocs.io/en/latest/troubleshooting.html#finding-a-linter-executable) 

```shell
hash -r
which linter
```



#### HTML-CSS-JS Prettify

一款集成了格式化（美化）html、css、js三种文件类型的插件，即便html,js写在PHP文件之内。插件依赖于nodejs，command+ctrl+H就可完成美化



#### JsFormat

即可在JS文件中通过鼠标右键->JsFormat或键盘快捷键Ctrl+Alt+F对JS进行格式化



#### CssComb

它依赖node，得先安装node

CssComb是为CSS属性进行排序和格式化插件

使用方法：菜单Tools->Run CSScomb或在CSS文件中按快捷键Ctrl+Shift+C



#### SideBarEnhancements

SideBarEnhancements是一款很实用的右键菜单增强插件，在安装该插件前，在Sublime Text左侧FOLDERS栏中点击右键，只有寥寥几个简单的功能，安装后多了不少实用的右键功能



#### Terminal

即可使用快捷键Ctrl+Shift+T在subl当前根目录下呼出命令行窗口



#### vue-syntax-highlight

.vue文件语法高亮显示



#### babel

babel插件



#### MarkdownEditing和MarkdownPreview

支持markdown编辑和预览



[如何优雅地使用Sublime Text](http://www.jeffjade.com/2015/12/15/2015-04-17-toss-sublime-text/) 

