### socket杂记



setsockopt函数的optname参数选项

   SO_DEBUG 打开或关闭排错模式
   SO_REUSEADDR 允许在bind ()过程中本地地址可重复使用
   SO_TYPE 返回socket 形态.
   SO_ERROR 返回socket 已发生的错误原因
   SO_DONTROUTE 送出的数据包不要利用路由设备来传输.
   SO_BROADCAST 使用广播方式传送
   SO_SNDBUF 设置送出的暂存区大小
   SO_RCVBUF 设置接收的暂存区大小
   SO_KEEPALIVE 定期确定连线是否已终止.
   SO_OOBINLINE 当接收到OOB 数据时会马上送至标准输入设备
   SO_LINGER 确保数据安全且可靠的传送出去.