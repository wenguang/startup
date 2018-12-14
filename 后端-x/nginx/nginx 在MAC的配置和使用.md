### Nginx 在MAC的配置和使用

安装：brew install nginx，在/usr/local/Cellar下。

安装后nginx一些重要文件的路径：

* 配置文件：/usr/local/etc/nginx/nginx.conf
* 运行后pid文件：/usr/local/var/run/nginx.pid
* 日志文件目录：/usr/local/var/log/nginx
* 静态文件路径：/usr/local/var/www

issue

把nginx.conf的 http { server { 下的唯一的location结点注释掉，执行 nginx -s reload 浏览器仍可以访问。为什么？

nginx命令：

* nginx ：启动nginx
* nginx -s stop 
* nginx -s quit ：建议用这个，它允许worker把request处理完
* nginx -s reload ：修改nginx.conf后需要重新加载
* nginx -s reopen : 重新打开日志

下面是配置nginx.conf：

顶级结点，如worker_processes、events、http，像server、location就子结点，更全面参考：[http://nginx.org/en/docs/](http://nginx.org/en/docs/)。这里只配置下静态资源服务和代理服务，FastCGI代理由于未搭建，暂不配置，参考：[http://nginx.org/en/docs/beginners_guide.html](http://nginx.org/en/docs/beginners_guide.html)。

* 静态资源：在http结点下加以下配置段

   server {	
   	 	listen      8081;        
   	    server_name localhost;
   	    location / {
   	        root /ngxwww;
   	        index index2.html;
   	    }
   	}

* 代理服务：把http://localhost:8082 代理到vip主页

   server {
   	    listen    8082;
   	    server_name localhost;
   	    location / {
   	        proxy_pass http://www.vip.com;
   	    }
   	}

    



