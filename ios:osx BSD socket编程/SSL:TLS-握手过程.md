基于这幅图来讲解

![](https://github.com/wenguang/startup/blob/master/imgs/tls-handshake.png?raw=true)

\#这就是SSL/TLS建立会话的握手阶段

```tex
第一步，爱丽丝给出协议版本号、一个客户端生成的随机数（Client random），以及客户端支持的加密方法。
第二步，鲍勃确认双方使用的加密方法，并给出数字证书、以及一个服务器生成的随机数（Server random）。
第三步，爱丽丝确认数字证书有效，然后生成一个新的随机数（Premaster secret），并使用数字证书中的公钥，加密这个随机数，发给鲍勃。
第四步，鲍勃使用自己的私钥，获取爱丽丝发来的随机数（即Premaster secret）。
第五步，爱丽丝和鲍勃根据约定的加密方法，使用前面的三个随机数，生成"对话密钥"（session key），用来加密接下来的整个对话过程。
```

最始的SSL的加密过程是这样的：

客户端（证书公钥加密会话内容） ————————>>   服务器（证书密钥解密会话内容）

客户端（证书公钥解密会话内容） <<————————   服务器（证书密钥加密会话内容）

**这种非对称的加密算法安全性虽高，但效率太低。于是之后就改为证书的公钥、密钥只对随机数作加解密，对加密后的随机数作为对称性加密的key，再对会话内容做对称性加密后传输。这就兼顾了安全和效率。** 



参考阮一峰的文章：[图解SSL/TLS协议](http://www.ruanyifeng.com/blog/2014/09/illustration-ssl.html)、[SSL/TLS协议运行机制的概述](http://www.ruanyifeng.com/blog/2014/02/ssl_tls.html) 