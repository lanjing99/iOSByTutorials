//
//  HLSpeechSynthesizerManager.m
//  SpeechSynthesizerDemo
//
//  Created by lanjing on 15/7/20.
//  Copyright (c) 2015年 WaterWood. All rights reserved.
//

#import "HLSpeechSynthesizerManager.h"

@import AVFoundation;

@interface HLSpeechSynthesizerManager ()

@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
@end

@implementation HLSpeechSynthesizerManager

-(void)addVoiceSegmentWithString:(NSString *)string
{

    __weak HLSpeechSynthesizerManager *weakSelf = self;
    

    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:string];

    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    utterance.volume = 1.0;
    utterance.pitchMultiplier = 1.2f;
    utterance.postUtteranceDelay = 0.5;
    [weakSelf.speechSynthesizer speakUtterance:utterance];

    NSLog(@"speaked %@", string);
}


-(void)stopAllVoiceSegments
{
    [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
}



-(AVSpeechSynthesizer *)speechSynthesizer
{
    if(!_speechSynthesizer)
    {
        _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
        [[AVAudioSession sharedInstance] setActive:YES withOptions:0 error:nil];
    }
    return _speechSynthesizer;
}
    
     
     
-(void)dealloc
{
    [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    
}

@end
