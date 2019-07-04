//
//  XImageMattingViewController.m
//  XWColorScope
//
//  Created by vivi wu on 2019/7/4.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "XImageMattingViewController.h"
#include "cubeMap.c"
//照片抠图: TouchRetouch

@interface XImageMattingViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewA;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewB;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImage * imageA;
@property (strong, nonatomic) UIImage * imageB;

@end

@implementation XImageMattingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ImageMatting";
    _imageA = [UIImage imageNamed:@"testPic1"];
    _imageB = [UIImage imageNamed:@"background1"];
    
    _imgViewA.image = _imageA;
    _imgViewB.image = _imageB;
//    _imageView.image = _imageA;
 
     CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
    NSLog(@"CIPhotoEffectChrome inputKeys:%@", filter.inputKeys);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self processImageMatting];
}
//    colorCubeFilter.inputKeys:(
//                               inputImage,
//                               inputCubeDimension,
//                               inputCubeData
//                               )
- (void)processImageMatting
{
    CIImage * inputImage = [CIImage imageWithCGImage:_imageA.CGImage];
    //CubeMap 参数(float minHueAngle, float maxHueAngle)
    //这个值域取决于你要去除的颜色的Hue值   绿色(50, 170)
    CubeMap cubeMap = createCubeMap(210,240);//蓝色
    NSData *inputData = [[NSData alloc]initWithBytesNoCopy:cubeMap.data
                                                    length:cubeMap.length
                                              freeWhenDone:true];
    
    CIFilter *colorCubeFilter = [CIFilter filterWithName:@"CIColorCube"];
    [colorCubeFilter setValue:inputImage forKey:kCIInputImageKey];
    [colorCubeFilter setValue:[NSNumber numberWithFloat:cubeMap.dimension] forKey:@"inputCubeDimension"];
    [colorCubeFilter setValue:inputData forKey:@"inputCubeData"];
    
    
    CIImage *outputImage = colorCubeFilter.outputImage;
    
    inputImage = [CIImage imageWithCGImage:_imageB.CGImage];
    CIFilter *sourceOverCompositingFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [sourceOverCompositingFilter setValue:outputImage forKey:kCIInputImageKey];
    [sourceOverCompositingFilter setValue:inputImage forKey:kCIInputBackgroundImageKey];
    
    outputImage = sourceOverCompositingFilter.outputImage;
    //获取绘图上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImage *cgImage = [context createCGImage:outputImage
                                     fromRect:outputImage.extent];
    _imageView.image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
}

@end
