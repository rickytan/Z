//
//  AppHelper.h
//  iZJU
//
//  Created by sheng tan on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "Config.h"


@interface AppHelper : NSObject <UIActionSheetDelegate>

+ (id)sharedHelper;
+ (void)makeACallTo:(NSString*)number;
- (void)showCallerSheetWithTitle:(NSString*)title
                          number:(NSString*)numberOrNumbers;

@end


@interface NSString (Extension)
+ (BOOL)isNullOrEmpty:(NSString*)string;
- (NSString*)md5;
- (NSString*)stringByReplaceStringWithChar:(const char)p;
+ (NSString*)uniqueString;
+ (NSString*)documentsPath;
+ (NSString*)libraryPath;
+ (NSString*)cachePath;
+ (NSString*)downloadPath;
+ (NSString*)tmpPath;

@end

@interface NSData (Extension)
- (NSString*)base64String;
@end

@interface UIView (Extension)
- (void)chilingAnimation;
@end

static NSString *const UIDeviceDidShakeNotification = @"UIDeviceDidShakeNotification";

@interface UIWindow (Extension)

@end

typedef CGFloat (^TimingBlock)(CGFloat);

extern const TimingBlock CLElasticOutTimingFunction;
extern const TimingBlock CLEaseOutBounceTimingFunction;
