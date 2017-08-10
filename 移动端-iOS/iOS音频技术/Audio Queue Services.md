### Audio Queue Services

**AQ编程流程**

​    1：创建AQ，指定播放或录音Callback。

​    2：设置AQ参数和属性，也就是AudioQueueSetParamter和AudioQueueSetProperty（属性值是通过其它Audio Services获取到的）。

​    3：应用AQ属性监听。

​    4：根据音频格式分配AQ Buffer，向Buffer填充数据，把它加入AQ。

​    5：启动AQ。

​    6：在不需要时，停止AQ，释放AQ。

**AQ播放回调的工作就是向Buffer填充数据，重加入AQ的过程：**

**This callback function is invoked each time its associated playback audio queue has acquired the data from an audio queue buffer, at which point the buffer is available for reuse. The newly-available buffer is sent to this callback in the inBuffer parameter. Typically, you write this callback to:**

- **Fill the newly-available buffer with the next set of audio data from a file or other buffer.**
- **Reenqueue the buffer for playback. To reenqueue a buffer, use the AudioQueueEnqueueBuffer or AudioQueueEnqueueBufferWithParameters function.**

参考 iOS5.1 Library > Audio & Video > Audio > Audio Queue Services Programing Guide > About Audio Queues 中的Figure1-4

**AQ属性监听流程**

​     1：AudioQueueAddPropertyListener把需要监听的AQ属性加到AudioQueuePropertyListenerProc中，不同的属性可以加到同一个回调函数中。

​     2：在回调函数获取AQ属性的相关信息，进行相关的处理。

​     3：在不需要时移除AQ属性监听。

**注意**：和Audio其他的Services一样，很多函数都是以OSStatus（指示函数是否操作成功）为返回值，而程序员需要的返回数据定义为函数的**输出参数**，若有返回非OSStatus的函数我们详细说明。**OSStatus**详细值见于 "**Audio Queue Result Codes**"

**处理AQ缓冲（AQ Buffer）的函数，包括分配缓冲、把缓冲加到AQ中、释放缓冲**

**AudioQueueAllocateBufferWithPacketDescriptions**：相对于AudioQueueAllocateBuffer只多了一个参数，*inNumberPacketDescriptions*，表示这个新分配的缓冲中需要多少个ASPD的个数。****

**AudioQueueEnqueueBuffer**：需要注意的是后俩参数有

​    {

​        *inNumPacketDesc：ASPD*的个数，以下3种情况为0

​        *inPacketDescs：const* 指向ASPD数组的指针，以下3种情况为NULL

​        1：CBR格式

​        2：录音功能

​        3：由AudioQueueAllocateBufferWithPacketDescriptions分配的缓冲重加入AQ（文档中用**reenqueueing**这个词）时，因为缓冲中已经指定了这两个数据

​    }

AudioQueueEnqueueBufferWithParameters：多了几个设置，**这个函数只用于播放功能**

**    **{

​        设置AudioQueueParameterEvent，AQ Param参数也只应用于播放功能

​    }****

**重要数据类型**

**AudioQueueBuffer**：AQ最常用的，它由AudioQueueAllocateBuffer分配，对VBR则需要AudioQueueAllocateBufferWithPacketDescriptions分配，由AudioQueueBufferFree释放

​    {

​        *mAudioData*：音频数据，const void指针

​        *mAudioDataByteSize*：字节数据

​        *mAudioDataBytesCapacity*：该Buffer的容量，分配设定不可变

​        *mUserData*：在回调函数中使用

​       * mPacketDescriptions*：const的ASPD指针，指向一个ASPD数组**（用于VBR）**

​       * mPacketDescriptionCount*：对于播放功能，程序员设置；对于录音功能，由AQ返回**（用于VBR）**

​        *mPacketDescriptionCapacity*：**（用于VBR）**

​    }

**AudioQueuePropertyID**

​    {

​    }

**AQ中的不透明数据类型（也叫不透明指针）**

- AudioQueueRef：它的工作是连接音频设备、管理内存、对压缩格式采用解码器等。
- AudioQueueBufferRef：它是一个AudioQueueBuffer类型指针。
- AudioQueueTimelineRef：

****

**问题收集**：

1：当把Buffers（比如3个）都填充了数据且加入到AQ中后再启动AQ，播放进度会跳过前面若个秒（**已解决**）。

​     参考 iOS5.1 Library > Audio & Video > Audio > Audio Queue Services Programing Guide > About Audio Queues 中的Figure1-4

2：待分配的AudioQueueBuffer的容量，即AudioQueueAllocateBuffer函数的inBufferByteSize参数大小。

3：用什么样的数据结构缓存AudioFileStream_PacketProc回调解析出来的音频数据。

4：播放本地文件音频，我们可以用AudioFileReadPackets方便地读取音频数据，那么通过AFS缓存的音频数据又该如何读取呢？