//
//  ZTokenManager.h
//  ZShare
//
//  Created by ricky on 14-1-11.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTokenManager : NSObject

+ (NSString *)generateTokenForFile:(NSString *)filePath;
+ (BOOL)verifyToken:(NSString *)token;
+ (NSString *)filePathForToken:(NSString *)token;

@end
