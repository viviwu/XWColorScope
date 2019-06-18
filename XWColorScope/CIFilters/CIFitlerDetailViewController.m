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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeigh;

@property (weak, nonatomic) IBOutlet UITextView * textView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *sliderLabels;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;

@end

@implementation CIFitlerDetailViewController

- (IBAction)sliderValueChanged:(UISlider*)sender forEvent:(UIEvent *)event
{
    UILabel * sliderLabel = _sliderLabels[sender.tag];
    NSString * name = @"Hue";
    switch (sender.tag) {
        case 0:{
            
        }break;
        case 1:{
            name = @"Sat";
        }break;
        case 2:{
            name = @"Bri";
        }break;
            
        default:
            break;
    }
    sliderLabel.text = [NSString stringWithFormat:@"%@:%.1f", name, sender.value];
    
    UITouch * touch = event.allTouches.anyObject;
    if (UITouchPhaseEnded == touch.phase) {
        CGFloat h = (((UISlider *)_sliders[0]).value+10)/20;
        CGFloat s = (((UISlider *)_sliders[1]).value+10)/20;
        CGFloat b = (((UISlider *)_sliders[2]).value+10)/20;
        NSLog(@"UISlider--TouchPhaseEnded %f - %f - %f", h, s, b);
        UIColor * color = [UIColor colorWithHue:h saturation:s brightness:b alpha:1];
        UIImage * img = [self.originImage applyTintEffectWithColor: color];
        self.imageView.image = img;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#if 0   //kCGColorSpaceModelPattern
    UIColor * color = [UIColor colorWithPatternImage:self.originImage];
    CGFloat h=0,s=0,b=0,a=0;
    NSLog(@"UISlider--UITouchPhaseEnded %f - %f - %f", h, s, b);
    if ([color respondsToSelector: @selector(getHue:saturation:brightness:alpha:)] ) {
        [color getHue:&h saturation:&s brightness:&b alpha:&a];
    }
    ((UISlider *)_sliders[0]).value = h * 20 - 10;
    ((UISlider *)_sliders[1]).value = s * 20 - 10;
    ((UISlider *)_sliders[2]).value = b * 20 - 10;
#endif
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
    self.imgHeigh.constant = kScreenW-20;
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
    CIContext *context = nil;
    if (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1) {
        //模拟器
        context = [CIContext contextWithOptions: @{kCIContextUseSoftwareRenderer : @(YES)}];//软件渲染 既CPU处理
    }else{
        //真机
        EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
        context = [CIContext contextWithEAGLContext:eaglContext options: @{kCIContextWorkingColorSpace: [NSNull null]}];
    }
    
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

- (IBAction)detectorAction:(UIButton *)sender
{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:[CIContext context] options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    CIImage *image = [[CIImage alloc] initWithImage:self.imageView.image];
    id orientation = [[image properties] valueForKey: CFBridgingRelease(kCGImagePropertyOrientation)];
    NSArray *features = [detector featuresInImage:image options:orientation ? @{CIDetectorImageOrientation: orientation} : nil];
    
    if (features && features.count > 0) {
        CGSize size = self.originImage.size;
        UIGraphicsBeginImageContext(size);
        [self.originImage drawInRect: (CGRect){{0, 0}, size}];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:size.width/60], NSForegroundColorAttributeName: [UIColor redColor]};
        for (CIFaceFeature *feature in features) {
            CGRect rect = (CGRect){{feature.bounds.origin.x, size.height - feature.bounds.origin.y - feature.bounds.size.height}, feature.bounds.size};
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextAddRect(context, rect);
            CGContextSetLineWidth(context, size.width/400);
            [[UIColor greenColor] setStroke];
            CGContextDrawPath(context, kCGPathStroke);
            if ([feature hasLeftEyePosition]) {
                [@"左眼" drawAtPoint:(CGPoint){feature.leftEyePosition.x, size.height - feature.leftEyePosition.y} withAttributes:attributes];
            }
            if ([feature hasRightEyePosition]) {
                [@"右眼" drawAtPoint:(CGPoint){feature.rightEyePosition.x, size.height - feature.rightEyePosition.y} withAttributes:attributes];
            }
            if ([feature hasMouthPosition]) {
                [@"嘴巴" drawAtPoint:(CGPoint){feature.mouthPosition.x, size.height - feature.mouthPosition.y} withAttributes:attributes];
            }
        }
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.imageView.image = newImage;
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有检测到面孔" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
