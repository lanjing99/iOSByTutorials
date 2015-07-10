//
//  ViewController.m
//  ColloQR
//
//  Created by lanjing on 15/7/10.
//  Copyright (c) 2015年 WaterWood. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;

@interface ViewController ()

@end

@implementation ViewController
{
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
}


-(void)setupCaptureSession
{
    if(_captureSession) return;
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(!_videoDevice)
    {
        NSLog(@"No video camera on this device!");
        return;
    }
    
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:nil];
    _captureSession = [[AVCaptureSession alloc] init];
    if([_captureSession canAddInput:_videoInput])
    {
        [_captureSession addInput:_videoInput];
    }
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResize;
}


    






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupCaptureSession];
    _previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_previewLayer];
}

-(void)startRunning
{
    if(_running) return;
    [_captureSession startRunning];
    _running = YES;
}

-(void)stopRunning
{
    if(!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startRunning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end










