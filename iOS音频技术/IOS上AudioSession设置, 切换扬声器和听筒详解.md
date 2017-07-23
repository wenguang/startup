### IOS上AudioSession设置, 切换扬声器和听筒详解



**转载自：http://blog.csdn.net/xy5811/article/details/8563137**

****

**选择一个Category**

**AVAudioSessionCategoryAmbient **或 **kAudioSessionCategory_AmbientSound**——用于非以语音为主的应用，使用这个category的应用会随着静音键和屏幕关闭而静音。并且不会中止其它应用播放声音，可以和其它自带应用如iPod，safari等同时播放声音。注意：该Category无法在后台播放声音

**AVAudioSessionCategorySoloAmbient **或 **kAudioSessionCategory_SoloAmbientSound **——类似于**AVAudioSessionCategoryAmbient **不同之处在于它会中止其它应用播放声音。 这个category为默认category。该Category无法在后台播放声音

**AVAudioSessionCategoryPlayback **或 **kAudioSessionCategory_MediaPlayback**——用于以语音为主的应用，使用这个category的应用不会随着静音键和屏幕关闭而静音。

`AVAudioSessionCategoryRecord` 或 `kAudioSessionCategory_RecordAudio———`用于需要录音的应用，设置该category后，除了来电铃声，闹钟或日历提醒之外的其它系统声音都不会被播放。该Category只提供单纯录音功能。

**AVAudioSessionCategoryPlayAndRecord** 或 **kAudioSessionCategory_PlayAndRecord**——用于既需要播放声音又需要录音的应用，语音聊天应用(如微信）应该使用这个category。该Category提供录音和播放功能。

**AVAudioSessionCategoryAudioProcessing **或 **kAudioSessionCategory_AudioProcessing**`————`当需要进行离线语音处理时使用这个category，这里我也不太明白离线语音处理是什么概念，希望有知道的可以解释下。

**注意**：并不是一个应用只能使用一个category，程序应该根据实际需要来切换设置不同的category，举个例子，录音的时候，需要设置为AVAudioSessionCategoryRecord，当录音结束时，应根据程序需要更改category为为AVAudioSessionCategoryAmbient，AVAudioSessionCategorySoloAmbient或AVAudioSessionCategoryPlayback中的一种。

**Property**

**kAudioSessionProperty_OverrideCategoryMixWithOthers 允许和其他app同时播放声音**

**kAudioSessionProperty_OtherMixableAudioShouldDuck   允许和其他app同时播放声音，但会将其他app的声音变小**

****

**如果想实现既能在后台播放声音，又能随着静音键而静音的功能，可以这么做：**

**[html]** [view plain](http://blog.csdn.net/xy5811/article/details/8563137#)[copy](http://blog.csdn.net/xy5811/article/details/8563137#)

1. setCategory(AVAudioSessionCategoryPlayBack);  
2. playSound();  
3. setCategory(AVAudioSessionCategoryAmbient);  

****

**设置Category**

**[cpp]** [view plain](http://blog.csdn.net/xy5811/article/details/8563137#)[copy](http://blog.csdn.net/xy5811/article/details/8563137#)

1. <span style="font-size: 14px;">NSError *setCategoryError = nil;  
2. ​    BOOL success = [[AVAudioSession sharedInstance]  
3. ​                    setCategory: AVAudioSessionCategoryAmbient  
4. ​                    error: &setCategoryError];  
5. ​      
6. ​    if (!success) { /* handle the error in setCategoryError */ }</span>  

****

**切换到扬声器**

****

按照苹果官方文档的说法，只有在category设置为AVAudioSessionCategoryPlayAndRecord时才能从扬声器播放声音，这一点我还未证实。

总之，按照官方文档的说法，先设置category为AVAudioSessionCategoryPlayAndRecord，然后通过重写audio route属性来重定向音频。

audio route属性有以下两个，一个是默认的听筒，另一个则是扬声器。

**[cpp]** [view plain](http://blog.csdn.net/xy5811/article/details/8563137#)[copy](http://blog.csdn.net/xy5811/article/details/8563137#)

1. enum {    
2.    kAudioSessionOverrideAudioRoute_None    = 0,  
3.    kAudioSessionOverrideAudioRoute_Speaker = 'spkr'  
4. };  

Override audio route的方法有如下两种：

**[cpp]** [view plain](http://blog.csdn.net/xy5811/article/details/8563137#)[copy](http://blog.csdn.net/xy5811/article/details/8563137#)

1. UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;  
2. ​      
3. ​    AudioSessionSetProperty (  
4. ​                             kAudioSessionProperty_OverrideAudioRoute  
5. ​                             sizeof (audioRouteOverride),  
6. ​                             &audioRouteOverride  
7. ​                             );  

**[cpp]** [view plain](http://blog.csdn.net/xy5811/article/details/8563137#)[copy](http://blog.csdn.net/xy5811/article/details/8563137#)

1. UInt32 doChangeDefaultRoute = 1;  
2. ​      
3. ​    AudioSessionSetProperty (  
4. ​                             kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,  
5. ​                             sizeof (doChangeDefaultRoute),  
6. ​                             &doChangeDefaultRoute  
7. ​                             );  

这两种方法区别在于：

使用kAudioSessionProperty_OverrideAudioRoute时，当发生任何中断如插拔耳机时，audio route就会重置回听筒，你必须再设置一次。

使用kAudioSessionProperty_OverrideCategoryDefaultToSpeaker则除非你更改category，否则会一直生效。