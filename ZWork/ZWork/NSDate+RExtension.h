//
//  NSDate+RExtension.h
//  RTUsefulExtension
//
//  Created by ricky on 13-4-27.
//  Copyright (c) 2013年 ricky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RExtension)
+ (NSDate*)dateFromString:(NSString*)string;
+ (NSDate*)dateFromString:(NSString *)string withFormat:(NSString*)format;
- (NSString*)stringWithFormat:(NSString*)format;
- (NSString*)humanPreferredTimeString;
- (NSInteger)yearComponent;
- (NSInteger)monthComponent;
- (NSInteger)dayComponent;
- (NSInteger)weekComponent;
- (NSInteger)hourComponent;
- (NSInteger)minuteComponent;
- (NSInteger)secondComponent;
@end
