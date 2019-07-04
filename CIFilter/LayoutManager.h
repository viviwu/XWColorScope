//
//  LayoutManager.h
//  CIFilter
//
//  Created by Justin Madewell on 11/29/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import GLKit;
#import "JDMCIController.h"


@class LayoutManager;

@protocol LayoutManagerDelegate <NSObject>

@optional
-(void)didChangeVectorValueTo:(CIVector*)newValue forKeyValue:(NSString*)keyValue;
-(void)isEditing:(BOOL)editing;

@end

@interface LayoutManager : NSObject

@property (nonatomic, assign) id<LayoutManagerDelegate> delegate;
@property (nonatomic, strong) NSString *keyValue;


-(id)initWithDelegate:(id<LayoutManagerDelegate>)delegate
               inView:(UIView*)view
          editingView:(GLKView*)editingView
               ofType:(VectorType)vectorType
            withTitle:(NSString *)title
          withDefault:(CIVector*)defaultValue
          andKeyValue:(NSString*)keyValue;

-(id)initWithDelegateForToneCurve:(id<LayoutManagerDelegate>)delegate
                           inView:(UIView*)view
                      editingView:(GLKView*)editingView
                  withInputParams:(NSDictionary*)inputParams;


-(void)updateYPosition:(CGFloat)positionY;



-(void)cleanUpAndRemove;



@end
