### redis在mac上的安装和配置
下载redis安装包（压缩文件），把它拷到/usr/local路径下，解压，进入目录。redis是用ANSI C写的，用make来安装，执行命令 sudo make test，然后是sudo make install。安装完后会在/usr/local/bin目录下发现redis相关命令。此时运行命令 ./redis-server，会提示缺少redis.conf文件，下面就来配置下redis。

* 在/usr/local目录下，建redis目录及子目录bin、etc、db。
* 把/usr/local/bin下相关的redis命令拷到redis/bin目录下。
* 在etc目录下建redis.conf文件，编辑成如下内容：

    >####### 修改为守护模式
daemonize yes
####### 设置进程锁文件
pidfile /usr/local/redis/redis.pid
####### 端口
port 6379
####### 客户端超时时间
timeout 300
####### 日志级别
loglevel debug
####### 日志文件位置
logfile /usr/local/redis/log-redis.log
####### 设置数据库的数量，默认数据库为0，可以使用SELECT <dbid>命令在连接上指定数据库id
databases 8
####### 指定在多长时间内，有多少次更新操作，就将数据同步到数据文件，可以多个条件配合 save <seconds> <changes>  Redis默认配置文件中提供了三个条件：
save 900 1
save 300 10
save 60 10000
####### 指定存储至本地数据库时是否压缩数据，默认为yes，Redis采用LZF压缩，如果为了节省CPU时间，可以关闭该选项，但会导致数据库文件变的巨大
rdbcompression yes
####### 指定本地数据库文件名
dbfilename dump.rdb
####### 指定本地数据库路径
dir /usr/local/redis/db/
####### 指定是否在每次更新操作后进行日志记录，Redis在默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失。因为 redis本身同步数据文件是按上面save条件来同步的，所以有的数据会在一段时间内只存在于内存中
appendonly no
####### 指定更新日志条件，共有3个可选值： no：表示等操作系统进行数据缓存同步到磁盘（快） always：表示每次更新操作后手动调用fsync()将数据写到磁盘（慢，安全） everysec：表示每秒同步一次（折衷，默认值）
appendfsync everysec

上面看到redis启动后会与我们建的redis及子目录关联。
更多配置项：[http://www.redis.net.cn/tutorial/3504.html](http://www.redis.net.cn/tutorial/3504.html)

* 这里去bin目录启动 ./redis-server，就会发现配置目录下有redis.pid进程文件了，执行 tail -f log-redis.log 看日志。
* 执行 ./redis-cli 连接redis，就可以用redis命令了。