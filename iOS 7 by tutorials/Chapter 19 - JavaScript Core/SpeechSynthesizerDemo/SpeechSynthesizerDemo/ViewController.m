//
//  ViewController.m
//  SpeechSynthesizerDemo
//
//  Created by lanjing on 15/7/20.
//  Copyright (c) 2015年 WaterWood. All rights reserved.
//

#import "ViewController.h"
#import "HLSpeechSynthesizerManager.h"

@interface ViewController ()

@end

@implementation ViewController
{
    HLSpeechSynthesizerManager *_speechSynthesizerManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _speechSynthesizerManager = [[HLSpeechSynthesizerManager alloc] init];
    [_speechSynthesizerManager addVoiceSegmentWithString:@"this is a method"];
    [_speechSynthesizerManager addVoiceSegmentWithString:@"another method again"];

    
    [_speechSynthesizerManager addVoiceSegmentWithString:@"从明天起，from tomorrow, 做一个幸福的人"];
    [_speechSynthesizerManager addVoiceSegmentWithString:@"再见"];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
}

@end
