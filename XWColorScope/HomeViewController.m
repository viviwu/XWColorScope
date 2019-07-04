//
//  HomeViewController.m
//  XWColorScope
//
//  Created by vivi wu on 2019/6/12.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "HomeViewController.h"
#import "XWCameraViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (IBAction)cameraShot:(id)sender {
//    [self performSegueWithIdentifier:@"camera" sender:self];
}

- (IBAction)videoRecord:(id)sender {
    [self performSegueWithIdentifier:@"camera" sender:self];
}

- (IBAction)openPhotoEditor:(id)sender {
    [self performSegueWithIdentifier:@"PhotoOptimize" sender:self];
}

- (IBAction)openBeautyMode:(id)sender {
//    [self performSegueWithIdentifier:@"PhotoOptimize" sender:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
