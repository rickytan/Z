//
//  NSString+Email.m
//  ZWork
//
//  Created by ricky on 14-3-23.
//  Copyright (c) 2014年 Ricky. All rights reserved.
//

#import "NSString+Email.h"

@implementation NSString (Email)

- (BOOL)isValidEmail
{
    NSString *regExp = @"[a-zA-Z0-9._%+-]+@([A-Za-z0-9-]+\\.)+[a-zA-Z]{2,4}";
    NSPredicate *match = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regExp];
    return [match evaluateWithObject:self];
}

@end
