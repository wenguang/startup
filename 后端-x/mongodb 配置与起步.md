### mongodb 配置与起步

安装：brew install mongodb，3.0.7 版本，安装目录在/usr/local/Cellar/mongodb

配置文件：/usr/local/etc/mongod.conf，以下是刚安装后时配置文件的内容：

	systemLog:
	  destination: file
	  path: /usr/local/var/log/mongodb/mongo.log
	  logAppend: true
	storage:
	  dbPath: /usr/local/var/mongodb
	net:
	  bindIp: 127.0.0.1


配置的相关路径可以更改的。

更多配置项参考：[https://docs.mongodb.com/v3.0/reference/configuration-options/](https://docs.mongodb.com/v3.0/reference/configuration-options/)

启动：mongod程序的默认写文件的目录是/data/db，用命令mongod启动会自动创建/data/db目录，若失败可手动创建和设置写权限。用加 --dbpath参数指定写路径启动，如：mongod --dbpath ~/Desktop/mongo/db。在mongod程序启动后（也就是启动了一个db实例），就可以启动mongo这个shell程序连接到db，用shell命令进行db操作了。

issue：那个/data/db目录和mongod.conf中dbPath指定的/usr/local/var/mongodb有什么不同？它们分别放着什么文件？

存储文件：在/data/db目录有文件local.ns、local.0、test.ns、test.0，两个库local和test，.ns文件是collection的元数据，.0文件是数据文件，数据多后还会有.1、.2、.3...等数据文件，新增的数据文件容量会比前一个大，这么设计保证小的数据库不浪费空间。

关闭：control+c即可shutdown掉mongod程序。

mongodb的组件程序：在安装目录的bin子目录下，有很多组件程序，如下程序启动的详细参数和说明见：[https://docs.mongodb.com/v3.0/reference/program/](https://docs.mongodb.com/v3.0/reference/program/)

核心程序：

* [mongod](https://docs.mongodb.com/v3.0/reference/program/mongod/)：mongodb的守护进程、它处理数据请求、管理数据问题及mongo的后台操作。
* [mongos](https://docs.mongodb.com/v3.0/reference/program/mongos/)：mongodb分片集群的路由服务，在分片集群定位要找的数据。mongos更多参数考见：
* [mongo](https://docs.mongodb.com/v3.0/reference/program/mongo/)：mongodb的JS Shell，提供系统管理和数据操作接口，它还提供Javascript环境。

二进制导入导出程序：[mongodump](https://docs.mongodb.com/v3.0/reference/program/mongodump/)、[mongorestore](https://docs.mongodb.com/v3.0/reference/program/mongorestore/)、[bsondump](https://docs.mongodb.com/v3.0/reference/program/bsondump/)、[mongooplog](https://docs.mongodb.com/v3.0/reference/program/mongooplog/)。

JSON、CSV、TSV格式导入导出程序：[mongoimport](https://docs.mongodb.com/v3.0/reference/program/mongoimport/)、[mongoexport](https://docs.mongodb.com/v3.0/reference/program/mongoexport/)。

诊断程序：[mongostat](https://docs.mongodb.com/v3.0/reference/program/mongostat/)、[mongotop](https://docs.mongodb.com/v3.0/reference/program/mongotop/)、[mongosniff](https://docs.mongodb.com/v3.0/reference/program/mongosniff/)、[mongoperf](https://docs.mongodb.com/v3.0/reference/program/mongoperf/)

mongo的GridFS文件系统交互工具：[mongofiles](https://docs.mongodb.com/v3.0/reference/program/mongofiles/)。


