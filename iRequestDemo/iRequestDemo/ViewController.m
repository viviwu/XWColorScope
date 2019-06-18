//
//  ViewController.m
//  iRequestDemo
//
//  Created by vivi wu on 2019/6/18.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self postRequest];
}

#define POST_URL @"http://1167012354.ax.nofollow.51wtp.com/index.php/toupiao/h5/vote"

#define POST_BODY @"id=2avaasQRmGyx&vid=gxkmo7rxj1ry6e5&token=1774"

- (void)postRequest
{
    // Block方法
    NSURL *url = [NSURL URLWithString:POST_URL];
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    
    NSString *dataString = POST_BODY;
    NSData *postData = [dataString dataUsingEncoding: NSUTF8StringEncoding];
    [mRequest setHTTPMethod:@"POST"];
    [mRequest setHTTPBody:postData];
    
    NSURLSession *sessin = [NSURLSession sharedSession];
    NSURLSessionTask *task = [sessin dataTaskWithRequest:mRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@=post-block", dict ?: (data?:response));
        }
    }];
    
    [task resume];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
    
}


#define GET_URL @""

- (void)getRequest{
    
    NSURL *url = [NSURL URLWithString:GET_URL];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (error == nil) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@=get-block", dict);
    }
    }];
    
    [task resume];
}

@end
