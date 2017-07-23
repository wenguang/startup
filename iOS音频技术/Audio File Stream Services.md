### Audio File Stream Services



**AFS的工作流程**：

1、AudioFileStreamOpen指定回调函数（AudioFileStream_PropertyListenerProc & AudioFileStream_PacketProc），且得到一个Parser（即AudioFileStreamID）。

2、AudioFileStreamParseBytes（函数可以指定**kAudioFileStreamParseFlag_Discontinuity**标志）向AFS中输送数据，交给回调函数处理。

3、完成工作时，调用AudioFileStreamClose函数。

**AFS Services 支持的音频数据格式**

- AIFF
- AIFC
- WAVE
- CAF
- NeXT
- ADTS
- MEPG Audio Layer 3
- AAC

**需要注意****，AudioFileStream_PacketProc回调函数的Discussion中这样描述**：

For constant-bit-rate（CBR）audio data, your callback is typically called with as much data as you passed to the AudioFileSteamParseBytes function. At times, however, only a single packet might be passed because of boundaries in the input data. for variable-bit-rate（VBR）audio data, your callback might be called servral times for each time you called the AudioFileSteamParseBytes function

**函数&回调**

****

**AudioFileStream_PacketProc**：测试VBR格式音频发现每次回调的字节数、aspd包数都不是固定的。.

**AudioFileStreamSeek**：始终不知道该怎么应用这个方法。

**属性和约束**

****

**kAudioFileStreamProperty_ReadyToProducePackets**：由于看到文档和AudioStreamer中对它的使用有些不解，我做了测试。结果发现callback总是先AudioFileStream_PropertyListenerProc，再到AudioFileStream_PacketProc，当AudioFileStream_PropertyListenerProc出现kAudioFileStreamProperty_ReadyToProducePackets时，就说明紧下来要到AudioFileStream_PacketProc了，因为AudioFileStream已经解析完audio property，开始到达audio packet了。这样看来[AudioStreamer](https://github.com/wenguang/AudioStreamer/blob/master/Classes/AudioStreamer.m)似乎把它用错了！

**kAudioFileStreamProperty_MaximumPacketSize和kAudioFileStreamProperty_PacketSizeUpperBound：**是否一个意思，待验证，有些音频没有这个属性。

**kAudioFileStreamProperty_DataFormat**：乍一看以为对应Core Audio Data Types Reference中的Audio Data Format IDs，其实它对应AudioStreamBasicDescription。

**kAudioFileStreamProperty_FileFormat**：乍一看以为对应文件后缀（这不需要AFS就能知道的，哈），其实它对应Core Audio Data Types Reference中的Audio Data Format IDs。

**kAudioFileStreamProperty_FormatList**：这是个比较复杂的属性，对ACC SBR需要更多的了解。

**kAudioFileStreamProperty_MagicCookieData**：对它我一直搞不太明白！

**有关AFS的难点问题及参考链接**

****

对HTTP流的Seeking

[http://www.cocoawithlove.com/2010/03/streaming-mp3aac-audio-again.html](http://www.cocoawithlove.com/2010/03/streaming-mp3aac-audio-again.html)

对AAC-HE格式的支持

[http://www.cocoawithlove.com/2010/03/streaming-mp3aac-audio-again.html](http://www.cocoawithlove.com/2010/03/streaming-mp3aac-audio-again.html)

计算VBR格式音频的duration

对AAC文件使用AudioFileStreamSeek函数不能正常工作

[http://lists.apple.com/archives/coreaudio-api/2009/Jun/msg00236.html](http://lists.apple.com/archives/coreaudio-api/2009/Jun/msg00236.html)