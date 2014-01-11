//
//  ZAppDelegate.h
//  ZShare
//
//  Created by ricky on 13-12-21.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MongooseDaemon.h"

@interface ZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MongooseDaemon *serverDaemon;

@end
