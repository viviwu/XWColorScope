//
//  ViewController.m
//  iPhotoFilter
//
//  Created by vivi wu on 2019/6/18.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "ViewController.h"
#import "XWAnonymousFaces.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage * originImage;
@end

@implementation ViewController

- (IBAction)pickPhoto:(id)sender {
    
}

- (IBAction)undoLastAction:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originImage = [UIImage imageNamed:@"IMG_0646.JPG"];
    self.imageView.image = self.originImage;
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    XWAnonymousFaces * filter = [[XWAnonymousFaces alloc]init];
    filter.inputImage = [[CIImage alloc] initWithImage:self.originImage];
    CIContext *context = [CIContext context];
    CIImage *output = filter.outputImage;
    CGImageRef image = [context createCGImage:output fromRect:filter.inputImage.extent];
    UIImage *endImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    self.imageView.image = endImage;
}


@end
