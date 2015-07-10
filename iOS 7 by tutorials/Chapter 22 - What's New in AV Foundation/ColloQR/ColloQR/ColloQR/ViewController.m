//
//  ViewController.m
//  ColloQR
//
//  Created by lanjing on 15/7/10.
//  Copyright (c) 2015年 WaterWood. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation ViewController
{
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    AVCaptureMetadataOutput *_metadataOutput;
    BOOL _running;
}

#pragma mark - lift cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupCaptureSession];
    _previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_previewLayer];
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

#pragma mark - private methods
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
    
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue = dispatch_queue_create("com.razeware.ColloQR.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
}

-(void)startRunning
{
    if(_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes = _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}

-(void)stopRunning
{
    if(!_running) return;
    [_captureSession stopRunning];
    

    _running = NO;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    
    [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataObject *obj, NSUInteger idx,
                                  BOOL *stop)
        {
            static int i = 0;
            NSLog(@" at index : %d, Metadata: %@", i++, obj);
        }
     ];
}

@end










