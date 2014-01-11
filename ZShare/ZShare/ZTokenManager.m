//
//  ZTokenManager.m
//  ZShare
//
//  Created by ricky on 14-1-11.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZTokenManager.h"
#import "FMDatabase.h"

static FMDatabase * _database = nil;

@implementation ZTokenManager

+ (void)load
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/file.db"];
    _database = [FMDatabase databaseWithPath:path];
    if ([_database open]) {
        if ([_database executeUpdate:
             @"CREATE TABLE IF NOT EXITS files("
             @"   `token` VARCHAR UNIQUE,"
             @"   `filepath` VARCHAR"
             @")"]) {
            [_database executeUpdate:@"CREATA UNIQUE INDEX `token_index` ON files(`token`)"];
        }
    }
}

+ (NSString *)generateTokenForFile:(NSString *)filePath
{
    NSString *token = [NSString stringWithFormat:@"%010d", filePath.hash];
    
    return token;
}

+ (BOOL)verifyToken:(NSString *)token
{
    return YES;
}

@end
