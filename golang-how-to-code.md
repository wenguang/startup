### golang 安装配置卸装
***
从 [官方下载](https://golang.org/dl/)安装包，安装目录在 /usr/local/go

设置环境变量，打开 ~/.bash_profile 文件，加行 export PATH=$PATH:/usr/local/go/bin

卸装就删除了 /usr/local/go 目录，再删除 /etc/paths.d/go 文件。