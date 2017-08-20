## 用meta重定向



```html
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf8" />
<meta http-equiv="refresh" content="2;url=http://www.w3school.com.cn" />
</head>

<body>
<p>
对不起。我们已经搬家了。您的 URL 是 <a href="http://www.w3school.com.cn">http://www.w3school.com.cn</a>
</p>

<p>您将在 2 秒内被重定向到新的地址。</p>

<p>如果超过 2 秒后您仍然看到本消息，请点击上面的链接。</p>

</body>
</html>

```

**注意http-equiv属性设置为refresh，content用分号分隔重定向秒数与url** 

详细的meta标签参考：[HTML \<meta\>标签](http://www.w3school.com.cn/tags/tag_meta.asp) 