//
//  XWAnonymousFaces.h
//  iPhotoFilter
//
//  Created by vivi wu on 2019/6/18.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWAnonymousFaces : CIFilter
@property (strong, nonatomic) CIImage *inputImage;
@end

NS_ASSUME_NONNULL_END
