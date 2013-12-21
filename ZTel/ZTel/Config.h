//
//  Config.h
//  iZJU
//
//  Created by sheng tan on 12-10-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef iZJU_Config_h
#define iZJU_Config_h

#ifndef DEBUG
#define NSLog(string,...) {}
#endif

#define IS_IOS_5 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f)
#define IS_IOS_6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f)
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IS_IPHONE_5 ([UIScreen mainScreen].bounds.size.height > 480.0f)
//#define IS_IOS_5 (__IPHONE_OS_VERSION_MIN_REQUIRED >= 50000)
#define IS_ARC __has_feature(objc_arc)

#define DEFAULT_COLOR_SCHEME [UIColor colorWithRed:9.0/255\
                                             green:33.0/255\
                                              blue:84.0/255\
                                             alpha:1.0f]
#define RGB(__r,__g,__b) [UIColor colorWithRed:(1.0*(__r)/255)\
                                         green:(1.0*(__g)/255)\
                                          blue:(1.0*(__b)/255)\
                                         alpha:1.0f]

#define IS_ARC __has_feature(objc_arc)

static NSString *const server_host_name = @"www.izju.org";
static NSString *const server_api_version = @"v1";


static NSString *const iZJUUserFavoritePhoneKey = @"iZJUUserFavoritePhoneKey";
static NSString *const iZJUUserEmailAccountKey = @"iZJUUserEmailAccountKey";

#endif
