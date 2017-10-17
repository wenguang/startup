## 动态引入—chunkFilename的作用



在动态引入时，我们还在配置上的output结点下加下

chuckFilename: '[name].bundle.js'，**那chunkFilename有什么用？** 

我们知道output.filename用'[name].bundle.js'就能对应入口文件，**但动态引入没法指定入口文件，chunkFilename就是为动态引入的模块生成独立的chunk** 

chuckFilename: '[name].bundle.js'中的[name]会被模块名代替，也可以用例如'[id].[chuckhash].bundle.js'，但还是[name]更多直观些



https://doc.webpack-china.org/configuration/output/#output-chunkfilename