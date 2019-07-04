//
//  QRBarCodeControler.h
//  CIFilter
//
//  Created by Justin Madewell on 12/7/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDMCIController.h"
@import UIKit;

@class QRBarCodeControler;

@protocol QRBarCodeControlerDelegate <NSObject>

@optional
-(void)didChangeBarCodeValueTo:(NSData*)value forKeyValue:(NSString*)keyValue;
-(void)didChangeBarCorrectionLevelTo:(NSString *)value forKeyValue:(NSString *)keyValue;
@end



@interface QRBarCodeControler : NSObject < UITextViewDelegate >

@property (nonatomic, assign) id<QRBarCodeControlerDelegate> delegate;

-(id)initWithDelegate:(id<QRBarCodeControlerDelegate>)delegate
               inView:(UIView*)view
      withInputParams:(NSDictionary*)inputParams
       withFilterName:(NSString *)filterName;


@end
