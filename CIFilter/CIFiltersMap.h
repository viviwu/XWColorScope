//
//  CIFiltersMap.h
//  CIFilter
//
//  Created by Justin Madewell on 11/15/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import GLKit;

#import "JDMCIController.h"

@class CIFiltersMap;

@protocol CIFiltersMapDelegate <NSObject>

@optional
-(void)didUpdateInputParameters:(NSDictionary*)newParameters;
@end
 

@interface CIFiltersMap : NSObject < ColorControllerDelegate, NumericControllerDelegate, LayoutManagerDelegate, QRBarCodeControlerDelegate >

@property (nonatomic, assign) id<CIFiltersMapDelegate> delegate;

@property (nonatomic, strong) NSArray *cellData;
@property (nonatomic, strong) NSArray *cellSections;
@property (nonatomic, strong) NSArray *cellSectionTitles;



//@property (nonatomic, strong) NSArray *tableViewData;

@property (nonatomic, strong) NSDictionary *tableViewData;



@property (nonatomic, strong) UIView *controllerView;
@property (nonatomic, strong) NSString *filterName;
@property (nonatomic, strong) NSString *filterDisplayName;

@property (nonatomic, strong) NSDictionary *inputParamaters;

@property BOOL shouldKeepEditedImage;
@property BOOL isEditingOnImageView;

-(void)reset;

-(void)loadView:(UIView *)view editingView:(GLKView*)editingView withControlsForFilter:(NSString*)filterDisplayName withImage:(UIImage*)image;
-(id)initWithDelegate:(id<CIFiltersMapDelegate>)delegate;

-(NSArray*)makeSectionIndexArray;

-(UIImage*)getEditedImage;

@end
