//
//  ViewController.m
//  ColloQR
//
//  Created by lanjing on 15/7/10.
//  Copyright (c) 2015年 WaterWood. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;


@interface Barcode : NSObject
@property (nonatomic, strong) AVMetadataMachineReadableCodeObject *metadataObject;
@property (nonatomic, strong) UIBezierPath *cornersPath;
@property (nonatomic, strong) UIBezierPath *boundingBoxPath;
@end

@implementation Barcode

@end

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
    NSMutableDictionary *_barcodes;
    AVSpeechSynthesizer *_speechSynthesizer;
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
    
    _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
}

-(void)startRunning
{
    if(_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes = _metadataOutput.availableMetadataObjectTypes;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:0
                                           error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    _running = YES;
}

-(void)stopRunning
{
    if(!_running) return;
    [_captureSession stopRunning];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    
    _running = NO;
}


- (Barcode*)processMetadataObject: (AVMetadataMachineReadableCodeObject*)code
{
    Barcode *barcode = _barcodes[code.stringValue];
    if (!barcode) {
        barcode = [Barcode new];
        _barcodes[code.stringValue] = barcode;
    }
    barcode.metadataObject = code;
    CGMutablePathRef cornersPath = CGPathCreateMutable();
    CGPoint point;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)code.corners[0], &point);
    CGPathMoveToPoint(cornersPath, nil, point.x, point.y);
    for (int i = 1; i < code.corners.count; i++) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)code.corners[i], &point);
        CGPathAddLineToPoint(cornersPath, nil,point.x, point.y);
    }
    CGPathCloseSubpath(cornersPath);
    barcode.cornersPath = [UIBezierPath bezierPathWithCGPath:cornersPath];
    CGPathRelease(cornersPath);

    barcode.boundingBoxPath = [UIBezierPath bezierPathWithRect:code.bounds];
    return barcode;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    
//    [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataObject *obj, NSUInteger idx,
//                                  BOOL *stop)
//        {
//            static int i = 0;
//            NSLog(@" at index : %d, Metadata: %@", i++, obj);
//        }
//     ];
    
    NSSet *originalBarcodes = [NSSet setWithArray:_barcodes.allValues];
    // 1
    NSMutableSet *foundBarcodes = [NSMutableSet new];
    [metadataObjects enumerateObjectsUsingBlock: ^(AVMetadataObject *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"Metadata: %@", obj); // 2
        if ([obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
        {
            // 3
            AVMetadataMachineReadableCodeObject *code = (AVMetadataMachineReadableCodeObject*)
            [_previewLayer transformedMetadataObjectForMetadataObject:obj];
            // 4
            Barcode *barcode = [self processMetadataObject:code];
            [foundBarcodes addObject:barcode]; }
    }];
    NSMutableSet *newBarcodes = [foundBarcodes mutableCopy];
    [newBarcodes minusSet:originalBarcodes];
    NSMutableSet *goneBarcodes = [originalBarcodes mutableCopy]; [goneBarcodes minusSet:foundBarcodes];
    [goneBarcodes enumerateObjectsUsingBlock: ^(Barcode *barcode, BOOL *stop) {
        [_barcodes removeObjectForKey:barcode.metadataObject.stringValue];
    }];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        // Remove all old layers
        // 5
        NSArray *allSublayers = [self.view.layer.sublayers copy];
        [allSublayers enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
            if (layer != _previewLayer) {
            [layer removeFromSuperlayer]; }
            }
         ];
        // Add new layers
        // 6
        [foundBarcodes enumerateObjectsUsingBlock: ^(Barcode *barcode, BOOL *stop) {
            CAShapeLayer *boundingBoxLayer = [CAShapeLayer new];
            boundingBoxLayer.path = barcode.boundingBoxPath.CGPath;
            boundingBoxLayer.lineWidth = 2.0f;
            boundingBoxLayer.strokeColor = [UIColor greenColor].CGColor;
            boundingBoxLayer.fillColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.5f].CGColor;
            [self.view.layer addSublayer:boundingBoxLayer];
            
            CAShapeLayer *cornersPathLayer = [CAShapeLayer new];
            cornersPathLayer.path = barcode.cornersPath.CGPath;
            cornersPathLayer.lineWidth = 2.0f;
            cornersPathLayer.strokeColor = [UIColor blueColor].CGColor;
            cornersPathLayer.fillColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f].CGColor;
            [self.view.layer addSublayer:cornersPathLayer];
        }];
    
        [newBarcodes enumerateObjectsUsingBlock: ^(Barcode *barcode, BOOL *stop) {
//            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:barcode.metadataObject.stringValue];
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"明月皎皎照我床,星汉西流夜未央 的意思_全诗赏析"];
            
            utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
//            AVSpeechUtteranceMinimumSpeechRate + ((AVSpeechUtteranceMaximumSpeechRate -
//                                                   AVSpeechUtteranceMinimumSpeechRate) * 0.5f); utterance.volume = 1.0f;
            utterance.pitchMultiplier = 1.2f; [_speechSynthesizer speakUtterance:utterance];
        }];
    
    });
}

@end










