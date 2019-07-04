//
//  NumericController.h
//  CIFilter
//
//  Created by Justin Madewell on 11/22/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class NumericController;

@protocol NumericControllerDelegate <NSObject>

@optional
-(void)didChangeNumericValueTo:(NSNumber*)newValue forKeyValue:(NSString*)keyValue;

@end


@interface NumericController : NSObject

@property (nonatomic, assign) id<NumericControllerDelegate> delegate;
@property (nonatomic, strong) NSString *keyValue;

-(id)initWithDelegate:(id<NumericControllerDelegate>)delegate
               inView:(UIView*)view
            withTitle:(NSString *)title
              withMin:(CGFloat)min
               andMax:(CGFloat)max
          withDefault:(CGFloat)defaultValue
          andKeyValue:(NSString*)keyValue;

-(void)updateYPosition:(CGFloat)positionY;

-(void)cleanUpAndRemove;


@end
