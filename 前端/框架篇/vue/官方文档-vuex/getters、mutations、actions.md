## getters、mutations、actions



getters有点像vue组件中computed属性

mutations是唯一改变state的合法路径，它只支持同步操作，用store.commit(‘mutation名称’’)提交

actions负责提交mutations，而它不直接改变state，它支持异步操作，通常我们一些mutations一些前置操作放这里，比如网络获取数据...