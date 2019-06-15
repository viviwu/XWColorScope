//
//  XWCameraViewController.m
//  XWColorScope
//
//  Created by vivi wu on 2019/6/15.
//  Copyright © 2019 vivi wu. All rights reserved.
//

//#import <AVKit/AVKit.h>
//#import <CoreVideo/CoreVideo.h>
//#import <CoreMedia/CoreMedia.h>
//#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import "XWCameraViewController.h"

@interface XWCameraViewController ()
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureStillImageOutput *captureOutput;
@end

@implementation XWCameraViewController
@synthesize session,captureOutput;

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建会话层
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    //2.创建、配置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!captureInput)
    {
        NSLog(@"Error: %@", error);
        return;
    }
    [self.session addInput:captureInput];
    
    captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [captureOutput setOutputSettings:outputSettings];
    
    [self.session addOutput:captureOutput];
    // Do any additional setup after loading the view.
}
/*
//切换摄像头方向
- (void)changeCameraPositionWithCurrentIsFront:(BOOL)isFront {
    if (isFront) {
        [self.session stopRunning];
        [self.session removeInput:self.backCameraInput];
        if ([self.session canAddInput:self.frontCameraInput]) {
            [self.session addInput:self.frontCameraInput];
            [self.session startRunning];
        }
        
    } else {
        [self.session stopRunning];
        [self.session removeInput:self.frontCameraInput];
        if ([self.session canAddInput:self.backCameraInput]) {
            [self.session addInput:self.backCameraInput];
            [self.session startRunning];
        }
    }
    
    //解决输出镜像问题
    AVCaptureConnection *videoConnection = nil;
    for ( AVCaptureConnection *connection in [self.videoDataOut connections] )
    {
        NSLog(@"%@", connection);
        for ( AVCaptureInputPort *port in [connection inputPorts] )
        {
            NSLog(@"%@", port);
            if ( [[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
            }
        }
    }
    
    if([videoConnection isVideoOrientationSupported]) // **Here it is, its always false**
    {
        [videoConnection setVideoOrientation:[UIDevice currentDevice].orientation];
    }
    //设置前置摄像头镜像问题
    [self videoMirored];
}

//摄像头输入
- (AVCaptureDeviceInput *)backCameraInput {
    if (_backCameraInput == nil) {
        NSError *error;
        _backCameraInput = [[AVCaptureDeviceInput  alloc] initWithDevice:[self cameroWithPosition:AVCaptureDevicePositionBack] error:&error];
        if (error) {
            NSLog(@"后置摄像头获取失败");
        }
    }
    self.isDevicePositionFront = NO;
    return _backCameraInput;
}

- (AVCaptureDeviceInput *)frontCameraInput {
    if (_frontCameraInput == nil) {
        NSError *error;
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameroWithPosition:AVCaptureDevicePositionFront] error:&error];
        if (error) {
            NSLog(@"前置摄像头获取失败");
        }
    }
    self.isDevicePositionFront = YES;
    return _frontCameraInput;
}

//获取可用的摄像头
- (AVCaptureDevice *)cameroWithPosition:(AVCaptureDevicePosition)position{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] == 10.0) {
        AVCaptureDeviceDiscoverySession *dissession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInDuoCamera,AVCaptureDeviceTypeBuiltInTelephotoCamera,AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
        for (AVCaptureDevice *device in dissession.devices) {
            if ([device position] == position ) {
                return device;
            }
        }
    } else {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device position] == position) {
                return device;
            }
        }
    }
    return nil;
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
