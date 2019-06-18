//
//  UIImage+X.h
//  XWColorScope
//
//  Created by vivi wu on 2019/6/12.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (X)

#pragma mark -- reSize&Crop
-(UIImage*)scaleToSize:(CGSize)size;
-(UIImage *)crop:(CGRect) cropRect;

@end

NS_ASSUME_NONNULL_END
