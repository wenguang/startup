## 平台差异—weex没有DOM和BOM



与DOM相关的操作不支持，当然也就不支持基于DOM接口的库，如JQ，没有DOM渲染、按我的理解在ios、andriod就用native渲染了。**那weex用在H5上又如何？一次编写多处运行又是如何做的呢？** 

weex提供了Native DOM APIs，看看它能干啥：https://weex.apache.org/cn/references/native-dom-api.html





weex不支持浏览器的BOM接口，浏览器中有window和screen对象设备环境信息，**在weex环境中用WXEnvironment变量** 

* WXEnvironment
  * weexVersion：weexSDK版本
  * appName: 应用名
  * appVersion：应用版本
  * platform：运行平台
  * osName：系统名称
  * osVersion：系统版本
  * deviceWidth：设备宽度
  * deviceHeight：设备高度