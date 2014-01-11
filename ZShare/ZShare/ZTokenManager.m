//
//  ZTokenManager.m
//  ZShare
//
//  Created by ricky on 14-1-11.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZTokenManager.h"

@implementation ZTokenManager

+ (void)load
{

}

+ (NSString *)generateTokenForFile:(NSString *)filePath
{
    short code = filePath.hash & 0xffff ^ 0xffff;
    NSString *token = [NSString stringWithFormat:@"00%02d%06du", code, filePath.hash];

    return token;
}

+ (BOOL)verifyToken:(NSString *)token
{
    return YES;
}

@end
