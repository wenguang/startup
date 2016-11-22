### golang 怎样编写go代码 —— 从0开始
***

###### 安装配置

从 **[官方下载](https://golang.org/dl/)** 安装包，安装目录在 **/usr/local/go**

设置环境变量，打开 **~/.bash_profile** 文件，加行 **export PATH=$PATH:/usr/local/go/bin**，
就可以用go命令了，如 go run、go build、go install 等

卸装就删除了 /usr/local/go 目录，再删除 /etc/paths.d/go 文件。

###### 程序构建的结构

go程序构建的结构就是可执行文件、包、和源文件都在一个统一目录下，这个统一目录随意指定，除了/usr/local/go目录，这里指定在 ~/go_path_test。

在 ~/.bash_profile 文件中加一行 **export GOPATH=$HOME/go_path_test**

执行文件、包和源文件对应的子目录为 bin/、pkg/、src/，bin/ 和 /pkg 是编译生成的。结构如下：

	GOPATH=~/go_path_test
	
	~/go_path_test
	    bin/
	    	hello                 # command executable
		pkg/
	    	darwin_amd64/          # this will reflect your OS and architecture
	        	github.com/wenguang/
	            	stringutil.a  # package object
		src/
	    	github.com/wenguang/
	        	hello/
	            	hello.go      # command source
	        	stringutil/
	            	reverse.go    # package source
            	

###### 编译生成

在编写好hello.go文件后，可以在hello/目录下运行 **go install**，就会在/bin下生成可执行文件hello，也可以在任何目录下运行 **go install github.com/wenguang/hello**，因为设置了GOPATH环境变量，在 go install 命令后加目录参数时，golang会自动在目录参数前加上 **$GOPATH/src**。

想要/bin目录生成的hello可执行文件在任何路径下执行，就在 ~/.bash_profile 加一行环境变量：**export PATH=$PATH:$GOPATH/bin**

同样编译生成了stringutil/下的源文件，就会生成 **pkg/darwin_amd64/github.com/wenguang/stringutil.a**

*源文件被编译生成后是可执行文件还是包就看源文件的第一行：**package xxx**，这个xxx要是main就是可执行文件，是别的就是包*

###### 引用包

	package main
	
	import (
		"fmt"
		"github.com/wenguang/stringutil"
	)
	
	func main() {
		fmt.Printf(stringutil.Reverse("!oG ,olleH"))
		fmt.Printf("\n")
	}


*import引入github.com/wenguang/stringutil包，注意不用绝对路径，darwin_amd64/也不用加*

参考：[https://golang.org/doc/code.html](https://golang.org/doc/code.html)


