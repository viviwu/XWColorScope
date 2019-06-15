//
//  CIFitlerDetailViewController.m
//  XWColorScope
//
//  Created by vivi wu on 2019/6/12.
//  Copyright © 2019 vivi wu. All rights reserved.
//
#import <MobileCoreServices/UTCoreTypes.h>
#import "CIFitlerDetailViewController.h"
#import "JDMUtility.h"

@interface CIFitlerDetailViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UIImage *image;
@property UIImage *editImage;
//@property UIImage *fullsizeImage;

//@property (nonatomic, strong) CIContext  *context;
@property (nonatomic, strong) CIFilter* filter;
@property (nonatomic, strong) UIImage * originImage;

@property (weak, nonatomic) IBOutlet UIImageView *backingBlurView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView * textView;
@property (weak, nonatomic) IBOutlet UILabel* indicator;
@property (weak, nonatomic) IBOutlet UISlider* slider;

@end

@implementation CIFitlerDetailViewController

- (IBAction)sliderValueChanged:(UISlider*)sender {
    _indicator.text = [NSString stringWithFormat:@"%.1f", sender.value];
}


- (IBAction)showFilterInfo:(UIButton*)sender forEvent:(UIEvent *)event
{ 
    self.textView.hidden = sender.selected;
    sender.selected = !sender.selected;
    if (!_filter) {
        _filter = [CIFilter filterWithName:_filterName];
    }
    if (sender.selected) {
        self.textView.text = [NSString stringWithFormat:@"%@", _filter.attributes];
    }
}

- (IBAction)pickAssets:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
    imagePicker.delegate = self;    //mediaTypes:<kUTTypeGIF kUTTypeMovie>
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark-- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"MediaWithInfo: %@", info);
    self.originImage = info[UIImagePickerControllerEditedImage];
    [self configureImage:self.originImage];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)configureImage:(UIImage*)image
{
    UIImage *resizedImage = nil;
    
    if (image.size.width > image.size.height) {
        //NSLog(@"Wider");
        resizedImage = [image resizedImageByWidth:(int)self.view.frame.size.width];
    } else {
        //NSLog(@"Taller");
        resizedImage = [image resizedImageByHeight: (int)self.view.frame.size.width];
    }
    NSString *resizeString = [NSString stringWithFormat:@"%ix%i#", (int)self.view.frame.size.width,(int)self.view.frame.size.width];
    
    UIImage *editResizedImage = [image resizedImageByMagick:resizeString];
    self.editImage = editResizedImage;
    NSLog(@"self.editImage.size: %@", NSStringFromCGSize(self.editImage.size));
    
    UIImage *blurredImage = [image applyLightEffect];
    self.image = resizedImage;
    self.imageView.image = self.image;
    self.backingBlurView.image = blurredImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.originImage = [UIImage imageNamed:@"timg.jpeg"];
    self.imageView.image = self.originImage;
    [self configureImage:self.originImage];
    /*
#if 1
    //1.创建基于CPU的CIContext对象
    self.context = [CIContext contextWithOptions: @{kCIContextUseSoftwareRenderer : @(YES)}];
#else
    //2.创建基于GPU的CIContext对象
    self.context = [CIContext contextWithOptions: nil];
    //3.创建基于OpenGL优化的CIContext对象，可获得实时性能
    self.context = [CIContext contextWithEAGLContext:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]];
#endif
     */
    // Do any additional setup after loading the view.
    self.textView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_filterName) {
        _filterName = @"CIPhotoEffectChrome";
    }
    self.title = _filterName;
    
    [self filterContextCreateImage];
}


- (void)filterContextCreateImage{
    // 将UIImage转换成CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.originImage];
    // 创建滤镜
    CIFilter *filter = [CIFilter filterWithName:self.filterName withInputParameters:@{kCIInputImageKey: ciImage}];
    [filter setDefaults];
    
    // 获取绘制上下文
    CIContext *context = [CIContext contextWithOptions: @{kCIContextUseSoftwareRenderer : @(YES)}];//软件渲染 既CPU处理
    // 渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    // 创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage * newImage = [UIImage imageWithCGImage:cgImage];
    // 释放CGImage句柄
    CGImageRelease(cgImage);
    if (newImage) {
        self.imageView.image = newImage;
    }else{
        NSLog(@"[%@]outputImage is %@", self.filterName, newImage);
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIImage *)contextCreateImage:(UIImage *)image
                     filterName:(NSString *)filterName
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
#warning 不同的滤镜配置是不一样的
    CIFilter *filter = [CIFilter filterWithName: filterName keysAndValues: kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    // 获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    // 渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    // 创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage * newImage = [UIImage imageWithCGImage:cgImage];
    // 释放CGImage句柄
    CGImageRelease(cgImage);
    
    return newImage;
}
@end
