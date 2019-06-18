//
//  UIColor+X.h
//  XWColorScope
//
//  Created by vivi wu on 2019/6/17.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (X)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor*) colorWithHex:(NSInteger)hexValue;

+ (NSString *) hexFromUIColor: (UIColor*) color;

+ (UIColor *) colorWithHexString: (NSString *) hexString;

+ (UIColor *) colorWithHexString: (NSString *)hexString withOpacity:(NSString *)opacity;

+ (UIColor *) colorWithRgbString: (NSString *) rgbString;

+ (UIColor *) colorWithRgbaString: (NSString *) rgbaString;

+ (NSString *) rgbFromUIColor: (UIColor*) color;

+ (NSString *) rgbaFromUIColor: (UIColor*) color;

@end

NS_ASSUME_NONNULL_END
