## 从FDTemplateLayoutCell在ios10、ios11上出总是说起

FDT当初只要是为了解决适配ios7、ios8的自动行高的不同给出的优秀解决方案，既然ios7、ios8之间有差异，那随着ios升级到9、10、11，tableview本身的机制也会有不同，FDT也会出问题，这是一定的，请看issue: https://github.com/forkingdog/UITableView-FDTemplateLayoutCell/issues 。

**这就提示我们：在项目用开源库，不能满足于会用它，还得搞懂它的实现原理、深入其源码，这样当ios版本升级后或开源库本身升级后出问题时，就可以及时修改源码解决问题** 