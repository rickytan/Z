//
//  ZTokenManager.m
//  ZShare
//
//  Created by ricky on 14-1-11.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "ZTokenManager.h"
#import "FMDatabase.h"
#import "UIDevice+RExtension.h"
#import "NSString+RExtension.h"

static FMDatabase * _database = nil;

typedef union {
    uint32_t value;
    struct {
        uint16_t higher, lower;
    };
    struct {
        uint8_t b0, b1, b2, b3;
    };
} token_t;

@implementation ZTokenManager

+ (void)load
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/file.db"];
    _database = [FMDatabase databaseWithPath:path];
    if ([_database open]) {
        if ([_database executeUpdate:
             @"CREATE TABLE IF NOT EXISTS files("
             @"   `token` VARCHAR UNIQUE,"
             @"   `filepath` VARCHAR"
             @")"]) {
            if (![_database executeUpdate:@"CREATE UNIQUE INDEX IF NOT EXISTS `token_index` ON files(`token`)"])
                NSLog(@"create index error: %@", _database.lastError);
        }
        else
            NSLog(@"create table error: %@", _database.lastError);
    }
}

+ (BOOL)writeRecord:(NSString *)filePath
              token:(NSString *)token;
{
    if ([_database executeUpdate:@"INSERT OR REPLACE INTO files (`token`, `filepath`) values (?, ?)", token, filePath]) {
        return YES;
    }

    NSLog(@"error: %@", _database.lastError);
    return NO;
}

+ (NSString *)generateTokenForFile:(NSString *)filePath
{
    token_t token = {0};

    token.higher = ([UIDevice currentDevice].addr.s_addr & 0xffff0000) >> 16;
    token.lower = (filePath.hash >> 16) ^ filePath.hash;
    uint16_t checkSum = token.higher ^ token.lower;
    NSString *tokenStr = [NSString stringWithFormat:@"%02x%08x", (uint8_t)(checkSum >> 8 ^ (checkSum & 0xff)) & 0x7f, token.value];

    [self writeRecord:filePath token:tokenStr];
    return tokenStr;
}

+ (NSString *)filePathForToken:(NSString *)tokenString
{
    FMResultSet *result = [_database executeQuery:@"SELECT * FROM files WHERE `token` = ? LIMIT 0,1", tokenString];
    if ([result next]) {
        NSString *filePath = [result stringForColumn:@"filepath"];
        return filePath;
    }
    return nil;
}

+ (NSString *)hostForToken:(NSString *)tokenString
{
    token_t token = {0};
    sscanf(tokenString.UTF8String + 2, "%08x", &token.value);
    struct in_addr addr = [UIDevice currentDevice].addr;
    addr.s_addr = (addr.s_addr & 0xffff) | (token.higher << 16);
    NSString *host = [NSString stringWithUTF8String:inet_ntoa(addr)];
    return host;
}

+ (BOOL)verifyToken:(NSString *)tokenString
{
    if (tokenString.length == 10) {
        token_t token = {0};
        uint8_t checkSum = 0;
        sscanf(tokenString.UTF8String, "%02x%08x", (int *)&checkSum, &token.value);
        uint8_t result = (token.higher ^ token.lower) >> 8 ^ (token.higher ^ token.lower & 0xff);
        return checkSum == (result & 0x7f);
    }
    return NO;
}

@end
