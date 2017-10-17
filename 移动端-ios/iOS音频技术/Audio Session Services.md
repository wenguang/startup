### Audio Session Services



AudioSession是随着application的启动的，且是唯一对应的。所以在编写AudioSession功能时，把它放在AppDelegate或RootController中实现更好。

**利用AudioSession能完成以下方面的工作**

- 处理音频中断
- 处理音频路由（包括输入与输出）的变换
- 优化音频硬件规格参数（如：sample rate、I/O buffer duration）以适应不同类型的应用

**音频会话属性标识，它包括以下几个方面的属性**

- 会话类型、是否混合其他的会话、其他混合的会话是否降低音量

- 输入源、输出源、输入源是否可用

- 音频路由、路由变换、是否覆盖路由

- 中断类型、中断状态

- 硬件规格参数，包括偏好和当前的规格参数，有采样率、I/O缓冲持续时间、输入输出频道数、输入输出延迟

  ​

**切换到扬声器**

****

按照苹果官方文档的说法，只有在category设置为kAudioSessionCategory_PlayAndRecord时才能从扬声器播放声音。

audio route属性有以下两个，一个是默认的听筒，另一个则是扬声器。

enum {   

​     kAudioSessionOverrideAudioRoute_None    = 0,  

​     kAudioSessionOverrideAudioRoute_Speaker = 'spkr'  

​    };  

Override audio route两种方法区别在于：

使用kAudioSessionProperty_OverrideAudioRoute时，当发生任何中断如插拔耳机时，audio route就会重置回听筒，你必须再设置一次。

使用kAudioSessionProperty_OverrideCategoryDefaultToSpeaker则除非你更改category，否则会一直生效。

**在用到硬件规格参数时要注意**

- 对偏好规格参数的设置和获取要确保在会话启动前
- 要获取当前规格参数要确保在会话启动后