//
//  XWColorMapperViewController.m
//  XWColorScope
//
//  Created by vivi wu on 2019/6/17.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "XWColorMapperViewController.h"

@interface XWColorMapperViewController ()
@property (weak, nonatomic) IBOutlet UIView *colorGradientView;
@property (weak, nonatomic) IBOutlet UIImageView *colorIV;
@property (weak, nonatomic) IBOutlet UILabel *reflecter;
@property (copy, nonatomic) NSString * colorInfo;

@end

@implementation XWColorMapperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ColorMapper";
    [self colorGradientDraw];
//    [self colorGradientLayerDraw];
    // Do any additional setup after loading the view.
}

- (void)colorGradientLayerDraw{
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.colorGradientView.bounds;
    gradientLayer.colors = @[(id)[UIColor orangeColor].CGColor, (id)[UIColor yellowColor].CGColor, (id)[UIColor greenColor].CGColor, (id)[UIColor blueColor].CGColor, (id)[UIColor purpleColor].CGColor, (id)[UIColor redColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);   //[0,0] is the bottom-left
    gradientLayer.endPoint = CGPointMake(1, 1);     //[1,1] is the top-right
    [self.colorGradientView.layer addSublayer:gradientLayer];
//    gradientLayer.locations =@[@(0.0f), @(1.0f)];
//    locations的作用是控制渐变发生的位置
}

- (void)colorGradientDraw{
     CGSize size = self.colorIV.frame.size;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        for (int i = 0; i < size.width; i++)
        {
            CGContextMoveToPoint(context, i, 0);
            CGContextAddLineToPoint(context, i, size.width);
            UIColor *color = [UIColor colorWithHue:i/size.width saturation:1 brightness:1 alpha:1];
            [color setStroke];
            CGContextSetLineWidth(context, 1);
            CGContextStrokePath(context);
        }
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.colorIV.image = image;
        });
    });
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [touches.anyObject locationInView:self.colorIV];
    CGFloat hue = point.x/kScreenW;
    UIColor * color = [UIColor colorWithHue:hue saturation:1 brightness:1 alpha:1];
    self.reflecter.backgroundColor = color;
//    NSLog(@"UITouch CGPoint: %@", NSStringFromCGPoint(point));
    NSString * colorInfo = nil;
    if (kCGColorSpaceModelRGB == CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)))
    {
        const CGFloat * colorComponents = CGColorGetComponents(color.CGColor);
        if (CGColorGetNumberOfComponents(color.CGColor)<4)
        {
            colorInfo = [NSString stringWithFormat:@"{R:%.1f, G:%.1f, B:%.1f}", colorComponents[0], colorComponents[1], colorComponents[2]];
        }else{  //RGBA
            colorInfo = [NSString stringWithFormat:@"{R:%.1f, G:%.1f, B:%.1f, A:%.1f}", colorComponents[0], colorComponents[1], colorComponents[2], colorComponents[3]];
        }
        NSLog(@"colorInfo: RGBA = %@", colorInfo);
        self.reflecter.text = colorInfo;
        UIPasteboard * PS = [UIPasteboard generalPasteboard];
        PS.string = colorInfo;
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

@end
