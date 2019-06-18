//
//  AppDelegate.h
//  iPhotoFilter
//
//  Created by vivi wu on 2019/6/18.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

