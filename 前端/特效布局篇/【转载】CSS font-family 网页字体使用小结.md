# 【转载】CSS font-family 网页字体使用小结

[自用笔记](http://moxfive.xyz/categories/%E8%87%AA%E7%94%A8%E7%AC%94%E8%AE%B0/)[术业专攻](http://moxfive.xyz/categories/%E8%87%AA%E7%94%A8%E7%AC%94%E8%AE%B0/%E6%9C%AF%E4%B8%9A%E4%B8%93%E6%94%BB/)

- [CSS](http://moxfive.xyz/tags/CSS/)
- [font-family](http://moxfive.xyz/tags/font-family/)

## 前言

## 基本用法

### 使用语法

```
font-family: 字体名1, 字体名2, 字体名n, 字体系列名;
font-family: Verdana, Helvetica, "Microsoft YaHei", Arial;

```

### 语法说明

> 1. 系统将选择列表中最先可用的字体来显示文字;
> 2. 因为规则1，通常在最末添加一个 generic-family 字体系列名，保证文字获得相似的显示效果;
> 3. 因为规则1，西文字体名应该写在中文字体前，这样才能中英文同时使用不同字体;
> 4. 字体名为中文或包含空格等时，需要加双引号””才能正确识别;
> 5. 中文字体建议也是用其对应英文字体名，如”微软雅黑”为”Microsoft YaHei”，以提高编码兼容性。

## 常见字体系列

### Serif 衬线字体

- Times New Roman, Georgia 和宋体都是很常见的衬线字体；
- 特征: 文字笔划的开始或结束处有额外的装饰，笔划有粗细之分。

[![serif](http://moxfive.xyz/resources/serif.png)](http://moxfive.xyz/resources/serif.png)

### Sans-serif 无衬线字体

- Arial, Verdana, Tahoma, 微软雅黑都是很常见的无衬线字体;
- 说明: `sans-`源于法语前缀，意思为`没有`。Sans-serif 也就是指无衬线字体。
- 特征: 字体比较圆滑，笔划较为均匀。

[![sans-serif](http://moxfive.xyz/resources/sans-serif.png)](http://moxfive.xyz/resources/sans-serif.png)

- 字体选用: 有种说法是正文多用衬线字体，易于区分；标题多用无衬线字体。不过这个也看个人喜好，我更习惯正文用无衬线字体。如果实在不知道怎么选，随便找一个自己看着舒服的网站，套用它的字体样式好了。

### Monospace 等宽字体

- Courier New, Consolas, Menlo 都是比较常见的等宽字体;
- 特征: 字母、数字、空格以及其他符号所占宽度都一致。识别度高，易于对齐和定位，通常用于显示代码。

[![Monospace](http://moxfive.xyz/resources/Monospace.png)](http://moxfive.xyz/resources/Monospace.png)

- 一个优秀的代码字体除了等宽外，还应该能较好地区分出`0 o O i l 1 I "" '' [] () {}` 等字符。

### Cursive 手写体

- Comic Sans, Author, 华文行楷都是比较常见的仿手写体;
- 特征: 模仿人的手写体，笔划圆滑或者有连笔等装饰。英文的花体，中文的行书草书等都属于此类。

[![cursive](http://moxfive.xyz/resources/cursive.png)](http://moxfive.xyz/resources/cursive.png)

## 获取字体名称

同一个字体在不同系统和应用中可能会显示为不同名字，但其内部一般有一个不变的英文名字。CSS font-family 需要引用的就是字体的内部名字。

### 本地字体

- Win 上通过搜索或控制面板进入字体文件夹，然后双击字体查看字体名称;
- 通过软件，如记事本、Office 等也可以查看字体名字:

[![font-a1](http://moxfive.xyz/resources/font-a1.png)](http://moxfive.xyz/resources/font-a1.png)

- Mac 上搜索打开字体册即可，中间一栏显示的就是字体名称:

[![font-a2](http://moxfive.xyz/resources/font-a2.png)](http://moxfive.xyz/resources/font-a2.png)

### 网页字体

- 审查元素，查看生效的 font-family:

[![font-a3](http://moxfive.xyz/resources/font-a3.png)](http://moxfive.xyz/resources/font-a3.png)

- 通过 Chrome 插件 [WhatFont](http://chengyinliu.com/whatfont.html):

[![font-a4](http://moxfive.xyz/resources/font-a4.png)](http://moxfive.xyz/resources/font-a4.png)

## 字体图标

使用`@font-face`引入字体后，可以像使用文字那样，无损的控制图标的大小，颜色等样式。常见的有 Webdings，Wingdings, [Font Awesome](http://fontawesome.io/).

[![font-icon](http://moxfive.xyz/resources/font-icon.png)](http://moxfive.xyz/resources/font-icon.png)

## 备用记录

### 字体配置

- 下面是自己目前比较常用的字体配置，通常按系列设置为 CSS 预处理器的变量，方便调用。

```
//中文
font-chs = "Microsoft YaHei", "Hiragino Sans GB", "WenQuanYi Micro Hei"
//无衬线字体 sans-serif
font-sans = Verdana, "Helvetica Neue", Helvetica, Tahoma, Arial
//衬线字体 serif
font-serif = Times, Georgia
//等宽字体 monospace
font-mono = Menlo, Consolas, "Source Code Pro", Inconsolata, Monaco, "Courier New"

```

### 字体英文名

- 一些常见中文字体的对应英文名。

| -    | 中文名          | 英文名                     |
| ---- | ------------ | ----------------------- |
| 1    | ** 苹方        | PingFang SC             |
| 2    | ** 冬青黑/苹果丽黑  | Hiragino Sans GB        |
| 3    | ** 思源黑体      | Source Han Sans CN      |
| 4    | ** 华文细黑      | STHeiti Light [STXihei] |
| 5    | ** 华文黑体      | ST Heiti                |
| 6    | ** 华文楷体      | STKaiti                 |
| 7    | ** 华文宋体      | STSong                  |
| 8    | ** 华文仿宋      | STFangsong              |
| 9    | ** 丽黑 Pro    | LiHei Pro Medium        |
| 10   | ** 丽宋 Pro    | LiSong Pro Light        |
| 11   | ** 标楷体       | BiauKai                 |
| 12   | ** 苹果丽中黑     | Apple LiGothic Medium   |
| 13   | ** 苹果丽细宋     | Apple LiSung Light      |
| 14   | ** 新细明体      | PMingLiU                |
| 15   | ** 细明体       | MingLiU                 |
| 16   | ** 标楷体       | DFKai-SB                |
| 17   | ** (中易)黑体    | SimHei                  |
| 18   | ** 宋体        | SimSun                  |
| 19   | ** 新宋体       | NSimSun                 |
| 20   | ** 仿宋        | FangSong                |
| 21   | ** 楷体        | KaiTi                   |
| 22   | ** 仿宋_GB2312 | FangSong_GB2312         |
| 23   | ** 楷体_GB2312 | KaiTi_GB2312            |
| 24   | ** 微软正黑体     | Microsoft JhengHei      |
| 25   | ** 微软雅黑      | Microsoft YaHei         |
| 26   | ** 隶书        | LiSu                    |
| 27   | ** 幼圆        | YouYuan                 |
| 28   | ** 华文中宋      | STZhongsong             |
| 29   | ** 方正舒体      | FZShuTi                 |
| 30   | ** 方正姚体      | FZYaoti                 |
| 31   | ** 华文彩云      | STCaiyun                |
| 32   | ** 华文琥珀      | STHupo                  |
| 33   | ** 华文隶书      | STLiti                  |
| 34   | ** 华文行楷      | STXingkai               |
| 35   | ** 华文新魏      | STXinwei                |
| 36   | ** 文泉驿微米黑    | Wenquanyi Micro Hei     |
| 37   | ** 文泉驿正黑     | WenQuanYi Zen Hei       |
| 38   | ** 文泉驿点阵正黑   | WenQuanYi Zen Hei Sharp |

## 相关链接

1. **Font Awesome**: <http://fontawesome.io/>
2. **Webdings和Wingdings字符码对应表**: <http://dwz.cn/2jOjYi>
3. **CSS魔法堂：再次认识 font** by **肥仔John** on `2015/3/3`: <http://www.cnblogs.com/fsjohnhuang/p/4310533.html>
4. **有字库-中文在线字体**: <http://www.youziku.com/>
5. **谈谈网页设计中的字体应用 (2) serif 和 sans-serif** by **棕熊** on `2008/5/6`: <http://www.cnblogs.com/ruxpinsp1/archive/2008/05/06/font-in-front-end-development-2.html>
6. **Serif 和 Sans Serif 字体的区别** by **冰火九九** on `2013/11/4`: <http://blog.jobbole.com/50828/>
7. **Chinese Web Font Guide** by **Kendra Schaefer** on `2012/6/11`: <http://www.kendraschaefer.com/2012/06/chinese-standard-web-fonts-the-ultimate-guide-to-css-font-family-declarations-for-web-design-in-simplified-chinese/>
8. **Fonts.css – 跨平台中文字体解决方案**: <http://zenozeng.github.io/fonts.css/>

本文标题:[CSS font-family 网页字体使用小结](http://moxfive.xyz/2015/12/09/css-font-family/)

文章作者:[MOxFIVE](http://moxfive.xyz/)

发布时间:2015-12-09, 00:33

最后更新:2016-04-20, 11:52

更新历史:** [Blame](https://github.com/MOxFIVE/Markdown-Archives-Backup/blame/master/_posts/2015-12-09.css-font-family.md), [History](https://github.com/MOxFIVE/Markdown-Archives-Backup/commits/master/_posts/2015-12-09.css-font-family.md)文本模式:** [.md Raw](https://raw.githubusercontent.com/MOxFIVE/Markdown-Archives-Backup/master/_posts/2015-12-09.css-font-family.md)

原始链接:[http://MOxFIVE.xyz/2015/12/09/css-font-family/](http://moxfive.xyz/2015/12/09/css-font-family/) **

许可协议:** ["署名-非商用-相同方式共享 3.0"](http://creativecommons.org/licenses/by-nc-sa/3.0/cn/) 转载请保留原文链接及作者。