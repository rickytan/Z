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
    char str[6];
    struct {
        uint32_t hash;
        uint16_t loweraddr;
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
            if (![_database executeUpdate:@"CREATE UNIQUE INDEX `token_index` ON files(`token`)"])
                NSLog(@"create index error: %@", _database.lastError);
        }
        else
            NSLog(@"create table error: %@", _database.lastError);
    }
}

+ (BOOL)writeRecord:(NSString *)filePath
{
    if ([_database executeUpdate:@"INSERT OR REPLACE INTO files (`token`, `filepath`) values (?, ?)", [NSNumber numberWithUnsignedInteger:filePath.hash].stringValue, filePath]) {
        return YES;
    }

    NSLog(@"error: %@", _database.lastError);
    return NO;
}

+ (NSString *)generateTokenForFile:(NSString *)filePath
{
    token_t token = {0};
    token.loweraddr = ([UIDevice currentDevice].addr.s_addr & 0xffff0000) >> 16;
    token.hash = filePath.hash;
    NSData *data = [NSData dataWithBytes:token.str
                                  length:sizeof(token.str)];
    NSString *tokenStr = [NSString stringWithFormat:@"00%@", [data base64Encoding]];
    
    [self writeRecord:filePath];
    return tokenStr;
}

+ (NSString *)filePathForToken:(NSString *)tokenString
{
    NSString *base64Code = [tokenString substringFromIndex:2];
    NSData *data = [base64Code base64DecodedData];
    token_t token = *(token_t *)data.bytes;
    NSUInteger fileHash = token.hash;
    FMResultSet *result = [_database executeQuery:@"SELECT * FROM files WHERE `token` = ? LIMIT 0,1", [NSNumber numberWithUnsignedInteger:fileHash].stringValue];
    if ([result next]) {
        NSString *filePath = [result stringForColumn:@"filepath"];
        return filePath;
    }
    return nil;
}

+ (NSString *)hostForToken:(NSString *)tokenString
{
    NSString *base64Code = [tokenString substringFromIndex:2];
    NSData *data = [base64Code base64DecodedData];
    token_t token = *(token_t *)data.bytes;
    struct in_addr addr = [UIDevice currentDevice].addr;
    addr.s_addr = (addr.s_addr & 0xffff) | (token.loweraddr << 8);
    NSString *host = [NSString stringWithUTF8String:inet_ntoa(addr)];
    return host;
}

+ (BOOL)verifyToken:(NSString *)token
{
    return [token hasPrefix:@"00"];
}

@end
