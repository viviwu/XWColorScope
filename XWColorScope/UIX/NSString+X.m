//
//  NSString+X.m
//  XWColorScope
//
//  Created by vivi wu on 2019/6/15.
//  Copyright © 2019 vivi wu. All rights reserved.
//
//#import <Foundation/NSString.h>
#import "NSString+X.h"

@implementation NSString (X)

- (BOOL)judgeBlankOrNil
{
    BOOL bRet=NO;
    if (nil == self || self.length<1) {
        bRet = YES;
    }
    if ([self stringByTrimmingCharactersInSet: NSCharacterSet.whitespaceCharacterSet].length==0) {
        bRet = YES;
    }
    return bRet;
}

@end
