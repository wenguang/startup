### data types & file types



**AFS支持的数据类型、asbd支持的数据类型、AudioFile.h中定义的文件类型**

Audio File Stream Services supports the following audio data types:
AIFF
AIFC
WAVE
CAF
NeXT
ADTS
MPEG Audio Layer 3
AAC 

Audio Data Format Identifiers

Identifiers for audio data formats, used in the AudioStreamBasicDescription structure.

enum {

   kAudioFormatLinearPCM               = 'lpcm',

   kAudioFormatAC3                     = 'ac-3',

   kAudioFormat60958AC3                = 'cac3',

   kAudioFormatAppleIMA4               = 'ima4',

   kAudioFormatMPEG4AAC                = 'aac ',

   kAudioFormatMPEG4CELP               = 'celp',

   kAudioFormatMPEG4HVXC               = 'hvxc',

   kAudioFormatMPEG4TwinVQ             = 'twvq',

   kAudioFormatMACE3                   = 'MAC3',

   kAudioFormatMACE6                   = 'MAC6',

   kAudioFormatULaw                    = 'ulaw',

   kAudioFormatALaw                    = 'alaw',

   kAudioFormatQDesign                 = 'QDMC',

   kAudioFormatQDesign2                = 'QDM2',

   kAudioFormatQUALCOMM                = 'Qclp',

   kAudioFormatMPEGLayer1              = '.mp1',

   kAudioFormatMPEGLayer2              = '.mp2',

   kAudioFormatMPEGLayer3              = '.mp3',

   kAudioFormatTimeCode                = 'time',

   kAudioFormatMIDIStream              = 'midi',

   kAudioFormatParameterValueStream    = 'apvs',

   kAudioFormatAppleLossless           = 'alac'

   kAudioFormatMPEG4AAC_HE             = 'aach',

   kAudioFormatMPEG4AAC_LD             = 'aacl',

   kAudioFormatMPEG4AAC_ELD            = 'aace',

   kAudioFormatMPEG4AAC_ELD_SBR        = 'aacf',

   kAudioFormatMPEG4AAC_HE_V2          = 'aacp',

   kAudioFormatMPEG4AAC_Spatial        = 'aacs',

   kAudioFormatAMR                     = 'samr',

   kAudioFormatAudible                 = 'AUDB',

   kAudioFormatiLBC                    = 'ilbc',

   kAudioFormatDVIIntelIMA             = 0x6D730011,

   kAudioFormatMicrosoftGSM            = 0x6D730031,

   kAudioFormatAES3                    = 'aes3'

};

Audio Data Format Identifiers 枚举是个char数组，asbd中对应的mFormatID是UInt32，char是8bit，UInt32是32bit，UInt32 to char array之类的转换是类C语言的基本功！

Built-In Audio File Types

Operating system constants that indicate the type of file to be written or a hint about what type of file to expect from data provided.

enum {

   kAudioFileAIFFType            = 'AIFF',

   kAudioFileAIFCType            = 'AIFC',

   kAudioFileWAVEType            = 'WAVE',

   kAudioFileSoundDesigner2Type  = 'Sd2f',

   kAudioFileNextType            = 'NeXT',

   kAudioFileMP3Type             = 'MPG3',

   kAudioFileMP2Type             = 'MPG2',

   kAudioFileMP1Type             = 'MPG1',

   kAudioFileAC3Type             = 'ac-3',

   kAudioFileAAC_ADTSType        = 'adts',

   kAudioFileMPEG4Type           = 'mp4f',

   kAudioFileM4AType             = 'm4af',

   kAudioFileCAFType             = 'caff',

   kAudioFile3GPType             = '3gpp',

   kAudioFile3GP2Type            = '3gp2',

   kAudioFileAMRType             = 'amrf'

};

typedef UInt32 AudioFileTypeID;