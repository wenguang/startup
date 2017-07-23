## CoreAudio数据类型



### ASBD&ASPD



#### AudioStreamBasicDescription（asbd）用来说明音频数据格式

**对于LPCM格式或者等量频道的CBR格式，ASBD已经足够了。但对于VBR格式或者非等量频道的CBR格式，每个packet都需要ASPD来说明。**

**ASBD的字段设为0表示该值未知或对格式不适用。**初始化ASBD：AudioStreamBasicDescription asbd = {0};

**mSampleRate**：采样率，我们最常用的采样频率是44.1kHz，它的意思是每秒取样44100次，我们还会使用48kHz甚至96kHz的采样频率，目前44.1kHz还是一个最通行的标准，有些人认为96kHz将是未来录音界的趋势。

**"****\*The mSampleRate field must be nonzero, except when this structure is used in a listing of supported formats .*****"**

**mBitsPerChannel**：采样的大小（比特数），通常有16、20、24。如单频道的LPCM音频，这个值为 mBitPerChannel = 8 * sizeof（AudioSampleType）; AudioSampleType为SInt16，所以它的值为16。

**mFormatID**：文件格式。

**mFormatFlags**：指出格式的细节，0表示没有指示，某些格式才有这个指示。用 **AudioStreamBasicDescription Flags** 的枚举。

**mChannelsPerFrame**：声道。**\*各个帧（采样）的频道数可能不一样?!***

****

**mBytesPerFrame：**= n * sizeof（AudioSampleType）或 = mBitsPerChannel / 8 * mChannelsPerFrame; n为声道数。

**mFramesPerPacket：**对于未压缩音频，这个值为1；VBR格式是个大的值，比如1024对应AAC，对于packet中有可变frame数的格式，值为0，如Ogg Vorbis。**根据MPEG简介+如何计算CBR-VBR MP3的播放时间.pdf文档中MPEG音频数据的描述和官方文档中deriveBufferSize函数的判断，可以断定这里的packet的概念等同于MPEG帧的概念，MP3，即MPEG-1 Layer III，不论CBR，还是VBR，每一帧的采样个数都是固定的1152个。**

**mBytesPerPacket**：= mBytesPerFrame * mFramesPerPacket; **对于VBR，它的值为0，每个packet的信息由AudioStreamPacketDescription说明**。**对于MP3，它表示MPEG帧的比特率。VBR的各个帧的比特率不同，故为0。******

**mReserved：**总为0。



#### AudioStreamPacketDescription（aspd）用来说明音频包的信息，有两种情况会用到ASPD。

1、 **VBR audio**

2、**CBR audio where the channels have unequel sizes**

****

**mDataByteSize**：包的字节数。

**mVaribleFramesInPacket**：对于每个packet有恒定frame数的格式，它的值为0。

**\*我们知道packet中的byte数可变才要用到ASPD，在packet中的frame数恒定时，那就只有frame中的byte数可变，也即声道可变***。

**mStartOffse****t**：该packet在缓冲中字节的偏移量。



### AudioSampleType

**typedef SInt16 AudioSampleType;  就是以单音频通道下，16-bit比特率的PCM编码方式为规范样本**

**PCM音频流的码率（比特率，bitRate）**：[采样率](http://baike.baidu.com/view/53433.htm)值×采样大小值×声道数 [bps](http://baike.baidu.com/view/32601.htm)。一个采样率为44.1KHz，采样大小为16bit，[双声道](http://baike.baidu.com/view/133690.htm)的PCM编码的文件，它的数据速率则为 44.1K×16×2 =1411.2 Kbps。将码率除以8,就可以得到这个音频的数据速率（也叫比特率bitRate，单位是Kbps），即176.4KB/s。这表示存储一秒钟采样率为44.1KHz，采样大小为16bit，双声道的PCM编码的音频信号，需要176.4KB的空间，1分钟则约为10.34M。

**Kbps：kilo bit per second，千比特每秒，这里的千比特等于1000bits，而不是1024bits。**



### Audio Data Format Identifiers

**Audio Data Format Identifiers**（音频数据格式标识），**注意是音频数据格式，而非音频文件格式！**

 [**LPCM**（Linear Pulse-code Medulation）线性脉冲编码调制](http://baike.baidu.com/view/1548718.htm)

[**MPEG4AAC**（Advanced Audio Coding）](http://baike.baidu.com/view/662413.htm)

**MPEG4AAC_HE、MPEG4AAC_LD、MPEG4AAC_ELD、MPEG4AAC_ELD_SBR、MPEG4AAC_HE_V2、MPEG4AAC_Spatial**

 [**AC3**](http://baike.baidu.com/view/172055.htm)

**IEC 60958 AC3**：A Key that specifies an AC-3 codec that provides data packaged for transport over an IEC 60958 conpliant digital audio interface.

**MPEGLayer1、MPEGLayer2、MPEGLayer3（MP3）**

****

**Apple IMA4**：这是一种压缩格式，将对16位体的音频文件进行4：1的压缩。这是面向iPhone设备的一种重要编码

[**Apple Lossless**](http://zh.wikipedia.org/wiki/Apple_Lossless) 

[**AMR**](http://zh.wikipedia.org/wiki/%E8%87%AA%E9%80%82%E5%BA%94%E5%A4%9A%E9%80%9F%E7%8E%87%E9%9F%B3%E9%A2%91%E5%8E%8B%E7%BC%A9) 